import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  // Fix: AuthService là singleton qua GetX, không tạo nhiều lần
  final AuthService _authService = AuthService();
  final GetStorage _storage = GetStorage();

  final RxBool isLoading = false.obs;
  final RxString accessToken = ''.obs;
  final RxString refreshToken = ''.obs;

  // Trạng thái ẩn/hiện mật khẩu
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Timer? _refreshTimer;

  @override
  void onInit() {
    super.onInit();
    _loadTokens();
  }

  @override
  void onClose() {
    _refreshTimer?.cancel();
    super.onClose();
  }

  void _loadTokens() {
    accessToken.value = _storage.read('accessToken') ?? '';
    refreshToken.value = _storage.read('refreshToken') ?? '';

    if (refreshToken.value.isNotEmpty) {
      _startTokenRefreshTimer();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      final tokens = await _authService.login(email, password);
      if (tokens != null) {
        _saveTokens(tokens);
        Get.offAllNamed(AppRoutes.main);
      }
    } catch (e) {
      if (e.toString() == 'VERIFICATION_REQUIRED') {
        // Fix: dùng toString() để so sánh chắc chắn
        Get.toNamed(AppRoutes.register, arguments: {'email': email});
      } else {
        Get.snackbar('Lỗi', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleLogin() async {
    try {
      isLoading.value = true;
      final tokens = await _authService.googleLogin();
      if (tokens != null) {
        _saveTokens(tokens);
        Get.offAllNamed(AppRoutes.main);
      }
      // tokens == null nghĩa là user bấm huỷ, không cần báo lỗi
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      isLoading.value = true;
      await _authService.register(
        email: email,
        password: password,
        fullName: name,
        phoneNumber: phone,
      );
    } catch (e) {
      if (e.toString() == 'VERIFICATION_REQUIRED') {
        Get.toNamed(AppRoutes.verifyOtp, arguments: {'email': email});
        Get.snackbar('Xác thực Email', 'Mã OTP đã được gửi đến email của bạn.');
      } else {
        Get.snackbar('Lỗi', e.toString());
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    try {
      isLoading.value = true;
      final tokens = await _authService.verifyOTP(email, otp);
      _saveTokens(tokens);
      Get.offAllNamed(AppRoutes.main);
      Get.snackbar('Thành công', 'Đăng ký và xác thực tài khoản thành công!');
    } catch (e) {
      Get.snackbar('Lỗi', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _saveTokens(Map<String, String> tokens) {
    accessToken.value = tokens['accessToken']!;
    refreshToken.value = tokens['refreshToken']!;

    _storage.write('accessToken', accessToken.value);
    _storage.write('refreshToken', refreshToken.value);

    _startTokenRefreshTimer();
  }

  void _startTokenRefreshTimer() {
    _refreshTimer?.cancel();
    // Refresh mỗi 50 phút (access token hết hạn sau 1h)
    _refreshTimer = Timer.periodic(const Duration(minutes: 50), (_) async {
      await refreshAccessToken();
    });
  }

  Future<void> refreshAccessToken() async {
    if (refreshToken.value.isEmpty) return;
    try {
      final tokens = await _authService.refresh(refreshToken.value);
      _saveTokens(tokens);
    } catch (e) {
      logout();
    }
  }

  Future<void> logout() async {
    _refreshTimer?.cancel();
    // Sign out Google nếu đang dùng
    await _authService.signOutGoogle();
    _storage.remove('accessToken');
    _storage.remove('refreshToken');
    accessToken.value = '';
    refreshToken.value = '';
    Get.offAllNamed(AppRoutes.login);
  }
}