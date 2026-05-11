import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/order_model.dart';
import '../data/services/order_service.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderController extends GetxController {
  final OrderService _orderService = OrderService();
  final GetStorage _storage = GetStorage();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<OrderModel> filteredOrders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'Tất cả'.obs;

  final List<String> statusOptions = [
    'Tất cả',
    'Đang xử lý',
    'Đã giao',
    'Đã hủy',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      // Trong thực tế, lấy userId từ token hoặc storage
      // Ở đây giả định chúng ta có userId (có thể lấy từ AuthController)
      // Để đơn giản cho việc test, tôi sẽ dùng một ID mẫu nếu không tìm thấy trong storage
      final userId = _storage.read('userId') ?? 'sample_user_id';
      
      final fetchedOrders = await _orderService.getOrders(userId);
      orders.value = fetchedOrders;
      _applyFilter();
    } catch (e) {
      print('Error in OrderController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilter(String status) {
    selectedStatus.value = status;
    _applyFilter();
  }

  void _applyFilter() {
    if (selectedStatus.value == 'Tất cả') {
      filteredOrders.value = orders;
    } else {
      String statusKey = '';
      switch (selectedStatus.value) {
        case 'Đang xử lý':
          statusKey = 'processing';
          break;
        case 'Đã giao':
          statusKey = 'delivered';
          break;
        case 'Đã hủy':
          statusKey = 'cancelled';
          break;
        default:
          statusKey = 'pending';
      }
      filteredOrders.value = orders.where((o) => o.status == statusKey).toList();
    }
  }

  String getStatusDisplay(String status) {
    switch (status) {
      case 'pending_payment':
        return 'Chờ thanh toán';
      case 'processing':
        return 'Đang xử lý';
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Đang chờ';
    }
  }

  Future<void> retryPayment(String orderId) async {
    try {
      isLoading.value = true;
      final checkoutUrl = await _orderService.retryPayment(orderId);
      if (await canLaunchUrl(Uri.parse(checkoutUrl))) {
        await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể khởi tạo lại thanh toán: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      isLoading.value = true;
      final success = await _orderService.cancelOrder(orderId);
      if (success) {
        Get.snackbar('Thành công', 'Đã hủy đơn hàng #$orderId');
        fetchOrders();
      }
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể hủy đơn hàng: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
