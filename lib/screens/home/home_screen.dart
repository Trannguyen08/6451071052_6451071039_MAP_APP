import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/wishlist_controller.dart';
import '../../data/models/product_model.dart';

class HomeScreen extends GetView {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> foodItems = [
    {'name': 'Burger Classic', 'price': '45.000đ', 'emoji': '🍔', 'color': 0xFFFF6B35},
    {'name': 'Pizza Margherita', 'price': '89.000đ', 'emoji': '🍕', 'color': 0xFF6C63FF},
    {'name': 'Fried Chicken', 'price': '55.000đ', 'emoji': '🍗', 'color': 0xFFFF8C42},
    {'name': 'Caesar Salad', 'price': '39.000đ', 'emoji': '🥗', 'color': 0xFF00BFA5},
  ];

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'home_greeting'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                      ),
                    ),
                    Text(
                      'home_subtitle'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16, top: 16),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=11'),
                      ),
                    ),
                  ),
                ),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.06),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_rounded, color: Colors.grey[400]),
                          const SizedBox(width: 12),
                          Text(
                            'search'.tr,
                            style: TextStyle(color: Colors.grey[400], fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Popular section
                    Text(
                      'home_popular'.tr,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    // Placeholder cards
                    ...List.generate(foodItems.length, (i) => _buildFoodCard(context, i)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, int index) {
    final itemData = foodItems[index];
    final product = ProductModel(
      id: 'food_$index',
      name: itemData['name'] as String,
      description: 'Mô tả chi tiết cho ${itemData['name']}',
      price: double.parse((itemData['price'] as String).replaceAll('.', '').replaceAll('đ', '')),
      imageUrl: '',
      categoryId: 'cat_0',
    );

    final wishlistController = Get.find<WishlistController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(itemData['color'] as int).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(itemData['emoji'] as String, style: const TextStyle(fontSize: 30)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemData['name'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  itemData['price'] as String,
                  style: TextStyle(
                    color: Color(itemData['color'] as int),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Obx(() => IconButton(
                    onPressed: () => wishlistController.toggleWishlist(product),
                    icon: Icon(
                      wishlistController.isFavorite(product) ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: const Color(0xFFFF4444),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )),
              const SizedBox(height: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
