import 'dart:convert';
import 'package:waiz/app/http/controllers/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/routes/routes.dart';
import '../../../../resources/views/auth_views/login.dart';
import '../deposit_controller.dart';
import '../user_controller.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;  // Observable for loading state
  final GetStorage storage = GetStorage(); // Local storage instance

  // UserController userController =  Get.put(UserController());

  Future<String> makeRequest(String routeUrl, Map<String, dynamic> data) async {
    var url = Uri.parse(routeUrl);
    var response = await http.post(url, body: data);
    return response.body;
  }


  Future<String> makeGetRequest(String routeUrl, Map<String, String> data) async {
    var url = Uri.parse(routeUrl);
    var response = await http.get(url, headers: data);
    return response.body;
  }

  // Observable variables
  RxBool isLoggedIn = false.obs;
  RxMap<String, dynamic> userDetails = <String, dynamic>{}.obs;
// Login method
  Future<bool> login({required String email, required String password}) async {
    isLoading.value = true; // Show loading animation
    try {
      Map<String, String> data = {
        "username": email,
        'password': password,
      };
      String fullUrl = WebRoutes.login; // The URL will be correctly formatted
      String responseBody = await makeRequest(fullUrl, data);

      // Parse the JSON string
      var decodedResponse = jsonDecode(responseBody);
      print(responseBody);

      String status = decodedResponse['status'];

      if (status == 'success') {
        // Extract user and token details
        var userData = decodedResponse['data']['user'];
        String accessToken = decodedResponse['data']['access_token'];
        String tokenType = decodedResponse['data']['token_type'];

        // Store login status and user details in local storage
        storage.write('isLoggedIn', true);
        storage.write('userDetails', userData);
        storage.write('accessToken', accessToken);
        storage.write('tokenType', tokenType);
        Map<String, String> authData = {
          'Authorization': '$tokenType $accessToken',
          'Accept': 'application/json',
        };

        // Store in GetX variables
        userDetails.value = userData;
        await fetchDashboardData(authData);
        isLoggedIn.value = true;
        // Get.put(UserController());
        return true;
      } else {
        Get.snackbar("Error", "Invalid credentials",
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      print('Login failed: $e');
      return false;
    } finally {
      isLoading.value = false; // Hide loading animation
    }
  }


  // Fetch dashboard data
  Future<void> fetchDashboardData(dynamic data) async {
    isLoading(true); // Start loading
    try {

      String fullUrl = WebRoutes.dashboard;
      String response = await makeGetRequest(fullUrl, data);
      // API call to get dashboard data
      // String response = await apiServices.makeGetRequest(fullUrl, headers);

      // Store dashboard data in local storage
      storage.write('dashboard', response);


    } catch (error) {
      // Handle errors
      print("Error fetching dashboard data: $error");
      Get.snackbar('Error', 'Failed to fetch dashboard data: $error');
    } finally {
      isLoading(false); // Stop loading
    }
  }



  // Register method
  Future<bool> register({
    required String username,
    required String password,
    required String country,
    required String phone,
    required String email,
  }) async {
    isLoading.value = true;
    try {
      var mobile_code = '234';
      var mobile_ = int.parse(mobile_code);

      Map<String, dynamic> data = {
        'username': username,
        'password': password,
        'password_confirmation': password,
        'country': country,
        'country_code': "NG",
        "mobile_code": mobile_.toString(),
        'mobile': phone,
        'email': email,
        'account': '1',
        'agree': "true"
      };

      String fullUrl = WebRoutes.register;
      String responseBody = await makeRequest(fullUrl, data);
      var decodedResponse = jsonDecode(responseBody);
      print(decodedResponse);

      if (decodedResponse['status'] == 'success') {
        Get.snackbar("Success", "Signup successfully", backgroundColor: Colors.blue, colorText: Colors.white);
        // userController.fetchDashboardData();
        return true;
      } else {
        for (var error in (decodedResponse['message']['error'] as List)) {
          Get.snackbar("Error", error, backgroundColor: Colors.red, colorText: Colors.white);
        }
        return false;
      }
    } catch (e) {
      print('Registration failed: $e');
      return false;
    } finally {
    //   userController.fetchDashboardData();
      // userController.fetchUserInfo();
      isLoading.value = false;  // Hide loading animation
    }
  }

  // Retrieve stored user details
  Map<String, dynamic> getUserDetails() {
    Map<String, dynamic> storedUserDetails = storage.read('userDetails') ?? {};
    return storedUserDetails;
  }

  // Check if the user is already logged in
  void checkLoginStatus() {
    bool storedLoginStatus = storage.read('isLoggedIn') ?? false;
    Map<String, dynamic> storedUserDetails = storage.read('userDetails') ?? {};

    isLoggedIn.value = storedLoginStatus;
    userDetails.value = storedUserDetails;
  }

  // Logout method
  void logout(BuildContext context) {
    storage.erase();
    isLoggedIn.value = false;
    userDetails.clear();
    Get.offAll(const LoginView());
    Get.snackbar("Logged Out", "You have been logged out", backgroundColor: Colors.red, colorText: Colors.white);
  }
}
