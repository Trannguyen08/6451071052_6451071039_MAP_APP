import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin_controller.dart';
import '../../../data/models/admin_user_model.dart';

class UserDataTable extends StatelessWidget {
  const UserDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Obx(() {
            final users = controller.dashboardData.value?.users ?? [];
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
              itemBuilder: (context, index) => _buildUserRow(users[index], controller),
            );
          }),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('Khách hàng', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 3, child: Text('Thông tin liên lạc', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 1, child: Text('Đơn hàng', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text('Tổng chi tiêu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 1, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildUserRow(AdminUser user, AdminController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('ID: ${user.id}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [const Icon(Icons.phone, size: 14, color: Colors.grey), const SizedBox(width: 8), Text(user.phone)]),
                Row(children: [const Icon(Icons.email, size: 14, color: Colors.grey), const SizedBox(width: 8), Text(user.email)]),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text('${user.ordersCount} đơn')),
          Expanded(flex: 2, child: Text('${user.totalSpending.toInt()}đ', style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: user.status == 'active' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 4, backgroundColor: user.status == 'active' ? Colors.green : Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    user.status == 'active' ? 'Hoạt động' : 'Bị khóa',
                    style: TextStyle(color: user.status == 'active' ? Colors.green : Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                _showActionMenu(user, controller);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showActionMenu(AdminUser user, AdminController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('Thao tác với ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(user.status == 'active' ? Icons.block : Icons.check_circle, color: Colors.red),
              title: Text(user.status == 'active' ? 'Khóa tài khoản' : 'Mở khóa tài khoản'),
              onTap: () {
                controller.toggleUserStatus(user.id, user.status);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Chỉnh sửa thông tin'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Hiển thị 1 - 4 của 12,543 khách hàng', style: TextStyle(color: Colors.grey)),
          Row(
            children: [
              _buildPageButton('<', isEnabled: false),
              _buildPageButton('1', isActive: true),
              _buildPageButton('2'),
              _buildPageButton('3'),
              const Text('...'),
              _buildPageButton('1254'),
              _buildPageButton('>'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageButton(String text, {bool isActive = false, bool isEnabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE94E1B) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : (isEnabled ? Colors.black : Colors.grey),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
