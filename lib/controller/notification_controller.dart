import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/order_model.dart';
import '../data/services/order_service.dart';
import 'auth_controller.dart';

class OrderNotification {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String orderId;
  final String status;

  const OrderNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.orderId,
    required this.status,
  });
}

class NotificationController extends GetxController {
  final OrderService _orderService = OrderService();
  final GetStorage _storage = GetStorage();

  static const _readIdsKey = 'readOrderNotificationIds';

  final notifications = <OrderNotification>[].obs;
  final readIds = <String>{}.obs;
  final isLoading = false.obs;

  int get unreadCount =>
      notifications.where((item) => !readIds.contains(item.id)).length;

  @override
  void onInit() {
    super.onInit();
    _loadReadIds();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final orders = await _orderService.getOrders(_currentUserId());
      notifications.assignAll(orders.map(_notificationFromOrder));
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải thông báo đơn hàng: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool isRead(OrderNotification notification) =>
      readIds.contains(notification.id);

  void markAsRead(OrderNotification notification) {
    if (readIds.add(notification.id)) {
      readIds.refresh();
      _saveReadIds();
    }
  }

  void markAllAsRead() {
    readIds.addAll(notifications.map((item) => item.id));
    readIds.refresh();
    _saveReadIds();
  }

  void _loadReadIds() {
    final stored = _storage.read<List<dynamic>>(_readIdsKey) ?? [];
    readIds
      ..clear()
      ..addAll(stored.map((id) => id.toString()));
  }

  void _saveReadIds() {
    _storage.write(_readIdsKey, readIds.toList());
  }

  String _currentUserId() {
    if (!Get.isRegistered<AuthController>()) return '';

    final token = Get.find<AuthController>().accessToken.value;
    final parts = token.split('.');
    if (parts.length != 3) return '';

    try {
      final payloadJson = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;
      return (payload['id'] ?? '').toString();
    } catch (_) {
      return '';
    }
  }

  OrderNotification _notificationFromOrder(OrderModel order) {
    final code = order.orderCode.isNotEmpty ? order.orderCode : '#${order.id}';
    final statusText = _statusText(order.status);

    return OrderNotification(
      id: '${order.id}-${order.status}',
      title: 'Cập nhật đơn hàng $code',
      message: 'Đơn hàng của bạn $statusText.',
      createdAt: order.createdAt,
      orderId: order.id,
      status: order.status,
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'pending_payment':
        return 'đang chờ thanh toán';
      case 'processing':
        return 'đang được xử lý';
      case 'delivered':
      case 'completed':
        return 'đã giao thành công';
      case 'cancelled':
        return 'đã bị hủy';
      default:
        return 'đang chờ xác nhận';
    }
  }
}
