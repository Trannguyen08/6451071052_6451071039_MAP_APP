class AdminUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final int ordersCount;
  final double totalSpending;
  String status;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.ordersCount,
    required this.totalSpending,
    required this.status,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      ordersCount: json['ordersCount'],
      totalSpending: json['totalSpending'].toDouble(),
      status: json['status'],
    );
  }
}

class AdminDashboardData {
  final int total;
  final int active;
  final int blocked;
  final double avgSpending;
  final List<AdminUser> users;

  AdminDashboardData({
    required this.total,
    required this.active,
    required this.blocked,
    required this.avgSpending,
    required this.users,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> json) {
    return AdminDashboardData(
      total: json['total'],
      active: json['active'],
      blocked: json['blocked'],
      avgSpending: json['avgSpending'].toDouble(),
      users: (json['users'] as List).map((u) => AdminUser.fromJson(u)).toList(),
    );
  }
}
