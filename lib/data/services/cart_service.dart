import 'package:get/get.dart';
import '../models/cart_model.dart';

class CartService extends GetConnect {
  final String baseUrlStr = 'http://10.0.2.2:5000/api'; // 10.0.2.2 for Android Emulator

  Future<CartData> getCart() async {
    final response = await get('$baseUrlStr/cart');
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi tải giỏ hàng';
    }
    return CartData.fromJson(response.body);
  }

  Future<CartData> updateItemQuantity(String id, int quantity) async {
    final response = await post('$baseUrlStr/cart/items', {
      'id': id,
      'quantity': quantity,
    });
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi cập nhật số lượng';
    }
    return CartData.fromJson(response.body);
  }

  Future<CartData> updateDeliveryInfo(String name, String phone) async {
    final response = await post('$baseUrlStr/cart/delivery', {
      'name': name,
      'phone': phone,
    });
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi cập nhật thông tin';
    }
    return CartData.fromJson(response.body);
  }

  Future<CartData> updatePaymentMethod(String method) async {
    final response = await post('$baseUrlStr/cart/payment', {
      'method': method,
    });
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi cập nhật phương thức';
    }
    return CartData.fromJson(response.body);
  }

  Future<dynamic> checkout() async {
    final response = await post('$baseUrlStr/checkout', {});
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi thanh toán';
    }
    return response.body;
  }
}
