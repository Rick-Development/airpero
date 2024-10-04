import 'dart:convert';

import 'package:waiz/resources/views/success_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:http/http.dart' as http;
import '../../../routes/routes.dart';
import '../../Models/user/User.dart';

class PasswordController extends GetxController {
  var password = ''.obs; // Observable to store the current PIN
  late TextEditingController passwordController; // Controller for PIN input field
  User user = User();
  dynamic isLoading = true.obs;


  Future<void> changePassword( String newPin) async{
    String url = '';

    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.changePassword),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
          'password': newPin
        }),
      );

      var data = json.decode(response.body);
      print("password: $data");
      // if(data['message'])
      GetStorage().write('user_password',newPin);

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

  Future<String> makeRequest(String routeUrl, Map<String, dynamic> data) async {
    var url = Uri.parse(routeUrl);
    var response = await http.post(url, body: data);
    return response.body;
  }

  Future<bool> validate({required String oldPassword, required String password, required String password_confirmation}) async {
    isLoading.value = true; // Show loading animation
    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.changePassword),
        headers: {

          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
          "current_password": oldPassword,
          'password': password,
          'password_confirmation': password_confirmation,
        }),
      );
      // Parse the JSON string
      var decodedResponse = jsonDecode(response.body);
      print(response.body);

      String status = decodedResponse['status'];

      if (status == 'success') {
        // isLoading.value = fal

        Get.snackbar(
          'Success',
          'Password Changed successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
        );
        isLoading.value = false;

        Get.to(const SuccessView(content: 'Password Changed successful',));
        return true;
      } else {
        Get.snackbar(
              'Error',
              '${decodedResponse['message']['error'][0].toString()}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              icon: const Icon(Icons.warning_amber_rounded,
                  color: Colors.white),
            );
           isLoading.value = false;
         return false;
      }
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Error changing password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.white),
      );
      isLoading.value = false;
      return false;
    } finally {
      return false; // Hide loading animation
    }
  }


}
