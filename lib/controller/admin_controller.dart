import 'package:get/get.dart';
import '../data/models/admin_user_model.dart';
import '../data/services/admin_service.dart';

class AdminController extends GetxController {
  final AdminService _adminService = AdminService();
  
  var dashboardData = Rxn<AdminDashboardData>();
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      dashboardData.value = await _adminService.getUsers(searchQuery.value);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleUserStatus(String userId, String currentStatus) async {
    try {
      final newStatus = currentStatus == 'active' ? 'blocked' : 'active';
      final success = await _adminService.updateUserStatus(userId, newStatus);
      if (success) {
        fetchUsers();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void onSearch(String query) {
    searchQuery.value = query;
    fetchUsers();
  }
}
