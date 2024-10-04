
import 'package:get/get.dart';

import '../app/http/services/connectivity_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    injectService();
  }

  void injectService() {
    Get.put(ConnectivityService());
  }
}
