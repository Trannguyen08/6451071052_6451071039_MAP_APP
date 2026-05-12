import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verify_otp_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/admin/user_management_screen.dart';
import '../screens/admin/admin_login_screen.dart';
import '../screens/payment/payment_success_screen.dart';
import '../screens/main/main_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    // Main shell with bottom navigation bar
    GetPage(name: AppRoutes.main, page: () => const MainScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainScreen(initialIndex: 0),
    ),
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.verifyOtp, page: () => VerifyOtpScreen()),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const MainScreen(initialIndex: 3),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const MainScreen(initialIndex: 2),
    ),
    GetPage(name: AppRoutes.adminLogin, page: () => const AdminLoginScreen()),
    GetPage(
      name: AppRoutes.adminUsers,
      page: () => const UserManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => const PaymentSuccessScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const MainScreen(initialIndex: 4),
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const MainScreen(initialIndex: 1),
    ),
  ];
}
