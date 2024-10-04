import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../resources/views/home/bills_payment/bill_success.dart';
import '../../../routes/routes.dart';
import '../../Models/user/User.dart';

class BillPaymentsController extends GetxController {
  dynamic airtimeShortcutAmount = 100.obs;
  dynamic networkLogo = 'mtn'.obs;
  dynamic selectedDataBundle = ''.obs;
  dynamic selectedTvPlan = ''.obs;
  dynamic selectedTvPackage = ''.obs;
  dynamic selectedBroker = ''.obs;
  dynamic selectedElectricityPlan = ''.obs;
  dynamic selectedElectricityPackage = ''.obs;
  dynamic status = ''.obs;
  dynamic dataamount = '50'.obs;
  dynamic isLoading = true.obs;
  dynamic electric_company_code = ''.obs;
  late List<Map<String, dynamic>> dataBundles = [];
  late List<Map<String,dynamic>> tv_cable = [];
  late List<Map<String,dynamic>> tv_packages = [];
  late List<Map<String,dynamic>> electricity_packages = [];
  late List<Map<String,dynamic>> electrict_plans = [];
  late List<Map<String,dynamic>> brokers = [];
  GetStorage storage = GetStorage();
  User user = User();
  late String accessToken;
  late String tokenType ;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getdataBundles();
    String accessToken = user.accessToken;
    String tokenType = user.tokenType;
  }

  void setAirtimeShortcutAmount(dynamic val) {
    airtimeShortcutAmount.value = val;
  }

  void setSelectDataBundle(dynamic val){
    selectedDataBundle.value = val;
  }
  void electricCompanyCode(dynamic val){
    electric_company_code.value = val.toString();
  }
  void setSelectedBroker(dynamic val){
    selectedBroker.value = val;
  }

  void setSelectTvPackage(dynamic val){
    selectedTvPackage.value = val;
  }

  void setSelectTvPlan(dynamic val){
    getTvPackages(val);
    selectedTvPlan.value = val;
  }
  void setSelectElectricityPlan(dynamic val){
    selectedElectricityPlan.value = val;
  }
  void setSelectElectricityPackage(dynamic val){
    selectedElectricityPackage.value = val;
  }

  void setNetworkLogo(String val) {
    networkLogo.value = val;
  }

  Future<bool> buyAirtime() async{
    var buy_airtime = storage.read('buy_airtime');
    print('phone number: ${buy_airtime['phone_number']}');
    double amount  = double.parse(buy_airtime['amount'].replaceAll("₦",""));
    print("${buy_airtime['network'] } ${buy_airtime['phone_number']} ${amount}");
    String network = buy_airtime['network'].toString();
    String phone_number = buy_airtime['phone_number'].toString();
    String network_id = '01';
    if(network == 'mtn'){
      network_id = '01';
    }else if(network == 'airtel'){
      network_id = '04';
    }else if(network == 'glo'){
      network_id = '02';
    }else if(network == '9mobile'){
      network_id = '03';
    }
    await purchaseAirtime(network_id,phone_number,amount);
    return false;
  }

  Future<void> buyData() async{
    var buy_data = storage.read('buy_data');
    print(buy_data);
    print('phone number: ${buy_data['phone_number']}');
    String network = buy_data['network'].toString();
    String phone_number =  buy_data['phone_number'].toString();
    String amount = buy_data['amount'].toString();
    String network_id = '01';
    if(network == 'mtn'){
      network_id = '01';
    }else if(network == 'airtel'){
      network_id = '04';
    }else if(network == 'glo'){
      network_id = '02';
    }else if(network == '9mobile'){
      network_id = '03';
    }

    await purchaseDataBundle(network_id,phone_number,amount);
    // {orderid: 6630694527, statuscode: 100, status: ORDER_RECEIVED, productname: 500 MB, amount: 149, mobilenetwork: MTN, mobilenumber: 09069138338, walletbalance: 794.081298828125}
    // return false;
  }

  Future<bool> subscribeTv() async{
    // var buy_data = storage.read('tv_plan');
    // print('phone number: ${buy_data['phone_number']}');
    final tv = storage.read('cable_tv');
    print(tv);
    try {
      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.cableTV),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        //     $network = $request->network;
        // $package = $request->package;
        //     $amount = $request->amount;
        //     $requestID = $request->request_id;
        // $smartcard = $request->smartcard;
        // $phonenumber = $request->phone_number;
        body: jsonEncode({
          'network': tv['channel'].toString(),
          'request_id': '1'.toString(),
          'smartcard': tv['smartcard'].toString(),
          'amount': tv['amount'].toString(),
          'phone_number': '08111218116'.toString(),
        }),
      );

      var data = json.decode(response.body);
      print(data);
      if (response.statusCode == 200 && data['status'] == "ORDER_RECEIVED") {
        // Handle success
        this.status.value = data['status'];
        print("Airtime purchased successfully: ${data['status']}");

        Get.snackbar(
          'Success',
          'Top Up successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
        );

        Get.to(BillSuccess());
      } else {
        // Handle failure
        var errorMessage = data.containsKey('status') ? data['status'] : 'An error occurred';
        print("Failed to subscribe: $errorMessage");


        Get.snackbar(
          'Error',errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
      }
    } catch (e) {
      // Handle error
      print("Error purchasing data bundle: $e");
    }
    return false;
  }

  Future<bool> fundBetting() async{
    var electricity = storage.read('betting');
    // print('phone number: ${buy_data['phone_number']}');
    // print(electricity);

    // 'plan': plan,
    dynamic amount =  electricity['amount'].toString();
    var channel = electricity['channel'].toString();
    var sport_id = electricity['sport_id'].toString();
    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.fundBettingWallet),
        headers: {

          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
          'betting_company': channel,
          'phone_number': User().mobile.toString(),
          'amount': amount,
          'request_id':1,
          'customer_id': sport_id,
        }),
      );
      // print(data);

      var data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == "ORDER_RECEIVED") {
        // Handle success
        this.status.value = data['status'];
        storage.write('bill_payment_response', data['status']);
        print("Airtime purchased successfully: ${data['status']}");

        Get.snackbar(
          'Success',
          'Top Up successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
        );

        Get.to(BillSuccess());
      } else {
        print(data);
        // Handle failure
        var errorMessage = data.containsKey('message') ? data['message'] : 'An error occurred';
        print("Failed to fund your wallet: $errorMessage");

        storage.write('bill_payment_response', "Failed to fund your wallet: $errorMessage");

        Get.snackbar(
          'Error',

          'Failed to fund your wallet: ${data['status'].toString()}',
          // storage.read('bill_payment_response').toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
      }

    } catch (e) {
      // Handle error
      print("Error purchasing airtime: $e");
      this.status.value = "Error purchasing airtime: $e";
      storage.write('bill_payment_response',"Error purchasing airtime: $e");
    }

    return false;
  }

  Future<bool> subscribeElectricity() async{
    var electricity = storage.read('electricity');
    // {plan: {PRODUCT_ID: 01, PRODUCT_TYPE: prepaid, MINIMUN_AMOUNT: 1000, MAXIMUM_AMOUNT: 50000}, amount: 333333333333, channel: IKEJA ELECTRIC - IKEDC (PHCN)}
    // print('phone number: ${buy_data['phone_number']}');
    // $amount = $request->amount;
    // $requestID = $request->request_id;
    // $callbackURL = $request->callback_url;
    // $electric_company_code = $request->electric_company_code;
    // $recipient_phoneno = $request->recipient_phoneno;
    // $meter_type = $request->meter_type;
    // $meter_no = $request->meter_no;

    // 'plan': plan,
    dynamic amount =  electricity['amount'].toString();
    var channel = electricity['channel'].toString();
    var meter_number = electricity['meter_number'].toString();
    var meter_type = electricity['plan']['PRODUCT_ID'].toString();
    var electricCompanyCode = electricity['electric_company_code'].toString();
    print('electric_company_code: $electricCompanyCode');
    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.fundElectricity),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
          'electric_company_code': electricCompanyCode,
          'recipient_phoneno': User().mobile.toString(),
          'amount': amount,
          'request_id':1,
          'meter_type': meter_type,
          'meter_no': meter_number,
        }),
      );
      // print(data);

      var data = json.decode(response.body);
      print(data);

      if (response.statusCode == 200 && data['status'] == "ORDER_RECEIVED") {
        // Handle success
        this.status.value = data['status'];
        storage.write('bill_payment_response', data['status']);
        // print("Airtime purchased successfully: ${data['status']}");

        Get.snackbar(
          'Success',
          'Top Up successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
        );

        Get.to(BillSuccess());
      } else {
        print(data['status'].toString());
        // Handle failure
        var errorMessage = data.containsKey('message') ? data['message'] : 'Invalid Meter Number';
        print("Failed to Subscribe your meter: $errorMessage");
        errorMessage == null ? errorMessage : "Invalid Meter Info";
        storage.write('bill_payment_response', "Failed to Subscribe your meter: $errorMessage");

        Get.snackbar(
          'Error',

          "Failed to Subscribe your meter: $errorMessage",
          // storage.read('bill_payment_response').toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
        print(electricity);
      }

    } catch (e) {
      // Handle error
      // print(data);
      print("Error purchasing airtime: $e");
      this.status.value = "Error Subscribing your meter: $e";
      storage.write('bill_payment_response',"Error Subscribing your meter: $e");
    }


    return false;
  }
  Future<List<Map<String, dynamic>>> getTvPackages(String channel) async {
    this.tv_packages = [];
    try {
      // Make the API call
      final response = await http.get(
        Uri.parse('https://www.nellobytesystems.com/APICableTVPackagesV2.asp'),
      );

      // Decode the response body
      final decodedResponse = json.decode(response.body);

      // Assuming 'TV_ID' is the key that holds the bundles
      final tvID = decodedResponse['TV_ID'];
      // print('tv packages for ${channel}: ${tvID['DStv']}');

      // Initialize cables map
      final Map<String, dynamic> cables = {};

      int count = 1;

// Iterate through the 'tvID' data
      tvID.forEach((String key, dynamic value) {
        // Add data to the 'cables' map
        // cables[key] = key;
        if(channel.toUpperCase() == key.toString().toUpperCase()){
          // tvID[key.toString()]
          dynamic packages = tvID[key.toString()][0]['PRODUCT'];
          packages.forEach((package) {
            print('Package Name: ${package['PACKAGE_NAME']}, Price: ${package['PACKAGE_AMOUNT']}');
            this.tv_packages.add({
                'id': count,
                'PACKAGE_NAME': package['PACKAGE_NAME'],
                'PACKAGE_AMOUNT': package['PACKAGE_AMOUNT'],
                'img':channel,
              });


            count++;
          });
          // print('tv packages for ${channel}: ${tvID[key.toString()][0]['PRODUCT']}');
        }
      });

      // print('cables ${cables}');
      // this.tv_cable = [cables];
    } catch (e) {
      print("Error: $e");
    }

    print(this.tv_packages);

    return this.tv_packages;
  }

  Future<List<Map<String, dynamic>>> getTvBundles() async {
    this.tv_cable = [];
    try {
      // Make the API call
      final response = await http.get(
        Uri.parse('https://www.nellobytesystems.com/APICableTVPackagesV2.asp'),
      );

      // Decode the response body
      final decodedResponse = json.decode(response.body);

      // Assuming 'TV_ID' is the key that holds the bundles
      final tvID = decodedResponse['TV_ID'];

      // Initialize cables map
      final Map<String, dynamic> cables = {};

      int count = 1;

// Iterate through the 'tvID' data
      tvID.forEach((String key, dynamic value) {
        // Add data to the 'cables' map
        // cables[key] = key;

        // Add the TV bundle to the 'tv_cable' list
        this.tv_cable.add({
          'id': count,
          'title': key.toString().toUpperCase(),
          'img': key.toString().toLowerCase(),
        });

        // Increment the count
        count++;
      });

      // print('cables ${cables}');
      // this.tv_cable = [cables];
    } catch (e) {
      print("Error: $e");
    }
 // this.getTvPackages(this.);

    print(this.tv_cable);

    return this.tv_cable;
  }
  Future<List<Map<String,dynamic>>> getBrokers() async{
    this.brokers = [];
    // https://www.nellobytesystems.com/APIBettingCompaniesV2.asp
    try {
      // Make the API call
      final response = await http.get(
        Uri.parse('https://www.nellobytesystems.com/APIBettingCompaniesV2.asp'),
      );

      // Decode the response body
      final decodedResponse = json.decode(response.body);
      // Assuming 'TV_ID' is the key that holds the bundles
      final electricityID = decodedResponse['BETTING_COMPANY'];
      // print('tv packages for ${channel}: ${tvID['DStv']}');
      int count = 1;
      electricityID.forEach((dynamic value) {
        // print('key  - value: ${value['PRODUCT_CODE']}');
        this.brokers.add({
            'id': count,
            'title': value['PRODUCT_CODE'].toString(),
            'img': 'dstv'
        });
        count++;
      });
      // print(decodedResponse);
    }catch(e){
      print('EXCEPTION $e');
    }

    return this.brokers;
  }

  Future<List<Map<String, dynamic>>> getElectricityPackages(String channel) async {
    print(channel);
    this.electricity_packages = [];
    try {
      // Make the API call
      final response = await http.get(
        Uri.parse('https://www.nellobytesystems.com/APIElectricityDiscosV1.asp'),
      );

      // Decode the response body
      final decodedResponse = json.decode(response.body);

      // Assuming 'TV_ID' is the key that holds the bundles
      final electricityID = decodedResponse['ELECTRIC_COMPANY'];
      // print('tv packages for ${channel}: ${tvID['DStv']}');

      // Initialize cables map
      final Map<String, dynamic> cables = {};

      int count = 1;


      electricityID.forEach((String key, dynamic value) {
        value.forEach((innerValue) {
          // print('inner value: ${innerValue['NAME']}');
          if(channel.toUpperCase() == innerValue['NAME'].toString().toUpperCase()){
            // tvID[key.toString()]
            print(channel);
            dynamic packages = innerValue['PRODUCT'];
            // print(electricityID[key.toString()]);
            packages.forEach((package) {
              print('Package Name: ${package['PRODUCT_TYPE']}, Price: ${package['PRODUCT_ID']}');
              this.electricity_packages.add({
                'PRODUCT_ID': package['PRODUCT_ID'],
                'PRODUCT_TYPE': package['PRODUCT_TYPE'],
                "MINIMUN_AMOUNT": package["MINIMUN_AMOUNT"],
                "MAXIMUM_AMOUNT": package["MAXIMUM_AMOUNT"],
              });


              // count++;
            });
            // print('tv packages for ${channel}: ${tvID[key.toString()][0]['PRODUCT']}');
          }
        });


      });
    } catch (e) {
      print("Error: $e");
    }

    return this.electricity_packages;
  }


  Future<Map<String, dynamic>> fetchElectricityData() async {
    final String apiUrl = "https://www.nellobytesystems.com/APIElectricityDiscosV1.asp";
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Map<String,dynamic>>> getElectricityPlans() async{
    try {
      final response = await http.get(
        Uri.parse(
        'https://www.nellobytesystems.com/APIElectricityDiscosV1.asp'
        ),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var electricityID = data['ELECTRIC_COMPANY'];
        Map<String, dynamic> electricity_company = {};
        print(data);
        int count = 1;

// Iterate through the 'tvID' data
        electricityID.forEach((String key, dynamic value) {
          // print('key: $key - value: ${value}');
          // Add data to the 'cables' map
          // cables[key] = key;
          value.forEach((innerValue) {
            // print('inner value: ${innerValue['ID']}');
            // this.electric_company_code.value = innerValue['ID'].toString();
            // print('inner value: ${this.electric_company_code}');
            this.electrict_plans.add({
              'id':  innerValue['ID'].toString(),
              'title': innerValue['NAME'].toString().toUpperCase(),
              'img': '',
            });
          });
          // Increment the count
          count++;
        });

      } else {

      }
    }catch(e){
      print('EXCEPRION OCCURED AT: $e');
    }
    //     this.electrict_plans = [
    //   {'id': 1,'title': 'Ikeja Electricty','img': 'dstv'},
    //   {'id': 2,'title': 'Abuja Electricty','img': 'gotv'},
    //   {'id': 2,'title': 'Ibadan Electricty','img': 'startimes'},
    // ];
    return this.electrict_plans;
  }


  Future<List<Map<String, dynamic>>> getdataBundles() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.nellobytesystems.com/APIDatabundlePlansV2.asp?UserID=CK100135711'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var network_name;
        var network_ = '${networkLogo.value.toString()}';
        if(network_ == 'mtn'){
          network_name =  network_.toUpperCase();
        }else if(network_ == 'airtel'){
          network_name = 'Airtel';
        }else if(network_ == 'glo'){
          network_name = 'Glo';
        }else if(network_ == '9mobile'){
          network_name = 'm_9mobile';
        }

        print('Network: $network_name');


        (data['MOBILE_NETWORK'] as Map).forEach((key, value) {
          print('Network Name: $network_name - $key');
          if (key == network_name) {
            print('Matching data: ${value[0]['PRODUCT']}');
            this.dataBundles = List<Map<String, dynamic>>.from(value[0]['PRODUCT']);
          }
        });

      } else {
        print('Failed to fetch data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return this.dataBundles;
  }
  // Purchase Airtime
  Future<void> purchaseAirtime(String network, String phoneNumber, double amount) async {
    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.purchaseAirtime),
        headers: {

          'Content-Type': 'application/json',
          'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
          'network': network,
          'phone_number': phoneNumber,
          'amount': amount,
          'request_id':1,
        }),
      );

      var data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == "ORDER_RECEIVED") {
        // Handle success
        this.status.value = data['status'];
        storage.write('bill_payment_response', data['status']);
        print("Airtime purchased successfully: ${data['status']}");

        Get.snackbar(
          'Success',
          'Top Up successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
        );

        Get.to(BillSuccess());
      } else {
        // Handle failure
        var errorMessage = data.containsKey('status') ? data['status'] : 'An error occurred';
        print("Failed to purchase airtime: $data");

        storage.write('bill_payment_response', "Failed to purchase airtime: $errorMessage");

        Get.snackbar(
          'Error',
          storage.read('bill_payment_response').toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
      }

    } catch (e) {
      // Handle error
      print("Error purchasing airtime: $e");
      this.status.value = "Error purchasing airtime: $e";
      storage.write('bill_payment_response',"Error purchasing airtime: $e");
    }
  }

  // Purchase Data Bundle
  Future<void> purchaseDataBundle(String network, String phoneNumber, String bundleCode) async {
    try {

      String accessToken = user.accessToken;
      String tokenType = user.tokenType;
      final response = await http.post(
        Uri.parse(WebRoutes.purchaseData),
        headers: {
          'Content-Type': 'application/json',
           'Authorization': '$tokenType $accessToken', // Replace with your token logic
        },
        body: jsonEncode({
          'network': network,
          'phone_number': phoneNumber,
          'data_plan': bundleCode,
          'request_id':1
        }),
      );

      var data = json.decode(response.body);
      if (response.statusCode == 200 && data['status'] == "ORDER_RECEIVED") {
        // Handle success
        this.status.value = data['status'];
        print("Airtime purchased successfully: ${data['status']}");

        Get.snackbar(
          'Success',
          'Top Up successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          icon: const Icon(Icons.security_update_good_outlined, color: Colors.white),
        );

        Get.to(BillSuccess());
      } else {
        // Handle failure
        var errorMessage = data.containsKey('status') ? data['status'] : 'An error occurred';
        print("Failed to purchase airtime: $errorMessage");


        Get.snackbar(
          'Error',errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        );
      }
    } catch (e) {
      // Handle error
      print("Error purchasing data bundle: $e");
    }
  }

  // Query Transaction
  Future<void> queryTransaction(String orderId) async {
    try {
      final response = await http.post(
        Uri.parse(WebRoutes.queryTransaction),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token_here', // Replace with your token logic
        },
        body: jsonEncode({
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Handle success
        print("Transaction queried successfully: ${data['status']}");
      } else {
        var errorData = json.decode(response.body);
        // Handle failure
        print("Failed to query transaction: ${errorData['message']}");
      }
    } catch (e) {
      // Handle error
      print("Error querying transaction: $e");
    }
  }

  // Cancel Transaction
  Future<void> cancelTransaction(String orderId) async {
    try {
      final response = await http.post(
        Uri.parse(WebRoutes.cancelTransaction),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token_here', // Replace with your token logic
        },
        body: jsonEncode({
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Handle success
        print("Transaction canceled successfully: ${data['status']}");
      } else {
        var errorData = json.decode(response.body);
        // Handle failure
        print("Failed to cancel transaction: ${errorData['message']}");
      }
    } catch (e) {
      // Handle error
      print("Error canceling transaction: $e");
    }
  }

  // Verify Customer ID (IUC/Smartcard)
  Future<void> verifyCustomerID(String customerID, String serviceType) async {
    try {
      final response = await http.post(
        Uri.parse(WebRoutes.verifyCustomerID),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token_here', // Replace with your token logic
        },
        body: jsonEncode({
          'customerID': customerID,
          'serviceType': serviceType,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // Handle success
        print("Customer verified: ${data['customer_name']}");
      } else {
        var errorData = json.decode(response.body);
        // Handle failure
        print("Failed to verify customer: ${errorData['message']}");
      }
    } catch (e) {
      // Handle error
      print("Error verifying customer: $e");
    }
  }
}
