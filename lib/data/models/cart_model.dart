class CartItem {
  final String id;
  final String name;
  final String options;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.id,
    required this.name,
    required this.options,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      options: json['options'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'options': options,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}

class CartData {
  final List<CartItem> items;
  final DeliveryInfo deliveryInfo;
  final String paymentMethod;
  final double subtotal;
  final double shippingFee;
  final double discount;
  final double total;

  CartData({
    required this.items,
    required this.deliveryInfo,
    required this.paymentMethod,
    required this.subtotal,
    required this.shippingFee,
    required this.discount,
    required this.total,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
      deliveryInfo: DeliveryInfo.fromJson(json['deliveryInfo']),
      paymentMethod: json['paymentMethod'] ?? 'cash',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      shippingFee: (json['shippingFee'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}

class DeliveryInfo {
  final String address;
  final String name;
  final String phone;

  DeliveryInfo({
    required this.address,
    required this.name,
    required this.phone,
  });

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) {
    return DeliveryInfo(
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
