import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'vi_VN': {
          // Nav bar
          'nav_home': 'Trang chủ',
          'nav_cart': 'Giỏ hàng',
          'nav_orders': 'Đơn hàng',
          'nav_profile': 'Hồ sơ',
          'nav_wishlist': 'Yêu thích',
          'nav_settings': 'Cài đặt',

          // Settings screen
          'settings_title': 'Cài đặt',
          'settings_appearance': 'Giao diện',
          'settings_theme': 'Chủ đề',
          'settings_theme_light': 'Sáng',
          'settings_theme_dark': 'Tối',
          'settings_font_size': 'Cỡ chữ',
          'settings_font_small': 'Nhỏ',
          'settings_font_normal': 'Vừa',
          'settings_font_large': 'Lớn',
          'settings_font_xlarge': 'Rất lớn',
          'settings_language': 'Ngôn ngữ',
          'settings_language_section': 'Ngôn ngữ & Khu vực',
          'settings_lang_vi': 'Tiếng Việt',
          'settings_lang_en': 'Tiếng Anh',
          'settings_account': 'Tài khoản',
          'settings_logout': 'Đăng xuất',
          'settings_logout_confirm': 'Bạn có chắc muốn đăng xuất không?',
          'settings_logout_yes': 'Đăng xuất',
          'settings_logout_cancel': 'Hủy',
          'settings_version': 'Phiên bản ứng dụng',
          'settings_preview': 'Xem trước',
          'settings_preview_text': 'Đây là văn bản mẫu để xem trước cỡ chữ.',

          // General
          'app_name': 'FastFood',
          'loading': 'Đang tải...',
          'error': 'Lỗi',
          'success': 'Thành công',
          'cancel': 'Hủy',
          'confirm': 'Xác nhận',
          'save': 'Lưu',
          'edit': 'Chỉnh sửa',
          'delete': 'Xóa',
          'back': 'Quay lại',
          'search': 'Tìm kiếm',
          'no_data': 'Không có dữ liệu',

          // Home
          'home_greeting': 'Xin chào! 👋',
          'home_subtitle': 'Hôm nay bạn muốn ăn gì?',
          'home_popular': 'Phổ biến',
          'home_featured': 'Nổi bật',

          // Cart
          'cart_title': 'Giỏ hàng',
          'cart_empty': 'Giỏ hàng của bạn đang trống',
          'cart_total': 'Tổng cộng',
          'cart_checkout': 'Thanh toán',

          // Orders
          'orders_title': 'Lịch sử đơn hàng',
          'orders_empty': 'Bạn chưa có đơn hàng nào',
          'order_status_pending': 'Đang chờ',
          'order_status_processing': 'Đang xử lý',
          'order_status_delivered': 'Đã giao',
          'order_status_cancelled': 'Đã hủy',

          // Profile
          'profile_title': 'Hồ sơ cá nhân',
          'profile_edit': 'Chỉnh sửa hồ sơ',
          'profile_orders': 'Đơn hàng của tôi',
          'profile_addresses': 'Địa chỉ giao hàng',
          'profile_payment': 'Phương thức thanh toán',

          // Wishlist
          'wishlist_empty_title': 'Chưa có món yêu thích',
          'wishlist_empty_subtitle': 'Hãy thêm những món ăn bạn yêu thích vào danh sách này để tìm lại nhanh chóng nhé!',
        },
        'en_US': {
          // Nav bar
          'nav_home': 'Home',
          'nav_cart': 'Cart',
          'nav_orders': 'Orders',
          'nav_profile': 'Profile',
          'nav_wishlist': 'Wishlist',
          'nav_settings': 'Settings',

          // Settings screen
          'settings_title': 'Settings',
          'settings_appearance': 'Appearance',
          'settings_theme': 'Theme',
          'settings_theme_light': 'Light',
          'settings_theme_dark': 'Dark',
          'settings_font_size': 'Font Size',
          'settings_font_small': 'Small',
          'settings_font_normal': 'Normal',
          'settings_font_large': 'Large',
          'settings_font_xlarge': 'X-Large',
          'settings_language': 'Language',
          'settings_language_section': 'Language & Region',
          'settings_lang_vi': 'Vietnamese',
          'settings_lang_en': 'English',
          'settings_account': 'Account',
          'settings_logout': 'Logout',
          'settings_logout_confirm': 'Are you sure you want to logout?',
          'settings_logout_yes': 'Logout',
          'settings_logout_cancel': 'Cancel',
          'settings_version': 'App Version',
          'settings_preview': 'Preview',
          'settings_preview_text': 'This is a sample text to preview font size.',

          // General
          'app_name': 'FastFood',
          'loading': 'Loading...',
          'error': 'Error',
          'success': 'Success',
          'cancel': 'Cancel',
          'confirm': 'Confirm',
          'save': 'Save',
          'edit': 'Edit',
          'delete': 'Delete',
          'back': 'Back',
          'search': 'Search',
          'no_data': 'No data available',

          // Home
          'home_greeting': 'Hello! 👋',
          'home_subtitle': 'What would you like to eat today?',
          'home_popular': 'Popular',
          'home_featured': 'Featured',

          // Cart
          'cart_title': 'Cart',
          'cart_empty': 'Your cart is empty',
          'cart_total': 'Total',
          'cart_checkout': 'Checkout',

          // Orders
          'orders_title': 'Order History',
          'orders_empty': 'You have no orders yet',
          'order_status_pending': 'Pending',
          'order_status_processing': 'Processing',
          'order_status_delivered': 'Delivered',
          'order_status_cancelled': 'Cancelled',

          // Profile
          'profile_title': 'My Profile',
          'profile_edit': 'Edit Profile',
          'profile_orders': 'My Orders',
          'profile_addresses': 'Delivery Addresses',
          'profile_payment': 'Payment Methods',

          // Wishlist
          'wishlist_empty_title': 'No favorites yet',
          'wishlist_empty_subtitle': 'Add your favorite dishes to this list to find them again quickly!',
        },
      };
}
