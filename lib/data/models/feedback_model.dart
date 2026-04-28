import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String userId;
  final String? orderId;
  final String comment;
  final int rating;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    this.orderId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory FeedbackModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FeedbackModel(
      id: id,
      userId: data['userId'] ?? '',
      orderId: data['orderId'],
      comment: data['comment'] ?? '',
      rating: data['rating'] ?? 5,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'orderId': orderId,
      'comment': comment,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
