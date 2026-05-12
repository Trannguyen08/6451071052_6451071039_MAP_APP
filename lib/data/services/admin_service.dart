import 'package:get/get.dart';
import '../models/admin_user_model.dart';

class AdminService extends GetConnect {
  // Use http://localhost:5000 for Web, http://10.0.2.2:5000 for Android Emulator
  final String baseUrlStr = GetPlatform.isWeb ? 'http://localhost:5000/api' : 'http://10.0.2.2:5000/api';

  Future<AdminDashboardData> getUsers(String search) async {
    final response = await get('$baseUrlStr/admin/users', query: {'search': search});
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi tải danh sách người dùng';
    }
    return AdminDashboardData.fromJson(response.body);
  }

  Future<bool> updateUserStatus(String userId, String status) async {
    final response = await post('$baseUrlStr/admin/users/$userId/status', {'status': status});
    if (response.status.hasError) {
      throw response.statusText ?? 'Lỗi cập nhật trạng thái';
    }
    return response.body['success'] == true;
  }
}
