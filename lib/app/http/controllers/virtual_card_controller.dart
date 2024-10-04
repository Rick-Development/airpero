import 'package:get/get.dart';

class VirtualDollarCardController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    // This runs after the widget is initialized, ensuring the UI is ready
    // Get.snackbar("Controller Initialized", 'VirtualDollarCardController is ready');
  }

  // Map to hold card details
  Map<String, dynamic> get getCardDetails {
    return {
      "firstname": "Nwachukwu",
    };
  }

  // Method to check balance
  double get balance {
    return 10.00;
  }

  String get fullName{
    return 'Nwachukwu Patrick';
  }
  String get expiringDate{
    return "02/28";
  }

  String get cardNumber{
   return '0856  9575  6573  4848';
  }
}
