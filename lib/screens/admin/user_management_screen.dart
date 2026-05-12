import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/admin_controller.dart';
import 'admin_layout.dart';
import 'widgets/stat_card.dart';
import 'widgets/user_data_table.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return AdminLayout(
      title: 'Quản lý khách hàng',
      content: Obx(() {
        if (controller.isLoading.value && controller.dashboardData.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.dashboardData.value;
        if (data == null) return const Center(child: Text('Không có dữ liệu'));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xem danh sách và quản lý thông tin tài khoản người dùng.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'TỔNG KHÁCH HÀNG',
                    value: data.total.toString(),
                    percentage: '+12%',
                    icon: Icons.people_alt_outlined,
                    iconColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: StatCard(
                    title: 'HOẠT ĐỘNG',
                    value: data.active.toString(),
                    percentage: '98%',
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: StatCard(
                    title: 'BỊ KHÓA',
                    value: data.blocked.toString(),
                    percentage: '2%',
                    icon: Icons.block_outlined,
                    iconColor: Colors.red,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: StatCard(
                    title: 'CHI TIÊU TB',
                    value: '${data.avgSpending.toInt()}đ',
                    percentage: '+5.4%',
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const UserDataTable(),
          ],
        );
      }),
    );
  }
}
