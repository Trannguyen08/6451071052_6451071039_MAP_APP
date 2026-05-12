import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/order_controller.dart';
import 'widgets/order_card_widget.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    final OrderController controller = Get.put(OrderController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Decoration
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'orders_title'.tr,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=foodhero'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Filter Selection Box (Thay thế cho Chips)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Obx(() => DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedStatus.value,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.orange),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        items: controller.statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.updateFilter(newValue);
                          }
                        },
                      ),
                    )),
                  ),
                ),

                const SizedBox(height: 20),

                // Orders List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orange));
                    }
                    
                    if (controller.filteredOrders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history_toggle_off_rounded, size: 80, color: Colors.grey.shade300),
                            const SizedBox(height: 20),
                            const Text(
                              'Chưa có đơn hàng nào',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      itemCount: controller.filteredOrders.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final order = controller.filteredOrders[index];
                        return OrderCardWidget(
                          order: order,
                          statusDisplay: controller.getStatusDisplay(order.status),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
