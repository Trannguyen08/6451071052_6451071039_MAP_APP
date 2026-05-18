import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthService {
  final CollectionReference _users = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'fastfood',
  ).collection('users');

  // Khởi tạo 1 lần duy nhất làm field của class
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Đối với Android/iOS, plugin tự đọc từ file cấu hình (google-services.json / GoogleService-Info.plist).
    // Chỉ cần truyền clientId khi chạy trên Web.
    clientId: kIsWeb ? dotenv.get('GOOGLE_CLIENT_ID') : null,
    scopes: ['email', 'profile'],
  );

  // 1. Hash Password
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // 2. Generate OTP
  String _generateOTP() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  // 3. Send OTP Email
  Future<void> _sendOTPEmail(String email, String otp) async {
    final smtpServer = gmail(
      dotenv.get('EMAIL_HOST_USER'),
      dotenv.get('EMAIL_HOST_PASSWORD'),
    );

    final message = Message()
      ..from = Address(dotenv.get('EMAIL_HOST_USER'), 'FoodHero App')
      ..recipients.add(email)
      ..subject = 'Mã xác thực tài khoản FoodHero'
      ..html =
          '''
        <h3>Chào mừng bạn đến với FoodHero!</h3>
        <p>Mã xác thực (OTP) của bạn là: <strong>$otp</strong></p>
        <p>Mã này có hiệu lực trong 5 phút.</p>
        <p>Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email.</p>
      ''';

    try {
      await send(message, smtpServer);
    } catch (e) {
      throw 'Không thể gửi email xác thực. Vui lòng kiểm tra lại địa chỉ email.';
    }
  }

  // 4. Register
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    if (email.isEmpty || !GetUtils.isEmail(email)) throw 'Email không hợp lệ';
    if (password.length < 6) throw 'Mật khẩu phải ít nhất 6 ký tự';

    var doc = await _users.where('email', isEqualTo: email).get();
    if (doc.docs.isNotEmpty) throw 'Email đã tồn tại';

    String otp = _generateOTP();

    UserModel newUser = UserModel(
      email: email,
      password: _hashPassword(password),
      fullName: fullName,
      phoneNumber: phoneNumber,
      isVerified: false,
      otp: otp,
      otpExpiry: DateTime.now().add(const Duration(minutes: 5)),
    );

    await _users.add(newUser.toFirestore());
    await _sendOTPEmail(email, otp);

    throw 'VERIFICATION_REQUIRED';
  }

  // 5. Login
  Future<Map<String, String>?> login(String email, String password) async {
    var query = await _users.where('email', isEqualTo: email).get();
    if (query.docs.isEmpty) throw 'Người dùng không tồn tại';

    var userData = query.docs.first.data() as Map<String, dynamic>;
    var user = UserModel.fromFirestore(userData, query.docs.first.id);

    if (user.password != _hashPassword(password)) throw 'Mật khẩu không đúng';

    if (!user.isVerified) {
      throw 'Tài khoản chưa được kích hoạt';
    }

    return _generateTokens(user);
  }

  // 6. Verify OTP
  Future<Map<String, String>> verifyOTP(String email, String otp) async {
    var query = await _users.where('email', isEqualTo: email).get();
    if (query.docs.isEmpty) throw 'Người dùng không tồn tại';

    var doc = query.docs.first;
    var user = UserModel.fromFirestore(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );

    if (user.otp != otp) throw 'Mã OTP không chính xác';
    if (user.otpExpiry!.isBefore(DateTime.now())) throw 'Mã OTP đã hết hạn';

    await _users.doc(user.id).update({
      'isVerified': true,
      'otp': null,
      'otpExpiry': null,
    });

    user.isVerified = true;
    return _generateTokens(user);
  }

  // 7. Token Generation
  Map<String, String> _generateTokens(UserModel user) {
    final accessJwt = JWT({
      'id': user.id,
      'email': user.email,
      'name': user.fullName,
      'avatar': user.avatar,
    });

    final accessToken = accessJwt.sign(
      SecretKey(dotenv.get('JWT_SECRET')),
      expiresIn: const Duration(hours: 1),
    );

    final refreshJwt = JWT({'id': user.id});
    final refreshToken = refreshJwt.sign(
      SecretKey(dotenv.get('JWT_REFRESH_SECRET')),
      expiresIn: const Duration(days: 30),
    );

    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  // 8. Refresh Token
  Future<Map<String, String>> refresh(String refreshToken) async {
    try {
      final jwt = JWT.verify(
        refreshToken,
        SecretKey(dotenv.get('JWT_REFRESH_SECRET')),
      );
      final userId = jwt.payload['id'];

      var doc = await _users.doc(userId).get();
      if (!doc.exists) throw 'User not found';

      final user = UserModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
      return _generateTokens(user);
    } catch (e) {
      throw 'Refresh token expired or invalid';
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }

  // 9. Google Login
  Future<Map<String, String>?> googleLogin() async {
    try {
      print('🔵 Bắt đầu Google Sign In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print('🔵 Google User: ${googleUser?.email}');

      if (googleUser == null) return null;

      var query = await _users
          .where('email', isEqualTo: googleUser.email)
          .get();

      UserModel user;
      if (query.docs.isEmpty) {
        // User mới — tạo tài khoản
        final newUser = UserModel(
          email: googleUser.email,
          fullName: googleUser.displayName,
          avatar: googleUser.photoUrl,
          isVerified: true,
        );
        var docRef = await _users.add(newUser.toFirestore());
        user = UserModel.fromFirestore(newUser.toFirestore(), docRef.id);
      } else {
        // User đã tồn tại
        var doc = query.docs.first;
        final userData = doc.data() as Map<String, dynamic>;
        final googleAvatar = googleUser.photoUrl ?? '';

        if ((userData['avatar'] ?? '').toString().isEmpty &&
            googleAvatar.isNotEmpty) {
          await _users.doc(doc.id).update({'avatar': googleAvatar});
          userData['avatar'] = googleAvatar;
        }

        user = UserModel.fromFirestore(userData, doc.id);
      }

      return _generateTokens(user);
    } catch (e) {
      print('Lỗi Google Login: $e');
      throw 'Không thể đăng nhập bằng Google';
    }
  }

  // 10. Sign Out Google (gọi khi logout)
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
