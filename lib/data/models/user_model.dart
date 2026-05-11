class UserModel {
  final String? id;
  final String? email;
  final String? fullName;
  final String? phoneNumber;
  final String? password; // Hashed password
  final bool isVerified;
  final String? otp;
  final DateTime? otpExpiry;

  UserModel({
    this.id,
    this.email,
    this.fullName,
    this.phoneNumber,
    this.password,
    this.isVerified = false,
    this.otp,
    this.otpExpiry,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'],
      fullName: data['fullName'],
      phoneNumber: data['phoneNumber'],
      password: data['password'],
      isVerified: data['isVerified'] ?? false,
      otp: data['otp'],
      otpExpiry: data['otpExpiry'] != null ? (data['otpExpiry'] as dynamic).toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'password': password,
      'isVerified': isVerified,
      'otp': otp,
      'otpExpiry': otpExpiry,
    };
  }
}
