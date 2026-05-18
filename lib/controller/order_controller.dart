import 'dart:convert';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/models/order_model.dart';
import '../data/services/order_service.dart';
import 'auth_controller.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'Tất cả'.obs;

  final List<String> statusOptions = [
    'Tất cả',
    'Đang xử lý',
    'Đã giao',
    'Đã hủy',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final fetchedOrders = await _orderService.getOrders(_currentUserId());
      orders.assignAll(fetchedOrders);
      _applyFilter();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải lịch sử đơn hàng: $e');
    } finally {
      isLoading.value = false;
    }
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

  void updateFilter(String status) {
    selectedStatus.value = status;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedStatus.value == 'Tất cả') {
      filteredOrders.assignAll(orders);
      return;
    }

    String statusKey = '';
    switch (selectedStatus.value) {
      case 'Đang xử lý':
        statusKey = 'processing';
        break;
      case 'Đã giao':
        statusKey = 'delivered';
        break;
      case 'Đã hủy':
        statusKey = 'cancelled';
        break;
      default:
        statusKey = 'pending';
    }
    filteredOrders.assignAll(orders.where((o) => o.status == statusKey));
  }

  String getStatusDisplay(String status) {
    switch (status) {
      case 'pending_payment':
        return 'Chờ thanh toán';
      case 'processing':
        return 'Đang xử lý';
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Đang chờ';
    }
  }

  Future<void> retryPayment(String orderId) async {
    try {
      isLoading.value = true;
      final checkoutUrl = await _orderService.retryPayment(orderId);
      if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
        await launchUrl(
          Uri.parse(checkoutUrl),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể khởi tạo lại thanh toán: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      final success = await _orderService.cancelOrder(orderId);
      if (success) {
        Get.snackbar('Thành công', 'Đã hủy đơn hàng #$orderId');
        fetchOrders();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể hủy đơn hàng: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
