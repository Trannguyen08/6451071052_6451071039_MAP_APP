import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final GetStorage _storage = GetStorage();

  // ─── Keys ───────────────────────────────────────────────────────────────────
  static const _kTheme = 'theme_mode';
  static const _kFontSize = 'font_size';
  static const _kLanguage = 'language';

  // ─── Observables ────────────────────────────────────────────────────────────
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  final RxDouble fontSize = 14.0.obs;
  final RxString language = 'vi'.obs;

  // Font size options
  static const double fontSizeSmall = 12.0;
  static const double fontSizeNormal = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  // ─── Load from storage ───────────────────────────────────────────────────────
  void _loadSettings() {
    // Theme
    final savedTheme = _storage.read<String>(_kTheme) ?? 'light';
    themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

    // Font size
    final savedFont = _storage.read<double>(_kFontSize) ?? fontSizeNormal;
    fontSize.value = savedFont;

    // Language
    final savedLang = _storage.read<String>(_kLanguage) ?? 'vi';
    language.value = savedLang;
    _applyLanguage(savedLang);
  }

  // ─── Theme ──────────────────────────────────────────────────────────────────
  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
    _storage.write(_kTheme, mode == ThemeMode.dark ? 'dark' : 'light');
    Get.changeThemeMode(mode);
  }

  void toggleTheme() {
    setTheme(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  // ─── Font size ───────────────────────────────────────────────────────────────
  void setFontSize(double size) {
    fontSize.value = size;
    _storage.write(_kFontSize, size);
    // Obx in MyApp tracks fontSize.value, so theme rebuilds automatically
  }

  String get fontSizeLabel {
    switch (fontSize.value) {
      case fontSizeSmall:
        return language.value == 'vi' ? 'Nhỏ' : 'Small';
      case fontSizeLarge:
        return language.value == 'vi' ? 'Lớn' : 'Large';
      case fontSizeXLarge:
        return language.value == 'vi' ? 'Rất lớn' : 'X-Large';
      default:
        return language.value == 'vi' ? 'Vừa' : 'Normal';
    }
  }

  // ─── Language ────────────────────────────────────────────────────────────────
  void setLanguage(String lang) {
    language.value = lang;
    _storage.write(_kLanguage, lang);
    _applyLanguage(lang);
  }

  void _applyLanguage(String lang) {
    final locale = lang == 'vi' ? const Locale('vi', 'VN') : const Locale('en', 'US');
    Get.updateLocale(locale);
  }

  // ─── Theme data builders ─────────────────────────────────────────────────────
  ThemeData get lightTheme => _buildTheme(Brightness.light);
  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseColor = const Color(0xFFFF6B35);

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: baseColor,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A1A2E),
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        selectedItemColor: baseColor,
        unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey[400],
        elevation: 12,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textTheme: _buildTextTheme(isDark),
    );
  }

  TextTheme _buildTextTheme(bool isDark) {
    final baseColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final scale = fontSize.value / fontSizeNormal;

    return TextTheme(
      displayLarge: TextStyle(fontSize: 57 * scale, color: baseColor, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 45 * scale, color: baseColor),
      displaySmall: TextStyle(fontSize: 36 * scale, color: baseColor),
      headlineLarge: TextStyle(fontSize: 32 * scale, color: baseColor, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28 * scale, color: baseColor, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 24 * scale, color: baseColor, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 22 * scale, color: baseColor, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 16 * scale, color: baseColor, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 14 * scale, color: baseColor),
      bodyLarge: TextStyle(fontSize: 16 * scale, color: baseColor),
      bodyMedium: TextStyle(fontSize: 14 * scale, color: baseColor),
      bodySmall: TextStyle(fontSize: 12 * scale, color: isDark ? Colors.grey[400] : Colors.grey[600]),
      labelLarge: TextStyle(fontSize: 14 * scale, color: baseColor, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontSize: 12 * scale, color: baseColor),
      labelSmall: TextStyle(fontSize: 11 * scale, color: isDark ? Colors.grey[400] : Colors.grey[600]),
    );
  }
}
