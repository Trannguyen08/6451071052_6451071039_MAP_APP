import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';

class VerifyOtpScreen extends GetView<AuthController> {
  VerifyOtpScreen({super.key});

  final TextEditingController otpController = TextEditingController();
  final String email = Get.arguments?['email'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo and Title
              Row(
                children: [
                  const Icon(Icons.restaurant_menu, color: Colors.orange, size: 40),
                  const SizedBox(width: 10),
                  Text(
                    'FoodHero',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Xác thực email',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Text(
                'Mã xác thực đã được gửi đến $email',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // OTP Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mã OTP', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '000000',
                      filled: true,
                      fillColor: Colors.orange[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.verifyOTP(email, otpController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Xác thực',
                                style: TextStyle(fontSize: 18, color: Colors.white)),
                            SizedBox(width: 10),
                            Icon(Icons.check, color: Colors.white),
                          ],
                        ),
                )),
              ),
              const SizedBox(height: 20),

              // Resend OTP
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.snackbar('Thông báo', 'Mã OTP đã được gửi lại');
                  },
                  child: const Text(
                    'Gửi lại mã?',
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
