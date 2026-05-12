import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import '../models/order_model.dart';

class OrderService {
  final String baseUrlStr = 'http://10.0.2.2:5000/api'; // 10.0.2.2 for Android Emulator

  Future<List<OrderModel>> getOrders(String userId) async {
    final response = await GetConnect().get('$baseUrlStr/orders');
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi tải đơn hàng';
    }
    return (response.body as List).map((e) => OrderModel.fromFirestore(e, e['id'])).toList();
  }

  Future<String> retryPayment(String orderId) async {
    final response = await GetConnect().post('$baseUrlStr/orders/$orderId/retry-payment', {});
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi tạo link thanh toán';
    }
    return response.body['checkoutUrl'];
  }

  Future<bool> cancelOrder(String orderId) async {
    final response = await GetConnect().post('$baseUrlStr/orders/$orderId/cancel', {});
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi hủy đơn hàng';
    }
    return response.body['success'] == true;
  }
}
