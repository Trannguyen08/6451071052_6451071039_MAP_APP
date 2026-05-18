import 'package:get/get.dart';

import '../models/order_model.dart';

class OrderService {
  late final String baseUrlStr = _resolveBaseUrl();

  String _resolveBaseUrl() {
    if (!GetPlatform.isWeb) {
      return 'http://10.0.2.2:5000/api';
    }

    final uri = Uri.base;
    final isServedByBackend =
        (uri.host == 'localhost' || uri.host == '127.0.0.1') &&
        uri.port == 5000;
    return isServedByBackend ? '/api' : 'http://localhost:5000/api';
  }

  Future<List<OrderModel>> getOrders(String userId) async {
    final response = await GetConnect().get(
      '$baseUrlStr/orders',
      query: userId.isEmpty ? null : {'userId': userId},
    );
    if (response.status.hasError) {
      throw response.statusText ?? 'Loi tai don hang';
    }

    return ((response.body as List?) ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((e) => OrderModel.fromFirestore(e, e['id']))
        .toList();
  }

  Future<String> retryPayment(String orderId) async {
    final response = await GetConnect().post(
      '$baseUrlStr/orders/$orderId/retry-payment',
      {},
    );
    if (response.status.hasError) {
      throw response.statusText ?? 'Loi tao link thanh toan';
    }
    return response.body['checkoutUrl'];
  }

  Future<bool> cancelOrder(String orderId) async {
    final response = await GetConnect().post(
      '$baseUrlStr/orders/$orderId/cancel',
      {},
    );
    if (response.status.hasError) {
      throw response.statusText ?? 'Loi huy don hang';
    }
    return response.body['success'] == true;
  }
}
