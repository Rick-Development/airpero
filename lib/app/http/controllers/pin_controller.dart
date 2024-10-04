import 'dart:convert';

import 'package:waiz/resources/views/success_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import '../../../routes/routes.dart';
import '../../Models/user/User.dart';

class PinController extends GetxController {
  var pin = ''.obs; // Observable to store the current PIN
  late TextEditingController pinController; // Controller for PIN input field
  User user = User();
  dynamic isLoading = true.obs;


  Future<void> changePin( String newPin) async{
    String url = '';

    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.pin),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
            'pin': newPin
        }),
      );

      var data = json.decode(response.body);
      print("pin: $data");
      // if(data['message'])
      GetStorage().write('user_pin',newPin);

      Get.snackbar(
        'Success',
        'Pin Changed successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
      );

      Get.to(const SuccessView(content: 'Pin Changed successful',));
    }catch(e){
      print(e);
    }

  }

  @override
  void onInit() {
    super.onInit();
    pinController = TextEditingController(); // Initialize the TextEditingController
  }

  // Function to set the PIN once input is completed
  void setPin(String enteredPin) {
    pin.value = enteredPin;
    print('Entered PIN: $enteredPin');
    // You can add additional validation or API calls here if necessary
  }

  @override
  void onClose() {
    pinController.dispose(); // Dispose of the controller when done
    super.onClose();
  }
}
