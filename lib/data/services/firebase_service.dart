import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    databaseId: 'fast-food',
  );

  // Collections for Fast Food System
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get products => _firestore.collection('products');
  CollectionReference get categories => _firestore.collection('categories');
  CollectionReference get carts => _firestore.collection('carts');
  CollectionReference get orders => _firestore.collection('orders');
  CollectionReference get feedbacks => _firestore.collection('feedbacks');
  CollectionReference get addresses => _firestore.collection('addresses');
  CollectionReference get payments => _firestore.collection('payments');
}
