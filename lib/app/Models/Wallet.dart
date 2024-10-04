import 'dart:convert';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

import '../http/controllers/wallet_controller.dart';

class Wallet {
  GetStorage? storage;
  dynamic walletData;

  Wallet() {
    // Initialize storage and read wallet data from GetStorage
    storage = GetStorage();
    String? walletDataString = storage?.read('wallets'); // Fetch wallet data as string
    // Get.snackbar('title', walletData);
    if (walletDataString != null) {
      // Parse the JSON string into a dynamic object
      walletData = jsonDecode(walletDataString);
    }
  }

  // This method retrieves and returns the currency data for all wallets
  Map<String,dynamic>  getCurrencyData (){
    Map<String,dynamic> walletInfoList = {};

    if (walletData == null || walletData['data'] == null || walletData['data']['wallets'] == null) {
      return {"No wallet data found":"No wallet data found"};
    }

    // Access the wallets array
    List<dynamic> wallets = walletData['data']['wallets'];

    // Loop through each wallet and retrieve its currency information
    for (var wallet in wallets) {
      var currency = wallet['currency'];
      Map<String, dynamic> data = {
        currency['currency_code']: currency
      };
      walletInfoList.addAll(data);

    }

    return walletInfoList; // Returns the list of all wallets' information
  }
}

