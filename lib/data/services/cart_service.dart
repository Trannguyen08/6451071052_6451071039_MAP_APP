import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartService extends GetConnect {
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

  Future<CartData> addProduct(
    ProductModel product, {
    int quantity = 1,
    bool replace = false,
  }) async {
    final response = await post('$baseUrlStr/cart/items/add', {
      'id': product.id,
      'name': product.name,
      'options': product.description,
      'price': product.price,
      'quantity': quantity,
      'image': product.imageUrl,
      'replace': replace,
    });
    if (response.status.hasError) {
      throw response.statusText ?? 'Loi them san pham vao gio hang';
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
    final response = await post('$baseUrlStr/cart/payment', {'method': method});
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
