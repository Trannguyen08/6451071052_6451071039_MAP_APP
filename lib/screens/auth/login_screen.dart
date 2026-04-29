import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import '../../controller/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget _buildField(String label, String hint, IconData icon, {bool isPassword = false, TextEditingController? controller, RxBool? isHidden, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        isPassword 
          ? Obx(() => TextField(
              controller: controller,
              obscureText: isHidden?.value ?? true,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon),
                suffixIcon: IconButton(
                  icon: Icon(isHidden!.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: onToggle,
                ),
                filled: true,
                fillColor: Colors.orange[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ))
          : TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                prefixIcon: Icon(icon),
                filled: true,
                fillColor: Colors.orange[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                      fontStyle: FontStyle.italic,
                      color: Colors.orange[800],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Chào mừng trở lại!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Đăng nhập để tiếp tục khám phá món ngon cùng FoodHero',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              _buildField('Email hoặc Số điện thoại', 'name@example.com', Icons.person_outline, controller: emailController),
              const SizedBox(height: 20),
              
              // Password Field
              _buildField(
                'Mật khẩu', 
                '........', 
                Icons.lock_outline, 
                isPassword: true, 
                controller: passwordController,
                isHidden: controller.isPasswordHidden,
                onToggle: controller.togglePasswordVisibility,
              ),
              
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Quên mật khẩu?', style: TextStyle(color: Colors.orange)),
                ),
              ),
              const SizedBox(height: 20),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value 
                    ? null 
                    : () => controller.login(emailController.text, passwordController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: controller.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Đăng nhập', style: TextStyle(fontSize: 18, color: Colors.white)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                )),
              ),
              const SizedBox(height: 20),
              
              // Google Login
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => OutlinedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.googleLogin(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata, size: 30),
                      SizedBox(width: 10),
                      Text('Google', style: TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                )),
              ),
              const SizedBox(height: 40),
              
              // Register Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Chưa có tài khoản?', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.register),
                      child: const Text(
                        ' Đăng ký',
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
