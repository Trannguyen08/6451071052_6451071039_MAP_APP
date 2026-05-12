import 'package:get/get.dart';
import '../screens/home/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/verify_otp_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/order/order_history_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/admin/user_management_screen.dart';
import '../screens/payment/payment_success_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../bindings/home_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    // ... existing pages
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () =>  HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => VerifyOtpScreen(),
    ),
    GetPage(
      name: AppRoutes.orderHistory,
      page: () => const OrderHistoryScreen(),
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartScreen(),
    ),
    GetPage(
      name: AppRoutes.adminUsers,
      page: () => const UserManagementScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => const PaymentSuccessScreen(),
      // name: AppRoutes.home,
      // page: () => const HomeScreen(),
    ),
    GetPage(
    name: AppRoutes.productDetail,
    page: () => ProductDetailScreen(),
   ),
  ];
}
