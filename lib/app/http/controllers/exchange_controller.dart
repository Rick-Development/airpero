import 'dart:convert';

import 'package:waiz/resources/utils/app_colors.dart';
import '../../../resources/views/home/bills_payment/bill_success.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/routes.dart';
import 'package:waiz/app/http/services/api_services.dart';

import '../../Models/user/User.dart';

class ExchangeController extends GetxController {
  var fromCrypto = ''.obs;
  var toCrypto = ''.obs;
  var amount = ''.obs;
  var disable = false.obs;
  var isLoading = true.obs;
  GetStorage storage = GetStorage();
  ApiServices apiServices = ApiServices();
  User user = User();
  Map<String, String> headers = <String, String>{};

  // Specify the type as Map<String, dynamic>
  var fromCryptos = <Map<String, dynamic>>[].obs;
  var toCryptos = <Map<String, dynamic>>[].obs;
  var fromCryptoData = {};
  var toCryptoData = {};




  @override
  void onInit() {
    super.onInit();

    // Fetch user info from local storage or API
    User user = User(); // Replace with actual user fetching logic if necessary
    String accessToken = user.accessToken ?? '';  // Handle null
    String tokenType = user.tokenType ?? '';      // Handle null


    print("Access token>>>>>  $accessToken");

    // Set headers for authorization
    headers = {
      'Authorization': '$tokenType $accessToken',
      'Accept': 'application/json',
    };


  }


  Future<void> exchangeMoneyForm() async {
    print("get deposit methods");
    // Example request to fetch the wallet data
    String response = await apiServices.makeGetRequest(WebRoutes.exchangeMoney, headers);
    var data = json.decode(response);
    // Assign the fetched data directly, assuming it's in the correct format
    fromCryptos.value = List<Map<String, dynamic>>.from(data['data']['from_wallets']);
    toCryptos.value = List<Map<String, dynamic>>.from(data['data']['to_wallets']);
    print("from crypto ${fromCryptos}");
    print("to crypto ${toCryptos}");
  }


  Future<void> exchangeConfirm() async {
    print("exchangeConfirm()");

    // Retrieve stored crypto data
    var fromCrypto = storage.read('from_crypto');
    var toCrypto = storage.read('to_crypto');
    var fromCryptoAmount = storage.read('from_crypto_amount');
    var toCryptoAmount = storage.read('to_crypto_amount');

    print('$fromCrypto');

    // Prepare request data
    var amount = fromCryptoAmount.toString();
    var fromWalletId = fromCrypto['id'].toString();
    var toWalletId = toCrypto['id'].toString();

    Map<String, dynamic> data = {
      'amount': amount,
      'from_wallet_id': fromWalletId,
      'to_wallet_id': toWalletId
    };

    // Make a POST request to exchange money
    try {
      String response = await apiServices.makePostRequest(
          WebRoutes.exchangeMoney, data, headers);

      // Decode the response
      var datas = json.decode(response);

      // Check the response status
      if (datas['status'] == 'success') {
        print('Response: $datas');

        // Display a success message
        Get.snackbar(
          'Success',
          datas['message']['success'][0],
          // Accessing the first message in the success list
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
        );

        // Navigate to the SuccessView with the success message
        Get.to(() => BillSuccess(content: datas['message']['success'][0]));
      } else {
        // Display an error message if status is not success
        Get.snackbar(
          'Error',
          datas['message']['error'], // Handle error messages if applicable
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle exceptions or errors during the request
      print('Error during exchange: $e');
      Get.snackbar(
        'Error',
        'An error occurred during the exchange. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void setFromCrypto(String value) {
    fromCrypto.value = value;
  }

  void setToCrypto(String value) {
    toCrypto.value = value;
  }
  
  void setAmount(String value, String currencyCode) {
    // print('currencyCode: ${toCrypto.value}');
    // Find the correct currency from the 'fromCryptos' list
    var selectedCrypto = fromCryptos.firstWhere(
          (crypto) => crypto['currency']['currency_code'] == currencyCode,
      orElse: () => <String, Object>{}, // Return an empty map instead of null
    );
    fromCryptoData = selectedCrypto;

    // Check if the selectedCrypto is not empty
    if (selectedCrypto.isNotEmpty) {

      print(selectedCrypto);
      // Retrieve balance and rate
      String balance = selectedCrypto['balance'];
      double fromCurrRate = double.parse(selectedCrypto['currency']['rate']);
      print('from rate: $fromCurrRate');

      // Ensure that the entered amount is valid
      if (double.tryParse(value) != null && double.parse(value) <= double.parse(balance)) {
        // Perform conversion calculations
        double baseCurrAmount = double.parse(value) * fromCurrRate;

        // Assuming you have a list of toCurrencies for exchange rates
        var toCurrency = toCryptos.firstWhere(
              (currency) => currency['currency']['currency_code'] == toCrypto.value,
          orElse: () => <String, Object>{}, // Get a different currency for conversion
        );
        // print(toCurrency);

        if (toCurrency.isNotEmpty) {
          double toCurrRate = double.parse(toCurrency['currency']['rate']);
          double toCurrType = double.parse(toCurrency['currency']['is_default'].toString()); // Assuming you have this type as in your JS code
          toCryptoData = toCurrency;
          print('to rate: $toCurrRate');
          // Perform the final conversion based on currency type
          double toCurrAmount;
          if (toCurrType == 1) {
            toCurrAmount = double.parse((baseCurrAmount / toCurrRate).toStringAsFixed(2));
          } else {
            toCurrAmount = double.parse((baseCurrAmount / toCurrRate).toStringAsFixed(8));
          }
          amount.value = toCurrAmount.toString();
          // Assuming you have methods to show confirmation modal
          // showConfirmationModal(currencyCode, value, toCurrAmount, toCurrency['currency_code']);
          disable.value = false; // Enable the exchange button
        } else {
          Get.snackbar(
            'Error',
            'Select a valid currency to exchange.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Handle cases where the entered amount exceeds the balance or is invalid
        disable.value = true;
        Get.snackbar(
          'Error',
          'Please provide a valid amount that does not exceed your balance.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      print(selectedCrypto);
      // Handle case where currency is not found
      Get.snackbar(
        'Error',
        'Select your currency.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

// Assuming you have a method to show the confirmation modal
//   void showConfirmationModal(String fromCurr, String amount, String toCurrAmount, String toCurr) {
//     // Implement modal display logic
//   }


}
