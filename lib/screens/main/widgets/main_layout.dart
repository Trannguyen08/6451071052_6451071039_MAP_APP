import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/settings_controller.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const MainLayout({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() {
      final isDark = settings.isDarkMode;

      return Scaffold(
        body: body,
        bottomNavigationBar: AppBottomMenuBar(
          currentIndex: currentIndex,
          isDark: isDark,
          onTabSelected: onTabSelected,
        ),
      );
    });
  }
}

class AppBottomMenuBar extends StatelessWidget {
  final int currentIndex;
  final bool isDark;
  final ValueChanged<int> onTabSelected;

  const AppBottomMenuBar({
    super.key,
    required this.currentIndex,
    required this.isDark,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'nav_home'.tr,
                isSelected: currentIndex == 0,
                isDark: isDark,
                onTap: () => onTabSelected(0),
              ),
              _NavItem(
                icon: Icons.favorite_rounded,
                label: 'nav_wishlist'.tr,
                isSelected: currentIndex == 1,
                isDark: isDark,
                onTap: () => onTabSelected(1),
              ),
              _NavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'nav_cart'.tr,
                isSelected: currentIndex == 2,
                isDark: isDark,
                onTap: () => onTabSelected(2),
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'nav_orders'.tr,
                isSelected: currentIndex == 3,
                isDark: isDark,
                onTap: () => onTabSelected(3),
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'nav_settings'.tr,
                isSelected: currentIndex == 4,
                isDark: isDark,
                onTap: () => onTabSelected(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFFFF6B35);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: isSelected ? 26 : 24,
                color: isSelected
                    ? selectedColor
                    : (isDark ? Colors.grey[500] : Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? selectedColor
                    : (isDark ? Colors.grey[500] : Colors.grey[400]),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
