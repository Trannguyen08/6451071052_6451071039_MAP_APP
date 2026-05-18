import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String orderCode; // e.g., #FH-8829
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final String status; // 'pending', 'processing', 'delivered', 'cancelled'

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.status,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      orderCode:
          data['orderCode'] ?? '#FH-${id.substring(0, 4).toUpperCase()}',
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      totalAmount: _toDouble(data['totalAmount'] ?? data['total']),
      createdAt: _parseDate(data['createdAt']),
      status: data['status'] ?? 'pending',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderCode': orderCode,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final String details; // e.g., "Phai tây chiên, Coke"
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.details,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'] ?? data['id'] ?? '',
      productName: data['productName'] ?? data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? data['image'] ?? '',
      details: data['details'] ?? data['options'] ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      price: OrderModel._toDouble(data['price']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'details': details,
      'quantity': quantity,
      'price': price,
    };
  }
}
