import 'package:get/get.dart';

import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/services/home_service.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  RxString userId = ''.obs;
  RxString userName = ''.obs;
  RxString email = ''.obs;

  RxBool isSearching = false.obs;

  RxString notificationText =
      'Đơn hàng của bạn đang được giao'.obs;

  RxInt cartCount = 1.obs;

  RxList<CategoryModel> categories =
      <CategoryModel>[].obs;

  RxList<ProductModel> products =
      <ProductModel>[].obs;

  RxList<ProductModel> filteredProducts =
      <ProductModel>[].obs;

  RxInt selectedCategoryIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
    loadData();
  }

  void loadUser() {
    final args = Get.arguments;

    if (args != null) {
      userId.value = args['id'] ?? '';
      userName.value = args['fullName'] ?? '';
      email.value = args['email'] ?? '';
    }
  }

  Future<void> loadData() async {
    try {
      final categoryData =
          await _homeService.getCategories();

      final productData =
          await _homeService.getProducts();

      categories.assignAll(categoryData);

      products.assignAll(productData);

      filteredProducts.assignAll(productData);
    } catch (e) {
      print(e);
    }
  }

  void selectCategory(int index) {
  selectedCategoryIndex.value = index;

  final categoryId = categories[index].id;

  filteredProducts.value = products
      .where(
        (product) =>
            product.categoryId == categoryId,
      )
      .toList();

  update();
}

  void searchProduct(String query) {
    query = query.toLowerCase().trim();

    if (query.isEmpty) {
      isSearching.value = false;

      if (categories.isNotEmpty) {
        final categoryId =
            categories[selectedCategoryIndex.value]
                .id;

        filteredProducts.assignAll(
          products.where(
            (product) =>
                product.categoryId == categoryId,
          ),
        );
      } else {
        filteredProducts.assignAll(products);
      }

      return;
    }

    isSearching.value = true;

    filteredProducts.assignAll(
      products.where((product) {
        return product.name
                .toLowerCase()
                .contains(query) ||
            product.description
                .toLowerCase()
                .contains(query);
      }).toList(),
    );
  }

  void addToCart(ProductModel product) {
    cartCount.value++;

    Get.snackbar(
      'Thêm vào giỏ hàng',
      'Đã thêm ${product.name}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}