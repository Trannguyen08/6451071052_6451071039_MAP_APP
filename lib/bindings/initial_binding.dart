import 'package:get/get.dart';
import '../data/services/firebase_service.dart';
import '../controller/auth_controller.dart';


class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseService(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
