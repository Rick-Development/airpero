import 'package:get/get.dart';

import '../app/http/controllers/auth/signup_controller.dart';
import '../app/http/services/auth_api_service.dart';



class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
        () => SignupController(Get.find<AuthApiService>()));
  }
}
