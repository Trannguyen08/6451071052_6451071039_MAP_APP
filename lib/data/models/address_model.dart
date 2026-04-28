class AddressModel {
  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String addressLine;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine,
    required this.isDefault,
  });

  factory AddressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AddressModel(
      id: id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      addressLine: data['addressLine'] ?? '',
      isDefault: data['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine': addressLine,
      'isDefault': isDefault,
    };
  }
}
