import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import 'firebase_service.dart';

class HomeService {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<CategoryModel>> getCategories() async {
    QuerySnapshot snapshot =
        await _firebaseService.categories.get();

    return snapshot.docs.map((doc) {
      return CategoryModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot snapshot =
        await _firebaseService.products.get();

    return snapshot.docs.map((doc) {
      return ProductModel.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }
}