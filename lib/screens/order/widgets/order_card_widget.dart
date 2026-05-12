import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/order_model.dart';
import '../../../controller/order_controller.dart';
import 'package:get/get.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final String statusDisplay;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.statusDisplay,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd ThMM, yyyy • HH:mm');
    
    // Giả lập ảnh và tên chi tiết nếu items trống (để hiển thị giống ảnh mẫu)
    final firstItem = order.items.isNotEmpty 
        ? order.items.first 
        : OrderItem(
            productId: '', 
            productName: 'Burger Bò Phô Mai', 
            imageUrl: 'https://img.freepik.com/free-photo/delicious-burger-with-fresh-ingredients_23-2150857908.jpg', 
            details: 'Phai tây chiên, Coke', 
            quantity: 1, 
            price: 145000
          );

    Color statusColor;
    IconData statusIcon;
    switch (order.status) {
      case 'delivered':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'pending_payment':
        statusColor = Colors.red.shade700;
        statusIcon = Icons.payment_outlined;
        break;
      case 'processing':
        statusColor = Colors.orange;
        statusIcon = Icons.timer_outlined;
        break;
      case 'cancelled':
        statusColor = Colors.grey;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.info_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header: Mã đơn hàng & Trạng thái
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      children: [
                        const TextSpan(text: 'Mã đơn hàng: '),
                        TextSpan(
                          text: order.orderCode,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.createdAt.year == DateTime.now().year && order.createdAt.day == DateTime.now().day
                        ? 'Hôm nay, ${DateFormat('HH:mm').format(order.createdAt)}'
                        : dateFormat.format(order.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 5),
                    Text(
                      statusDisplay,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 25, thickness: 0.5),
          
          // Body: Ảnh & Thông tin sản phẩm
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(firstItem.imageUrl.isNotEmpty ? firstItem.imageUrl : 'https://via.placeholder.com/150'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (order.items.length > 1)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '+${order.items.length - 1}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.items.length > 1 ? '${order.items.length} món • ${firstItem.productName}' : '${firstItem.quantity}x ${firstItem.productName}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      firstItem.details,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          
          // Footer: Tổng cộng & Nút action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tổng cộng', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    currencyFormat.format(order.totalAmount).replaceAll('₫', 'đ'),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE64A19)),
                  ),
                ],
              ),
              if (order.status == 'pending_payment')
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Get.find<OrderController>().cancelOrder(order.id),
                      child: const Text('Hủy đơn', style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Get.find<OrderController>().retryPayment(order.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Thanh toán'),
                    ),
                  ],
                )
              else
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: order.status == 'delivered' ? Colors.orange : Colors.white,
                      foregroundColor: order.status == 'delivered' ? Colors.white : Colors.orange,
                      elevation: 0,
                      side: order.status == 'delivered' ? BorderSide.none : const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                    ),
                    child: Text(
                      order.status == 'delivered' ? 'Đặt lại' : 'Chi tiết',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
