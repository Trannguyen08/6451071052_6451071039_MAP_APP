import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/product_model.dart';

class WishlistController extends GetxController {
  final GetStorage _storage = GetStorage();
  static const _kWishlist = 'wishlist_items';

  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadWishlist();
  }

  void _loadWishlist() {
    final List<dynamic>? savedItems = _storage.read<List<dynamic>>(_kWishlist);
    if (savedItems != null) {
      wishlistItems.assignAll(
        savedItems.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList(),
      );
    }
  }

  void _saveWishlist() {
    _storage.write(_kWishlist, wishlistItems.map((item) => item.toJson()).toList());
  }

  void toggleWishlist(ProductModel product) {
    if (isFavorite(product)) {
      wishlistItems.removeWhere((item) => item.id == product.id);
    } else {
      wishlistItems.add(product);
    }
    _saveWishlist();
  }

  bool isFavorite(ProductModel product) {
    return wishlistItems.any((item) => item.id == product.id);
  }

  void clearWishlist() {
    wishlistItems.clear();
    _saveWishlist();
  }
}
