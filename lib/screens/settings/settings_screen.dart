import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/settings_controller.dart';
import '../../routes/app_routes.dart';
import '../../controller/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          final isDark = settings.isDarkMode;
          return CustomScrollView(
            slivers: [
              _buildHeader(context, isDark),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Appearance ──────────────────────────────────────────
                    _SectionTitle(title: 'settings_appearance'.tr),
                    const SizedBox(height: 8),
                    _buildThemeCard(context, settings, isDark),
                    const SizedBox(height: 12),
                    _buildFontSizeCard(context, settings, isDark),
                    const SizedBox(height: 24),

                    // ── Language ─────────────────────────────────────────────
                    _SectionTitle(title: 'settings_language_section'.tr),
                    const SizedBox(height: 8),
                    _buildLanguageCard(context, settings, isDark),
                    const SizedBox(height: 24),

                    // ── Preview ───────────────────────────────────────────────
                    _SectionTitle(title: 'settings_preview'.tr),
                    const SizedBox(height: 8),
                    _buildPreviewCard(context, settings, isDark),
                    const SizedBox(height: 24),

                    // ── Account ───────────────────────────────────────────────
                    _SectionTitle(title: 'settings_account'.tr),
                    const SizedBox(height: 8),
                    _buildAccountCard(context, auth, isDark),
                    const SizedBox(height: 24),

                    // ── Version ───────────────────────────────────────────────
                    _buildVersionInfo(context, isDark),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 130,
      floating: false,
      pinned: true,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          'settings_title'.tr,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                  : [Colors.white, const Color(0xFFFFF3EE)],
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, top: 20),
              child: Icon(
                Icons.settings_rounded,
                size: 60,
                color: const Color(0xFFFF6B35).withOpacity(0.15),
              ),
            ),
          ),
        ),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
    );
  }

  // ─── Theme Card ───────────────────────────────────────────────────────────────
  Widget _buildThemeCard(BuildContext context, SettingsController settings, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SettingsIcon(
                icon: settings.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: const Color(0xFFFF6B35),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              Text(
                'settings_theme'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ThemeToggleButton(
                  label: 'settings_theme_light'.tr,
                  icon: Icons.light_mode_rounded,
                  isSelected: !settings.isDarkMode,
                  isDark: isDark,
                  onTap: () => settings.setTheme(ThemeMode.light),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ThemeToggleButton(
                  label: 'settings_theme_dark'.tr,
                  icon: Icons.dark_mode_rounded,
                  isSelected: settings.isDarkMode,
                  isDark: isDark,
                  onTap: () => settings.setTheme(ThemeMode.dark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Font Size Card ───────────────────────────────────────────────────────────
  Widget _buildFontSizeCard(BuildContext context, SettingsController settings, bool isDark) {
    final fontOptions = [
      {'label': 'settings_font_small'.tr, 'size': SettingsController.fontSizeSmall},
      {'label': 'settings_font_normal'.tr, 'size': SettingsController.fontSizeNormal},
      {'label': 'settings_font_large'.tr, 'size': SettingsController.fontSizeLarge},
      {'label': 'settings_font_xlarge'.tr, 'size': SettingsController.fontSizeXLarge},
    ];

    return _SettingsCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SettingsIcon(
                icon: Icons.text_fields_rounded,
                color: const Color(0xFF6C63FF),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'settings_font_size'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  settings.fontSizeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: fontOptions.map((opt) {
              final size = opt['size'] as double;
              final label = opt['label'] as String;
              final isSelected = settings.fontSize.value == size;
              return Expanded(
                child: GestureDetector(
                  onTap: () => settings.setFontSize(size),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF6C63FF)
                          : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF0F0F0)),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Aa',
                          style: TextStyle(
                            fontSize: size - 2,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.grey[300] : Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white.withOpacity(0.9)
                                : (isDark ? Colors.grey[500] : Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Language Card ─────────────────────────────────────────────────────────────
  Widget _buildLanguageCard(BuildContext context, SettingsController settings, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      child: Column(
        children: [
          Row(
            children: [
              _SettingsIcon(
                icon: Icons.language_rounded,
                color: const Color(0xFF00BFA5),
                isDark: isDark,
              ),
              const SizedBox(width: 12),
              Text(
                'settings_language'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LanguageButton(
                  flag: '🇻🇳',
                  label: 'settings_lang_vi'.tr,
                  langCode: 'vi',
                  isSelected: settings.language.value == 'vi',
                  color: const Color(0xFF00BFA5),
                  isDark: isDark,
                  onTap: () => settings.setLanguage('vi'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LanguageButton(
                  flag: '🇬🇧',
                  label: 'settings_lang_en'.tr,
                  langCode: 'en',
                  isSelected: settings.language.value == 'en',
                  color: const Color(0xFF00BFA5),
                  isDark: isDark,
                  onTap: () => settings.setLanguage('en'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Preview Card ─────────────────────────────────────────────────────────────
  Widget _buildPreviewCard(BuildContext context, SettingsController settings, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SettingsIcon(icon: Icons.preview_rounded, color: const Color(0xFFF59E0B), isDark: isDark),
              const SizedBox(width: 12),
              Text(
                'settings_preview'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FastFood App',
                  style: TextStyle(
                    fontSize: settings.fontSize.value + 4,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'settings_preview_text'.tr,
                  style: TextStyle(
                    fontSize: settings.fontSize.value,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'nav_home'.tr + ' • ' + 'nav_cart'.tr + ' • ' + 'nav_orders'.tr,
                  style: TextStyle(
                    fontSize: settings.fontSize.value - 2,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Account Card ─────────────────────────────────────────────────────────────
  Widget _buildAccountCard(BuildContext context, AuthController auth, bool isDark) {
    return _SettingsCard(
      isDark: isDark,
      child: GestureDetector(
        onTap: () => _showLogoutDialog(auth),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4444).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFFF4444),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'settings_logout'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF4444),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(AuthController auth) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('settings_logout'.tr),
        content: Text('settings_logout_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('settings_logout_cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Get.back();
              auth.logout();
            },
            child: Text('settings_logout_yes'.tr),
          ),
        ],
      ),
    );
  }

  // ─── Version Info ─────────────────────────────────────────────────────────────
  Widget _buildVersionInfo(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.fastfood_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            'FastFood App',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Components ──────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? Colors.grey[500] : Colors.grey[500],
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const _SettingsCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SettingsIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isDark;

  const _SettingsIcon({required this.icon, required this.color, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _ThemeToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                )
              : null,
          color: isSelected ? null : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String flag;
  final String label;
  final String langCode;
  final bool isSelected;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.flag,
    required this.label,
    required this.langCode,
    required this.isSelected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.12)
              : (isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF0F0F0)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flag, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? color
                      : (isDark ? Colors.grey[400] : Colors.grey[700]),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle_rounded, color: color, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
