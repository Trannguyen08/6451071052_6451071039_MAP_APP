import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/cart_model.dart';
import '../data/services/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();
  
  var cartData = Rxn<CartData>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading.value = true;
      cartData.value = await _cartService.getCart();
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể tải giỏ hàng: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateQuantity(String id, int quantity) async {
    try {
      if (quantity < 0) return;
      cartData.value = await _cartService.updateItemQuantity(id, quantity);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật số lượng: $e');
    }
  }

  Future<void> updateDeliveryInfo(String name, String phone) async {
    try {
      cartData.value = await _cartService.updateDeliveryInfo(name, phone);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật thông tin: $e');
    }
  }

  void updatePaymentMethod(String method) async {
    try {
      cartData.value = await _cartService.updatePaymentMethod(method);
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật phương thức thanh toán: $e');
    }
  }

  Future<void> checkout() async {
    try {
      isLoading.value = true;
      final response = await _cartService.checkout();
      
      if (response['success'] == true) {
        if (response['online'] == true) {
          final checkoutUrl = response['checkoutUrl'];
          if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
            await launchUrl(
              Uri.parse(checkoutUrl),
              mode: LaunchMode.externalApplication,
            );
          } else {
            Get.snackbar('Lỗi', 'Không thể mở link thanh toán');
          }
        } else {
          Get.snackbar('Thành công', 'Đơn hàng của bạn đã được đặt!');
          fetchCart(); // Refresh cart (should be empty)
        }
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Thanh toán thất bại: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double get subtotal => cartData.value?.subtotal ?? 0;
  double get shippingFee => cartData.value?.shippingFee ?? 0;
  double get discount => cartData.value?.discount ?? 0;
  double get total => cartData.value?.total ?? 0;
}
