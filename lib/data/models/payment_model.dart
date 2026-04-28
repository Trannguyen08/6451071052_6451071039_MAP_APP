import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  final String id;
  final String userId;
  final String orderId;
  final double amount;
  final String paymentMethod; // e.g., 'credit_card', 'cod', 'momo'
  final String status; // e.g., 'pending', 'success', 'failed'
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  factory PaymentModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PaymentModel(
      id: id,
      userId: data['userId'] ?? '',
      orderId: data['orderId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? 'cod',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'orderId': orderId,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
