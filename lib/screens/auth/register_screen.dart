import '../../controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetView<AuthController> {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void _onRegister() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar('Lỗi', 'Vui lòng điền đầy đủ thông tin');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Lỗi', 'Email không hợp lệ');
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar('Lỗi', 'Mật khẩu xác nhận không khớp');
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Lỗi', 'Mật khẩu phải từ 6 ký tự trở lên');
      return;
    }

    controller.register(email, password, name, phone);
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant_menu, color: Colors.orange, size: 40),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Gia nhập cộng đồng FoodHero ngay hôm nay!',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              
              // Fields
              _buildField('Họ tên', 'Nguyễn Văn A', Icons.person_outline, controller: nameController),
              const SizedBox(height: 20),
              _buildField('Email', 'example@email.com', Icons.email_outlined, controller: emailController),
              const SizedBox(height: 20),
              _buildField('Số điện thoại', '090 123 4567', Icons.phone_outlined, controller: phoneController),
              const SizedBox(height: 20),
              _buildField(
                'Mật khẩu', 
                '........', 
                Icons.lock_outline, 
                isPassword: true, 
                controller: passwordController,
                isHidden: controller.isPasswordHidden,
                onToggle: controller.togglePasswordVisibility,
              ),
              const SizedBox(height: 20),
              _buildField(
                'Xác nhận mật khẩu', 
                '........', 
                Icons.shield_outlined, 
                isPassword: true, 
                controller: confirmPasswordController,
                isHidden: controller.isConfirmPasswordHidden,
                onToggle: controller.toggleConfirmPasswordVisibility,
              ),
              
              const SizedBox(height: 30),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: controller.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Đăng ký', style: TextStyle(fontSize: 18, color: Colors.white)),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                )),
              ),
              const SizedBox(height: 20),
              
              // Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Bạn đã có tài khoản? ', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Đăng nhập', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

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
}
