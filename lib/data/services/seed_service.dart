import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class SeedService {
  final FirebaseService firebaseService = FirebaseService();

  Future<void> seedCategories() async {
    final categories = [
      {
        'id': 'burger',
        'name': 'Burger',
        'icon': '🍔',
      },
      {
        'id': 'pizza',
        'name': 'Pizza',
        'icon': '🍕',
      },
      {
        'id': 'chicken',
        'name': 'Chicken',
        'icon': '🍗',
      },
      {
        'id': 'drinks',
        'name': 'Drinks',
        'icon': '🥤',
      },
      {
        'id': 'salad',
        'name': 'Salad',
        'icon': '🥗',
      },
    ];

    for (var category in categories) {
      await firebaseService.categories.add(category);
    }
  }

  Future<void> seedProducts() async {
    final products = [
      {
        'name': 'Burger Bò Phô Mai',
        'description': 'Burger bò thơm ngon',
        'price': 85000,
        'imageUrl':
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        'categoryId': 'burger',
      },
      {
        'name': 'Pizza Hải Sản',
        'description': 'Pizza đầy topping',
        'price': 155000,
        'imageUrl':
            'https://images.unsplash.com/photo-1513104890138-7c749659a591',
        'categoryId': 'pizza',
      },
      {
        'name': 'Gà Rán Giòn',
        'description': 'Gà cay giòn rụm',
        'price': 45000,
        'imageUrl':
            'https://images.unsplash.com/photo-1562967916-eb82221dfb92',
        'categoryId': 'chicken',
      },
      {
        'name': 'Coca Cola',
        'description': 'Nước ngọt có gas',
        'price': 18000,
        'imageUrl':
            'https://images.unsplash.com/photo-1622483767028-3f66f32aef97',
        'categoryId': 'drinks',
      },
    ];

    for (var product in products) {
      await firebaseService.products.add(product);
    }
  }
}