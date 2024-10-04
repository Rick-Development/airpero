import 'package:waiz/app/http/services/api_services.dart';
import 'package:waiz/resources/views/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../resources/views/home/bills_payment/bill_success.dart';
// import '../../../resources/views/home/crypto/sell_crypto.dart';
import '../../../routes/routes.dart';
import '../../Models/user/User.dart';


class PaymentController extends GetxController{
  dynamic isLoading = true.obs;
  dynamic depositWallets = [].obs;
  List<Map<String, dynamic>> depositGateways = [];
  dynamic manualDepositDatas = [];
  dynamic selectedWallet = ''.obs;
  dynamic selectedGateway = ''.obs;
  dynamic min_amount = '0'.obs;
  dynamic max_amount = '0'.obs;
  dynamic paymentCurrencyShortCode = ''.obs;
  dynamic rate = ''.obs;
  GetStorage storage = GetStorage();
  ApiServices apiServices = ApiServices();
  User user = User();
  Map<String, String> headers = <String, String>{};

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

  void setSelectedWallet(dynamic val){
    selectedWallet.value = val;
  }

  void setSelectedGateway(dynamic val){
    selectedGateway.value = val;
  }

  Future<List<Map<String, dynamic>>> getGateways(String channel) async{
    // print("get deposit methods");
    depositGateways = [];
    // Example request to fetch the wallet data
    String response = await apiServices.makeGetRequest(WebRoutes.depositMethods, headers);
    var data = json.decode(response);
    dynamic walletsGateways = data['data']['wallets'];

    // Initialize cables map
    final Map<String, dynamic> gateway = {};
    walletsGateways.forEach((dynamic value) {
      if (value['currency_id'].toString() == channel && value['currency']['gateways'] != null && value['currency']['gateways'].isNotEmpty) {
        // Loop through each gateway and add it to depositGateways
        value['currency']['gateways'].forEach((gateway) {
          print(gateway);
          this.depositGateways.add({
            'gateway_name': gateway['name'],
            'min_amount': double.parse(gateway['min_amount']).toStringAsFixed(2),
            'max_amount': double.parse(gateway['max_amount']).toStringAsFixed(2),
            'percent_charge': gateway['percent_charge'],
            'fixed_charge': gateway['fixed_charge'],
            'rate':  double.parse(gateway['rate']).toStringAsFixed(2),
            'currency':gateway['currency'],
            'deposit_min_limit': gateway['deposit_min_limit'],
            'deposit_max_limit': gateway['deposit_max_limit'],
            'method_code': gateway['method_code'],
            'wallet_id': value['id'],
          });
        });

        print(value['currency']['gateways']);  // Print the list of gateways
      }
    });



    return this.depositGateways;
  }

  Future<void> getDepositMethods() async{
    print("get deposit methods");
    // Example request to fetch the wallet data
    String response = await apiServices.makeGetRequest(WebRoutes.depositMethods, headers);
    var data = json.decode(response);
    this.depositWallets.value =  data['data']['wallets'];
    print('data: ${this.depositWallets.value}');
  }

  //post
  Future<bool> depositInsert() async{
    print("manualDepositUpdate");
    // print(headers);
    // Example request to fetch the wallet data
    // print(WebRoutes.depositInsert);
    // print(storage.read(key));
    double amount  = storage.read('deposit_amount');
    dynamic info = storage.read('gateway');
    print(info);
    Map<String, dynamic> datas = {
      'amount' : amount,
      'method_code' : info['method_code'],
      'wallet_id' : info['wallet_id'],
    };
    // {"remark":"validation_error","status":"error","message":{"error":["The amount field is required.","The method code field is required.","The wallet id field is required."]}}


    // {gateway_name: Bitcon - Network, min_amount: 1000.00, max_amount: 10000000.00, percent_charge: 0.00, fixed_charge: 0.00000000, rate: 1600.00, currency: BTC, deposit_min_limit: 0.000014166218789854443, deposit_max_limit: 0.14166218789854443, method_code: 1000, wallet_id: 48}

    //I/flutter (14463): {"remark":"deposit_inserted","status":"success","message":{"success":["Deposit inserted"]},"data":{"deposit":{"user_id":11,"user_type":"USER","wallet_id":48,"currency_id":102,"method_code":1000,"method_currency":"BTC","amount":0.0299999999999999988897769753748434595763683319091796875,"charge":0,"rate":1,"final_amo":0.0299999999999999988897769753748434595763683319091796875,"btc_amo":0,"btc_wallet":"","trx":"2M52B8G6YA4F","updated_at":"2024-09-26T21:20:40.000000Z","created_at":"2024-09-26T21:20:40.000000Z","id":4},"redirect_url":"https:\/\/billvaolt.payvalue.com.ng\/app\/deposit\/confirm\/eyJpdiI6ImJJR3RkRCtDVldLbHZZUzVpd1Blb0E9PSIsInZhbHVlIjoiSTdEYTRVLy95T1V6UUJMY2hMcENBQT09IiwibWFjIjoiZjI5ZjdiM2MzNmU3MjQ1OGZmMjllODg3NGVmNWIwMDg0YjI2MTczNjY5OGI5MWM2N2Q2ZDc1OTZjYmM4MmFiMCIsInRhZyI6IiJ9"}}


    String response = await apiServices.makePostRequest(WebRoutes.depositInsert,datas, headers);
    var data = json.decode(response);
    print(data);
    if(data['status'] == 'success') {
      String redirect_url = data['data']['redirect_url'];
      Get.off(() => WebViewScreen(redirectUrl: redirect_url));
      // Get.snackbar('', data['data']['redirect_url']);
      // print(data['data']['redirect_url']);
      // this.depositWallets.value =  data['data']['wallets'];
      // print('data: ${this.depositWallets.value}');
      response = await apiServices.makeGetRequest(redirect_url, headers);
      data = json.decode(response);
      storage.write('trx', data['trx']);
      return true;
    }else{
      this.isLoading.value = false;
      return false;
    }
    // print(data['trx']);
  }

  Future<void> depositConfirm() async {

  }

  Future<void> manualDepositConfirm(String trx) async{
    // body: jsonEncode(data),
    // String response = await apiServices.makeGetRequest(url,headers);
    try {
      // var routeUrl = 'https://billvaolt.payvalue.com.ng/user/deposit/app/manual';
      // var url = Uri.parse(routeUrl);
      var data = {
        'trx': trx
      };
      // Sending POST request with encoded JSON body
      var response =  await apiServices.makePostRequest(WebRoutes.depositManualConfirm, data, headers);
      var datas = json.decode(response);
      this.manualDepositDatas = datas;
      print(this.manualDepositDatas);
    }catch(e){
      print(e);
    }

    // print(data);
  }

  //post
  Future<void> manualDepositUpdate() async {
    try{
      GetStorage storage = GetStorage();
      var trx = storage.read('trx');
      print(trx);
      Map<String, dynamic> data = {
        'trx':trx
      };
      print(WebRoutes.depositManualUpdate);
      var response =  await apiServices.makePostRequest(WebRoutes.depositManualUpdate, data, headers);
      var datas = json.decode(response);
      print(datas);

    }catch(e){
      print(e);
    }



  }

}
