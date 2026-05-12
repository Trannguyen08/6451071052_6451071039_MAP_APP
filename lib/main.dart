import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'bindings/initial_binding.dart';
import 'controller/settings_controller.dart';
import 'utils/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load(fileName: "env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Register SettingsController before runApp so Obx can track it
  Get.put(SettingsController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    // Obx tracks ALL .obs reads inside builder, so any change to
    // themeMode, fontSize, or language triggers a rebuild of GetMaterialApp
    return Obx(() => GetMaterialApp(
      title: 'Fast Food App',
      debugShowCheckedModeBanner: false,
      // ── Translations ─────────────────────────────────────────────────
      translations: AppTranslations(),
      locale: settings.language.value == 'vi'
          ? const Locale('vi', 'VN')
          : const Locale('en', 'US'),
      fallbackLocale: const Locale('vi', 'VN'),
      // ── Themes ─────────────────────────────────────────────────────
      theme: settings.lightTheme,      // reads fontSize.value → tracked
      darkTheme: settings.darkTheme,
      themeMode: settings.themeMode.value,
      // ── Navigation ────────────────────────────────────────────────
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.onboarding,
      getPages: AppPages.pages,
    ));
  }
}
