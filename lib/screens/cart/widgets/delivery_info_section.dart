import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/cart_controller.dart';

class DeliveryInfoSection extends StatelessWidget {
  const DeliveryInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final nameController = TextEditingController(
      text: controller.cartData.value?.deliveryInfo.name,
    );
    final phoneController = TextEditingController(
      text: controller.cartData.value?.deliveryInfo.phone,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin giao hàng',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Color(0xFFE94E1B)),
                  SizedBox(width: 8),
                  Text(
                    'Địa chỉ nhận hàng',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.cartData.value?.deliveryInfo.address ??
                            'Chưa có địa chỉ',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.edit, size: 18, color: Colors.brown),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.person, size: 16, color: Color(0xFFE94E1B)),
                  SizedBox(width: 8),
                  Text('Họ và Tên', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                onChanged: (val) =>
                    controller.updateDeliveryInfo(val, phoneController.text),
                decoration: InputDecoration(
                  hintText: 'Nhập tên của bạn',
                  filled: true,
                  fillColor: const Color(0xFFFFF1EB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Color(0xFFE94E1B)),
                  SizedBox(width: 8),
                  Text('Số điện thoại', style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                onChanged: (val) =>
                    controller.updateDeliveryInfo(nameController.text, val),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Nhập số điện thoại',
                  filled: true,
                  fillColor: const Color(0xFFFFF1EB),
                  errorText:
                      phoneController.text.isNotEmpty &&
                          phoneController.text.length < 10
                      ? 'Số điện thoại không hợp lệ'
                      : null,
                  suffixIcon:
                      phoneController.text.isNotEmpty &&
                          phoneController.text.length < 10
                      ? const Icon(Icons.error_outline, color: Colors.red)
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder:
                      phoneController.text.isNotEmpty &&
                          phoneController.text.length < 10
                      ? OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
