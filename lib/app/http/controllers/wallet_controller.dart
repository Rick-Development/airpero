import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waiz/app/http/services/api_services.dart';
import 'package:waiz/routes/routes.dart';

import '../../Models/user/User.dart';

class WalletController extends GetxController {
  var isLoading = false.obs; // Observable for loading state
  var walletBalance = 0.0.obs; // Observable for wallet balance
  final GetStorage storage = GetStorage(); // Local storage instance
  ApiServices apiServices = ApiServices();
  Map<String, String> headers = <String, String>{};

  @override
  void onInit() {
    super.onInit();

    // Fetch user info from local storage or API
    User user = User(); // Replace with actual user fetching logic if necessary
    String accessToken = user.accessToken ?? '';  // Handle null
    String tokenType = user.tokenType ?? '';      // Handle null

    if (accessToken.isEmpty || tokenType.isEmpty) {
      print("Access token or token type is missing.");
      Get.snackbar("Error", "Missing access token or token type");
      return;
    }

    print("Access token>>>>>  $accessToken");

    // Set headers for authorization
    headers = {
      'Authorization': '$tokenType $accessToken',
      'Accept': 'application/json',
    };
  }

  // Fetch wallet response
  Future<void> fetchResponse() async {
    isLoading(true); // Start loading
    try {
      // Example request to fetch the wallet data
      String response = await apiServices.makeGetRequest(WebRoutes.wallets, headers);

      // Store response in local storage
      storage.write('wallets', response);

      // Optionally show feedback
      // Get.snackbar('Wallet Fetched', 'Successfully fetched wallet data');

    } catch (error) {
      // Handle and display error properly
      print("Error fetching wallet data: $error");
      Get.snackbar('Error', 'Failed to fetch wallet data: $error');
    } finally {
      isLoading(false); // Stop loading
    }
  }
}
