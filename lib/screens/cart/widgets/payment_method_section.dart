import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/cart_controller.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return Obx(() {
      final method = controller.cartData.value?.paymentMethod ?? 'cash';
      
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet_outlined, color: Colors.brown),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                method == 'cash' ? 'Tiền mặt' : 'Ví ShopeePay',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () => _showPaymentPicker(context, controller),
              child: const Text(
                'Thay đổi',
                style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showPaymentPicker(BuildContext context, CartController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn phương thức thanh toán',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.money, color: Colors.green),
              title: const Text('Tiền mặt'),
              onTap: () {
                controller.updatePaymentMethod('cash');
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.orange),
              title: const Text('Ví ShopeePay'),
              onTap: () {
                controller.updatePaymentMethod('online');
                Get.back();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
