import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/admin_user_model.dart';

class AdminService extends GetConnect {
  late final String baseUrlStr = _resolveBaseUrl();
  final GetStorage _storage = GetStorage();

  static const _adminTokenKey = 'adminToken';
  static const _adminNameKey = 'adminName';
  static const _adminEmailKey = 'adminEmail';

  String get token => _storage.read(_adminTokenKey) ?? '';
  String get adminName => _storage.read(_adminNameKey) ?? 'Admin';
  String get adminEmail => _storage.read(_adminEmailKey) ?? '';
  bool get isLoggedIn => token.isNotEmpty;

  String _resolveBaseUrl() {
    if (!GetPlatform.isWeb) {
      return 'http://10.0.2.2:5000/api';
    }

    final uri = Uri.base;
    final isServedByBackend =
        (uri.host == 'localhost' || uri.host == '127.0.0.1') &&
        uri.port == 5000;
    return isServedByBackend ? '/api' : 'http://localhost:5000/api';
  }

  Map<String, String> get _authHeaders => {
    if (token.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  Future<AdminSession> login(String email, String password) async {
    final response = await post('$baseUrlStr/admin/login', {
      'email': email,
      'password': password,
    });

    if (response.status.hasError) {
      throw response.body?['error'] ??
          response.statusText ??
          'Loi dang nhap admin';
    }

    final session = AdminSession.fromJson(response.body);
    _storage.write(_adminTokenKey, session.token);
    _storage.write(_adminNameKey, session.name);
    _storage.write(_adminEmailKey, session.email);
    return session;
  }

  Future<void> logout() async {
    if (token.isNotEmpty) {
      await post('$baseUrlStr/admin/logout', {}, headers: _authHeaders);
    }
    _storage.remove(_adminTokenKey);
    _storage.remove(_adminNameKey);
    _storage.remove(_adminEmailKey);
  }

  Future<AdminDashboardData> getUsers(String search) async {
    final response = await get(
      '$baseUrlStr/admin/users',
      query: {'search': search},
      headers: _authHeaders,
    );
    if (response.status.hasError) {
      throw response.body?['error'] ??
          response.statusText ??
          'Loi tai danh sach nguoi dung';
    }
    return AdminDashboardData.fromJson(response.body);
  }

  Future<bool> createUser(Map<String, dynamic> data) async {
    final response = await post(
      '$baseUrlStr/admin/users',
      data,
      headers: _authHeaders,
    );
    if (response.status.hasError) {
      throw response.body?['error'] ??
          response.statusText ??
          'Loi tao khach hang';
    }
    return response.body['success'] == true;
  }

  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    final response = await put(
      '$baseUrlStr/admin/users/$userId',
      data,
      headers: _authHeaders,
    );
    if (response.status.hasError) {
      throw response.body?['error'] ??
          response.statusText ??
          'Loi cap nhat khach hang';
    }
    return response.body['success'] == true;
  }

  Future<bool> deleteUser(String userId) async {
    final response = await delete(
      '$baseUrlStr/admin/users/$userId',
      headers: _authHeaders,
    );
    if (response.status.hasError) {
      throw response.body?['error'] ??
          response.statusText ??
          'Loi xoa khach hang';
    }
    return response.body['success'] == true;
  }

  Future<bool> updateUserStatus(String userId, String status) async {
    final response = await post('$baseUrlStr/admin/users/$userId/status', {
      'status': status,
    }, headers: _authHeaders);
    if (response.status.hasError) {
      throw response.body?['error'] ??
          response.statusText ??
          'Loi cap nhat trang thai';
    }
    return response.body['success'] == true;
  }
}
