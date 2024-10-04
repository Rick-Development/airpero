import 'package:get/get.dart';

import '../../app/http/controllers/controllers/login/login_controller.dart';
import '../../app/http/services/auth_api_service.dart';



class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController(Get.find<AuthApiService>()));
  }
}
