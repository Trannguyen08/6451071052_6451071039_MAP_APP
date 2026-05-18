import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller =
      Get.isRegistered<NotificationController>()
      ? Get.find<NotificationController>()
      : Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F2),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.fetchNotifications,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading.value &&
                      controller.notifications.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (controller.notifications.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: Text(
                          'Chưa có thông báo đơn hàng',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: controller.notifications
                        .map(
                          (notification) => _NotificationTile(
                            notification: notification,
                            isRead: controller.isRead(notification),
                            onMarkRead: () =>
                                controller.markAsRead(notification),
                          ),
                        )
                        .toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Thông báo',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          TextButton.icon(
            onPressed: controller.unreadCount == 0
                ? null
                : controller.markAllAsRead,
            icon: const Icon(Icons.done_all_rounded),
            label: Text('Đã đọc (${controller.unreadCount})'),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final OrderNotification notification;
  final bool isRead;
  final VoidCallback onMarkRead;

  const _NotificationTile({
    required this.notification,
    required this.isRead,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFFFFF1EB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? const Color(0xFFEFE7E4) : Colors.orange,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isRead ? const Color(0xFFF1F1F1) : Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: isRead ? Colors.grey : Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notification.message,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: isRead ? 'Đã đọc' : 'Đánh dấu đã đọc',
            onPressed: isRead ? null : onMarkRead,
            icon: Icon(
              isRead ? Icons.check_circle : Icons.check_circle_outline,
              color: isRead ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
