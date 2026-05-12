import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../product/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller =
      Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F2),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              /// HEADER
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        'FoodHero',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Đặt món nhanh chóng',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            Colors.orange,

                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),

                      Positioned(
                        right: 0,
                        top: 0,

                        child: Obx(
                          () => Container(
                            padding:
                                const EdgeInsets.all(
                              5,
                            ),

                            decoration:
                                const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),

                            child: Text(
                              controller
                                  .cartCount.value
                                  .toString(),

                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// USER + NOTIFICATION
              Obx(
                () => Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Xin chào, ${controller.userName.value}',

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      child: Row(
                        children: [
                          const Icon(
                            Icons.notifications,
                            color: Colors.blue,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              controller
                                  .notificationText
                                  .value,

                              style:
                                  const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// SEARCH
              TextField(
                onChanged:
                    controller.searchProduct,

                decoration: InputDecoration(
                  hintText: 'Tìm món ăn...',
                  prefixIcon:
                      const Icon(Icons.search),

                  filled: true,
                  fillColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// CATEGORY TITLE
              const Text(
                'Danh mục',

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// CATEGORY LIST
              SizedBox(
                height: 100,

                child: Obx(
                  () => ListView.builder(
                    scrollDirection:
                        Axis.horizontal,

                    itemCount:
                        controller.categories.length,

                    itemBuilder:
                        (context, index) {
                      final category =
                          controller
                              .categories[index];

                      bool isSelected =
                          controller
                                  .selectedCategoryIndex
                                  .value ==
                              index;

                      return GestureDetector(
                        onTap: () {
                          controller
                              .selectCategory(
                            index,
                          );
                        },

                        child: Container(
                          width: 100,

                          margin:
                              const EdgeInsets.only(
                            right: 12,
                          ),

                          decoration:
                              BoxDecoration(
                            color: isSelected
                                ? Colors.orange
                                : Colors.white,

                            borderRadius:
                                BorderRadius
                                    .circular(
                              20,
                            ),
                          ),

                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              Text(
                                category.icon,

                                style:
                                    const TextStyle(
                                  fontSize: 28,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                category.name,

                                style:
                                    TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .bold,

                                  color: isSelected
                                      ? Colors
                                          .white
                                      : Colors
                                          .black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// BANNER
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(30),

                  gradient:
                      const LinearGradient(
                    colors: [
                      Colors.orange,
                      Colors.deepOrange,
                    ],
                  ),
                ),

                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      'ƯU ĐÃI HÔM NAY',

                      style: TextStyle(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Giảm 30%\nCho mọi Pizza',

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'Mã giảm: FOOD30',

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// PRODUCT TITLE
              Obx(
                () => Text(
                  controller.isSearching.value
                      ? 'Kết quả tìm kiếm'
                      : 'Món ăn nổi bật',

                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PRODUCT LIST
              Obx(() {
                if (controller
                    .filteredProducts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding:
                          EdgeInsets.all(30),

                      child: Text(
                        'Không tìm thấy sản phẩm',

                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount: controller
                      .filteredProducts.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.62,
                  ),

                  itemBuilder: (context, index) {
                    final product = controller
                        .filteredProducts[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ProductDetailScreen(),
                          arguments: product,
                        );
                      },

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          12,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                20,
                              ),

                              child: Image.network(
                                product.imageUrl,
                                height: 120,
                                width:
                                    double.infinity,
                                fit: BoxFit.cover,

                                errorBuilder:
                                    (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                  return Container(
                                    height: 120,
                                    color: Colors
                                        .grey.shade300,

                                    child: const Icon(
                                      Icons.fastfood,
                                      size: 50,
                                    ),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            Text(
                              product.name,

                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              product.description,

                              maxLines: 2,
                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const Spacer(),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: [
                                Text(
                                  '${product.price.toInt()}đ',

                                  style:
                                      const TextStyle(
                                    fontSize: 20,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color: Colors.red,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    controller
                                        .addToCart(
                                      product,
                                    );
                                  },

                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(
                                      10,
                                    ),

                                    decoration:
                                        const BoxDecoration(
                                      color:
                                          Colors.orange,
                                      shape:
                                          BoxShape
                                              .circle,
                                    ),

                                    child:
                                        const Icon(
                                      Icons.add,
                                      color: Colors
                                          .white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}