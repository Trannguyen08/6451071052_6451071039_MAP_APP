import 'dart:convert';

import 'package:get/get.dart';

import '../data/models/category_model.dart';
import '../data/models/order_model.dart';
import '../data/models/product_model.dart';
import '../data/services/auth_service.dart';
import '../data/services/home_service.dart';
import '../data/services/order_service.dart';
import '../routes/app_routes.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();
  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  final userId = ''.obs;
  final userName = ''.obs;
  final email = ''.obs;
  final userAvatar = ''.obs;
  final isSearching = false.obs;
  final notificationText = 'Chưa có cập nhật mới từ đơn hàng'.obs;
  final cartCount = 0.obs;
  final categories = <CategoryModel>[].obs;
  final brands = <String>[].obs;
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;
  final selectedCategoryIndex = 0.obs;
  final selectedBrand = 'all'.obs;
  final searchQuery = ''.obs;
  final selectedQuantities = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
    loadData();
    _bindCartCount();
  }

  Future<void> loadUser() async {
    final args = Get.arguments;
    if (args != null) {
      userId.value = args['id'] ?? '';
      userName.value = args['fullName'] ?? '';
      email.value = args['email'] ?? '';
      userAvatar.value = args['avatar'] ?? '';
      if (userId.value.isNotEmpty) {
        await _loadUserFromFirestore(userId.value);
        await loadLatestOrderNotification();
      }
      return;
    }

    final authController = Get.find<AuthController>();
    final token = authController.accessToken.value;
    if (token.isEmpty) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    final payload = _decodeJwtPayload(token);
    if (payload == null) return;

    userId.value = (payload['id'] ?? '').toString();
    userName.value = (payload['name'] ?? '').toString();
    email.value = (payload['email'] ?? '').toString();
    userAvatar.value = (payload['avatar'] ?? '').toString();

    if (userId.value.isNotEmpty) {
      await _loadUserFromFirestore(userId.value);
      await loadLatestOrderNotification();
    }
  }

  Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final normalizedPayload = base64Url.normalize(parts[1]);
      final payloadJson = utf8.decode(base64Url.decode(normalizedPayload));
      return jsonDecode(payloadJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadUserFromFirestore(String id) async {
    try {
      final user = await _authService.getUserById(id);
      if (user == null) return;

      userName.value = user.fullName ?? userName.value;
      email.value = user.email ?? email.value;
      userAvatar.value = user.avatar ?? userAvatar.value;
    } catch (_) {
      // Keep token data if Firestore is temporarily unavailable.
    }
  }

  Future<void> loadData() async {
    try {
      final categoryData = await _homeService.getCategories();
      final productData = await _homeService.getProducts();
      categories.assignAll(categoryData);
      products.assignAll(productData);
      _buildBrandList();
      _applyProductFilters();
    } catch (e) {
      Get.snackbar('Loi', 'Khong the tai san pham: $e');
    }
  }

  void _buildBrandList() {
    final brandNames =
        products
            .map((product) => product.brand.trim())
            .where((brand) => brand.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    brands.assignAll(brandNames);
  }

  void _bindCartCount() {
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    ever(cartController.cartData, (_) => _syncCartCount(cartController));
    _syncCartCount(cartController);
  }

  void _syncCartCount(CartController cartController) {
    cartCount.value =
        cartController.cartData.value?.items.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        ) ??
        0;
  }

  Future<void> loadLatestOrderNotification() async {
    try {
      final orderData = await _orderService.getOrders(userId.value);
      if (orderData.isEmpty) {
        notificationText.value = 'Bạn chưa có cập nhật đơn hàng mới';
        return;
      }

      orderData.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notificationText.value = _buildOrderNotification(orderData.first);
    } catch (_) {
      notificationText.value = 'Chưa thể tải cập nhật đơn hàng mới';
    }
  }

  String _buildOrderNotification(OrderModel order) {
    final code = order.orderCode.isNotEmpty ? order.orderCode : '#${order.id}';

    switch (order.status) {
      case 'pending_payment':
        return 'Đơn $code đang chờ thanh toán';
      case 'processing':
        return 'Đơn $code đang được xử lý';
      case 'delivered':
        return 'Đơn $code đã giao thành công';
      case 'cancelled':
        return 'Đơn $code đã bị hủy';
      default:
        return 'Đơn $code đang chờ xác nhận';
    }
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    searchQuery.value = '';
    isSearching.value = false;
    _applyProductFilters();
  }

  void selectBrand(String brand) {
    selectedBrand.value = brand;
    _applyProductFilters();
  }

  void searchProduct(String query) {
    searchQuery.value = query.trim();
    isSearching.value = searchQuery.value.isNotEmpty;
    _applyProductFilters();
  }

  void _applyProductFilters() {
    final keyword = searchQuery.value.toLowerCase();
    final categoryId =
        selectedCategoryIndex.value > 0 &&
            selectedCategoryIndex.value <= categories.length
        ? categories[selectedCategoryIndex.value - 1].id
        : '';
    final brand = selectedBrand.value;

    filteredProducts.assignAll(
      products.where((product) {
        final productName = product.name.toLowerCase();
        final productDescription = product.description.toLowerCase();
        final productBrand = product.brand.toLowerCase();
        final productId = product.id.toLowerCase();
        final matchesCategory =
            categoryId.isEmpty || product.categoryId == categoryId;
        final matchesBrand = brand == 'all' || product.brand == brand;
        final matchesSearch =
            keyword.isEmpty ||
            productName.contains(keyword) ||
            productDescription.contains(keyword) ||
            productBrand.contains(keyword) ||
            productId.contains(keyword);

        return matchesCategory && matchesBrand && matchesSearch;
      }),
    );
  }

  String brandFor(ProductModel product) {
    final brand = product.brand.trim();
    if (brand.isNotEmpty) return brand;

    return categories
            .firstWhereOrNull((category) => category.id == product.categoryId)
            ?.name ??
        'FoodHero';
  }

  int quantityFor(ProductModel product) => selectedQuantities[product.id] ?? 1;

  void increaseQuantity(ProductModel product) {
    selectedQuantities[product.id] = quantityFor(product) + 1;
  }

  void decreaseQuantity(ProductModel product) {
    final current = quantityFor(product);
    if (current > 1) {
      selectedQuantities[product.id] = current - 1;
    }
  }

  Future<void> addToCart(ProductModel product) async {
    final quantity = quantityFor(product);
    final cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
    await cartController.addProduct(product, quantity: quantity);
    _syncCartCount(cartController);
  }
}
