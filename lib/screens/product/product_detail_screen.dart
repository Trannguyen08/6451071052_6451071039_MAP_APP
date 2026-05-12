import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  final ProductModel product = Get.arguments;

  int quantity = 1;

  double get totalPrice =>
      product.price * quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3F2),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            /// TOTAL + QUANTITY
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Tổng thanh toán',

                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '${totalPrice.toInt()}đ',

                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius:
                        BorderRadius.circular(30),
                  ),

                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },

                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Text(
                        quantity.toString(),

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 15),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantity++;
                          });
                        },

                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// BUTTON ADD TO CART
            SizedBox(
              width: double.infinity,
              height: 60,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),

                onPressed: () {
                  Get.snackbar(
                    'Thêm vào giỏ hàng',
                    'ID món: ${product.id}\nSố lượng: $quantity',

                    backgroundColor:
                        Colors.green,

                    colorText: Colors.white,

                    snackPosition:
                        SnackPosition.BOTTOM,

                    margin:
                        const EdgeInsets.all(15),
                  );
                },

                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),

                label: const Text(
                  'Thêm vào giỏ',

                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          12,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),

                        child: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),

                    const Text(
                      'Chi tiết món ăn',

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),

                      child: const Icon(
                        Icons.favorite_border,
                      ),
                    ),
                  ],
                ),
              ),

              /// IMAGE
              Hero(
                tag: product.id,

                child: Image.network(
                  product.imageUrl ?? '',

                  height: 350,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (
                        context,
                        error,
                        stackTrace,
                      ) {
                    return Container(
                      height: 350,
                      color: Colors.grey.shade300,

                      child: const Icon(
                        Icons.fastfood,
                        size: 100,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// PRODUCT INFO
              Container(
                width: double.infinity,

                margin:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                ),

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(35),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,

                      children: [
                        Expanded(
                          child: Text(
                            product.name,

                            style:
                                const TextStyle(
                              fontSize: 32,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors.orange,

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: const Row(
                            children: [
                              Icon(
                                Icons.star,
                                color:
                                    Colors.white,
                                size: 18,
                              ),

                              SizedBox(width: 5),

                              Text(
                                '4.8',

                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      '${product.price.toInt()}đ',

                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      product.description,

                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.orange,
                        ),

                        SizedBox(width: 8),

                        Text(
                          '15-20 phút',
                        ),

                        SizedBox(width: 30),

                        Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                        ),

                        SizedBox(width: 8),

                        Text(
                          '450 kcal',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 140),
            ],
          ),
        ),
      ),
    );
  }
}