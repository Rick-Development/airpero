import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/controllers/wallet_controller.dart';
import 'package:waiz/utils/app_constants.dart';
import '../config/app_colors.dart';
import '../data/models/gateways_model.dart';
import '../data/repositories/add_fund_repo.dart';
import '../data/source/check_status.dart';
import '../routes/page_index.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';
import '../views/screens/add_fund/card_payment/card_payment_screen.dart';
import '../views/screens/payout/paynow_webview_screen.dart';
import '../views/widgets/app_payment_fail.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'money_transfer_controller.dart';

class AddFundController extends GetxController {
  static AddFundController get to => Get.find<AddFundController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController amountCtrl = TextEditingController();

  bool isUserIsFromMoneyTransferPage = true;
  Future getPaymentGateways() async {
    _isLoading = true;
    update();
    http.Response response = await AddFundnRepo.getGateways();
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        await getPaymentGateway(data);
        listenRazorPay();
        if (monnifyApiKey.isNotEmpty) {
          initMonnify();
        }
        initPayStack();
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['message']);
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPaymentGateways();
  }

  bool isSearchTapped = false;

  int selectedGatewayIndex = -1;
  bool isLoadingDetails = false;
  TextEditingController gatewayEditingController = TextEditingController();

  //---status 1 = active; status 0 = inactive;
  int discountStatus = -1;
  //---type 1 = percentage; type 0 = amount;
  int discountType = -1;
  String discountAmount = "0.00";

  //----GET PAYMENT GATEWAY DATA
  int selectedGatewayType = 0;
  Future getGatewayData(index) async {
    //---GATEWAY DATA
    Gateways data = isGatewaySearching
        ? searchedGatewayItem[index]
        : paymentGatewayList[index];
    gatewayName = data.name;
    // get the selected list and filter it
    var selectedGatewayElement =
        await paymentGatewayList.where((e) => e.name == data.name).toList();
    for (var i in selectedGatewayElement) {
      // check which type of gateway is selected
      // 1 = manual payement; 2 = other payment; 3 = card payment
      if (i.id! > 999) {
        selectedGatewayType = 1;
      } else if (i.code.toString().trim().toLowerCase() == "securionpay" ||
          i.code.toString().trim().toLowerCase() == "authorize.net") {
        selectedGatewayType = 3;
      } else {
        selectedGatewayType = 2;
      }
    }
  }

  bool isShopDetailsLoading = false;
  List<Gateways> paymentGatewayList = [];
  List<ManualPaymentDynamicFormModel> manualPaymentElementList = [];

  bool is_crypto = false;
  Future getPaymentGateway(data) async {
    // if the payment gateways are from add fund and gateway field is null
    if (data['message']['gateways'] is List) {
      paymentGatewayList = [];
      if (isUserIsFromMoneyTransferPage == true) {
        // add wallet payment gateway manually
        paymentGatewayList.add(Gateways(
          id: 0,
          name: "Wallet",
          code: "wallet",
          image: "$rootImageDir/wallet_payment.png",
          description: "",
          supportedCurrency: [],
          receivableCurrencies: [],
        ));
      }
      paymentGatewayList.addAll(GatewayModel.fromJson(data).message!.gateways!);
      await WalletController.to.getWallets();
      getNeededGatewayKeys(data['message']['gateways']);
      // filter manual payment list
      manualPaymentElementList = [];
      List allList = data['message']['gateways'];
      var manualList = allList.where((e) => e['id'] > 999).toList();
      // filter the dynamic field data of manual payments
      Map<String, dynamic> fieldList = {};
      for (var i in manualList) {
        fieldList.addAll(i['parameters']);
        fieldList.forEach((key, value) {
          manualPaymentElementList.add(ManualPaymentDynamicFormModel(
            gatewayName: i['name'],
            note: i['description'] ?? "",
            fieldName: value['field_name'],
            fieldLevel: value['field_label'],
            type: value['type'],
            validation: value['validation'],
          ));
        });
      }
      update();
    }
  }

  List<Gateways> searchedGatewayItem = [];
  bool isGatewaySearching = false;
  TextEditingController gatewaySearchCtrl = TextEditingController();
  queryPaymentGateway(String v) {
    searchedGatewayItem = paymentGatewayList
        .where((e) => e.name.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    selectedGatewayIndex = -1;
    if (v.isEmpty) {
      isGatewaySearching = false;
      searchedGatewayItem.clear();
      update();
    } else if (v.isNotEmpty) {
      isGatewaySearching = true;
      update();
    }
    update();
  }

  int gatewayId = 0;
  String gatewayName = "";
  String gatewayCode = "";
  dynamic selectedCurrency = null;
  dynamic selectedCryptoCurrency = null;
  String baseCurrency = "";
  List<ReceivableCurrencies> receivableCurrencies = [];
  List<dynamic> supportedCurrencyList = [];
  // wallet payment
  bool isPaymentTypeIsWallet = false;
  var wallet_id = "";
  Future getSelectedGatewayData(index,
      {bool? isFromMoneyTransferPage = true}) async {
    var data = isGatewaySearching == true
        ? searchedGatewayItem[index]
        : paymentGatewayList[index];                                                    
    gatewayId = data.id;
    gatewayName = data.name;
    gatewayCode = data.code.toString().trim().toLowerCase();
    if (data.is_crypto != null) {
      is_crypto = data.is_crypto;
    }
    amountCtrl.clear();
    amountValue = "";
    // if the payment gateway is wallet
    if (gatewayCode.trim().toLowerCase() == "wallet") {
      isPaymentTypeIsWallet = true;
      if (WalletController.to.walletDataList.isNotEmpty) {
        selectedCurrency =
            WalletController.to.walletDataList[0].currencyAndCountryName;
        wallet_id = WalletController.to.walletDataList[0].id.toString();
        await MoneyTransferController.to.getCurrencyRate(fields: {
          "selectedCurrency": selectedCurrency.toString().split(" ").first,
          "senderCurrency": MoneyTransferController.to.senderCurrency,
        });
      }
      update();
    }
    // if the gateway is not wallet
    else {
      // make wallet type false if the payment type is other
      isPaymentTypeIsWallet = false;
      // get the selected payment gateway's currency for getting the min, max, charge
      receivableCurrencies = [];
      if (data.receivableCurrencies != null) {
        receivableCurrencies = data.receivableCurrencies!;
      }
      // get the supported currencies for displaying in the payout page
      supportedCurrencyList = [];
      if (data.supportedCurrency != null) {
        supportedCurrencyList = data.supportedCurrency!;
        // this code is for moneyTransfer payment
        if (supportedCurrencyList.isNotEmpty) {
          // check the stripe gateway and fixed currency for SDK's payment
          if (gatewayCode.trim().toLowerCase() == "stripe") {
            selectedCurrency = "USD";
            supportedCurrencyList = ["USD"];
            getSelectedCurrencyData(selectedCurrency);
            if (isFromMoneyTransferPage == true) {
              await MoneyTransferController.to.getCurrencyRate(fields: {
                "selectedCurrency": selectedCurrency,
                "senderCurrency": MoneyTransferController.to.senderCurrency,
              });
            }
            update();
          }
          // if the payment gateway is other and not stripe
          else {
            // if (is_crypto == true) {
            //   selectedCurrency = "USD";
            // } else {
              selectedCurrency = supportedCurrencyList[0].toString();
              getSelectedCurrencyData(selectedCurrency);
            // }

            if (isFromMoneyTransferPage == true) {
              await MoneyTransferController.to.getCurrencyRate(fields: {
                "selectedCurrency": selectedCurrency,
                "senderCurrency": MoneyTransferController.to.senderCurrency,
              });
            }
          }
        } else {
          Helpers.showSnackBar(msg: "No supported currency found!");
        }
      }
    }
    update();
  }

  // this value is for send amount of SDK's gateway
  String sendAmount = "0";

  String amountValue = "";
  bool isFollowedTransactionLimit = true;
  onChangedAmount(v) {
    amountValue = v.toString();
    sendAmount = v.toString();
    MoneyTransferController.to.amountInSelectedCurr = v.toString();
    if (v.toString().isNotEmpty) {
      if ((double.parse(v.toString()) >= double.parse(minAmount)) &&
          (double.parse(v.toString()) <= double.parse(maxAmount))) {
        isFollowedTransactionLimit = true;
      } else {
        isFollowedTransactionLimit = false;
        Helpers.showSnackBar(
            msg:
                "minimum payment $minAmount and maximum payment limit $maxAmount");
      }
    }
    update();
  }

  // get the selected currency data
  String minAmount = "0.00";
  String maxAmount = "0.00";
  String charge = "0.00";
  String conversion_rate = "0.00";
  String percentage = "0";
  getSelectedCurrencyData(value) async {
    var selectedCurr = await receivableCurrencies.firstWhere((e) {
      if (e.name != null)
        return e.name == value;
      else {
        return e.currency == value;
      }
    });
    minAmount = selectedCurr.minLimit.toString();
    maxAmount = selectedCurr.maxLimit.toString();
    charge = selectedCurr.fixedCharge.toString();
    conversion_rate = selectedCurr.conversionRate.toString();
    percentage = selectedCurr.percentageCharge.toString();
    update();
  }

  final formKey = GlobalKey<FormState>();

  //---------------------PAYMENT GATEWAY--------------------//

  // on buy now clicked
  List<ManualPaymentDynamicFormModel> selectedManualPaymentList = [];
  bool isLoadingPaymentSheet = false;
  onBuyNowTapped({required BuildContext context}) async {
    //----if the selected payment type is empty
    if (selectedGatewayType == 0) {
      Helpers.showSnackBar(msg: "Please select a Payment Gateway first.");
    }
    //----manual payment
    else if (selectedGatewayType == 1) {
      selectedManualPaymentList = await manualPaymentElementList
          .where((e) => e.gatewayName == gatewayName)
          .toList();
      Get.toNamed(RoutesName.manualPaymentScreen);
      isLoadingPaymentSheet = true;
      update();
      isLoadingPaymentSheet = false;
      update();
    }
    //-----other payment and sdk payment
    else if (selectedGatewayType == 2) {
      if (gatewayCode == "stripe") {
        isLoadingPaymentSheet = true;
        update();
        await stripeDepositRequest();
        isLoadingPaymentSheet = false;
        update();
      } else if (gatewayCode == "flutterwave") {
        isLoadingPaymentSheet = true;
        update();
        await handleFlutterwavePaymentInitialization(context);
        isLoadingPaymentSheet = false;
        update();
      } else if (gatewayCode == "paytm") {
        isLoadingPaymentSheet = true;
        update();
        makePaytmPayment(); // 0 = testing mode
        isLoadingPaymentSheet = false;
        update();
      } else if (gatewayCode == "monnify") {
        isLoadingPaymentSheet = true;
        update();
        await makeMonnifyPayment();
        isLoadingPaymentSheet = false;
        update();
      } else if (gatewayCode == "paystack") {
        await payStackchargeCard(context);
      } else if (gatewayCode == "paypal") {
        makePaypalPaymentRequest();
      } else if (gatewayCode == "razorpay") {
        isLoadingPaymentSheet = true;
        update();
        await razorPayPaymentRequest();
        isLoadingPaymentSheet = false;
        update();
      } else {
        isLoadingPaymentSheet = true;
        update();
        await webviewPayment(trxId: this.trxId);
        isLoadingPaymentSheet = false;
        update();
      }
    }
    //----card payment
    else if (selectedGatewayType == 3) {
      Get.to(() => CardPaymentScreen(gatewayCode: gatewayCode));
    }
    update();
  }

  //------MANUAL PAYMENT
  Color fileColorOfDField = AppColors.mainColor;
  Future manualPayment(
      {required String trxId,
      required Map<String, String> fields,
      required Iterable<http.MultipartFile>? fileList}) async {
    _isLoading = true;
    update();
    http.Response response = await AddFundnRepo.manualPayment(
        trxid: trxId, fields: fields, fileList: fileList);
    _isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        Get.offAll(() => PaymentSuccessScreen());
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //------PAYMENT REQUEST DONE (this api will be called when add fund)
  var selectedWallet;
  String trxId = "";
  Future paymentRequest(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isLoadingPaymentSheet = true;
    update();
    http.Response response = await AddFundnRepo.paymentRequest(fields: fields);
    isLoadingPaymentSheet = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        trxId = data['message']['trx_id'].toString();
        await onBuyNowTapped(context: context);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //  WEBVIEW PAYMENT
  Future webviewPayment({required String trxId}) async {
    _isLoading = true;
    update();
    http.Response response = await AddFundnRepo.webviewPayment(trxId: trxId);
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        if (data['message']['url'] != null) {
          Get.to(() => CheckoutWebView(url: data['message']['url']));
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['message']);
      update();
    }
  }

  //------CARD PAYMENT
  Future cardPayment({required Map<String, String> fields}) async {
    _isLoading = true;
    update();
    http.Response response = await AddFundnRepo.cardPayment(fields: fields);
    _isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        Get.offAll(() => PaymentSuccessScreen());
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //------ON PAYMENT DONE
  Future onPaymentDone({required Map<String, String> fields}) async {
    isLoadingPaymentSheet = true;
    update();
    http.Response response = await AddFundnRepo.onPaymentDone(fields: fields);
    isLoadingPaymentSheet = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == "success") {
        Get.offAll(() => PaymentSuccessScreen());
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
        Get.offAll(() => BottomNavBar());
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  ///-------------------------All key of Payment Gateway--------------------
  getNeededGatewayKeys(List<dynamic> allList) {
    for (var i in allList) {
      // IF THE PARAMETERS FIELD IS EXIST
      if (i['parameters'] != null) {
        if (i['code'].toString().trim().toLowerCase() == 'stripe') {
          secretKeyStripe = i['parameters']['secret_key'];
          publishableKeyStripe = i['parameters']['publishable_key'];
        } else if (i['code'].toString().trim().toLowerCase() == 'razorpay') {
          razorPayKey = i['parameters']['key_id'];
        } else if (i['code'].toString().trim().toLowerCase() == 'monnify') {
          monnifyApiKey = i['parameters']['api_key'];
          monnifyContractCode = i['parameters']['contract_code'];
        } else if (i['code'].toString().trim().toLowerCase() == 'paytm') {
          paytmMid = i['parameters']['MID'];
          paytmMarcentKey = i['parameters']['merchant_key'];
          paytmWebsite = i['parameters']['WEBSITE'];
        } else if (i['code'].toString().trim().toLowerCase() == 'paystack') {
          payStackpublicKey = i['parameters']['public_key'];
        } else if (i['code'].toString().trim().toLowerCase() == 'paypal') {
          paypalClientId = i['parameters']['cleint_id'];
          paypalSecretKey = i['parameters']['secret'];
        } else if (i['code'].toString().trim().toLowerCase() == 'flutterwave') {
          flutterwavePublicKey = i['parameters']['public_key'];
        }
      }
    }
  }

  // STRIPE
  String secretKeyStripe = "";
  String publishableKeyStripe = "";
  // RAZORPAY
  String razorPayKey = "";
  // MONNIFY
  String monnifyApiKey = "";
  String monnifyContractCode = "";
  // PAYTM
  String paytmMid = "";
  String paytmMarcentKey = "";
  String paytmWebsite = "";
  // PAYSTACK
  String payStackpublicKey = '';
  // PAYPAL
  String paypalClientId = "";
  String paypalSecretKey = "";
  // FLUTTERWAVE
  String flutterwavePublicKey = "";

  ///-------------------------Stripe Payment Integration
  dynamic stripePaymentData;
  var stripe = Stripe.instance;

  Future<void> stripeDepositRequest() async {
    try {
      stripePaymentData =
          await stripePaymentCreate(calculateAmount(sendAmount), "USD");
      await stripe.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: stripePaymentData['client_secret'],
          style: Get.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          merchantDisplayName: 'Test',
        ),
      );

      displayPaymentSheet();
    } catch (e, s) {
      if (kDebugMode) {
        print('Payment exception: $e$s');
      }
    }
  }

  Future displayPaymentSheet() async {
    try {
      await stripe.presentPaymentSheet().then((newValue) async {
        onPaymentDone(fields: {
          "trx_id": this.trxId,
        });
        stripePaymentData = null;
      }).onError((error, stackTrace) async {
        if (kDebugMode) {
          print('OnErrorException/DISPLAYPAYMENTSHEET==> $error $stackTrace');
        }
        _isLoading = false;
        Get.dialog(
          AlertDialog(
            content: Container(
              height: 60.h,
              child: Center(
                  child: Text(
                "Payment Cancelled!",
                style: TextStyle(color: AppColors.redColor),
              )),
            ),
          ),
        );
        update();
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('StripeException/DISPLAYPAYMENTSHEET==> $e');
      }
      Get.dialog(
        AlertDialog(
          content: Container(
            height: 60.h,
            child: Center(
                child: Text(
              "Payment Cancelled!",
              style: TextStyle(color: AppColors.redColor),
            )),
          ),
        ),
      );
      await Future.delayed(Duration(seconds: 3));
      Get.back();
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  stripePaymentCreate(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer ' + "${secretKeyStripe}",
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body);
    } catch (err) {
      if (kDebugMode) {
        print('err charging user: ${err.toString()}');
      }
      return {};
    }
  }

  // calculate Amount
  calculateAmount(String amount) {
    final doubVal = double.parse(amount);
    final calculatedAmount = (doubVal.toInt() * 100);
    return calculatedAmount.toString();
  }

  ///----------------------Razor Payment Integration
  Razorpay? razorpay;

  listenRazorPay() {
    razorpay = Razorpay()
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    onPaymentDone(fields: {
      "trx_id": this.trxId,
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
    print(response.error);
    // Handle payment failure
    Get.dialog(AppPaymentFail(errorText: response.message!));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
  }

  Future razorPayPaymentRequest() async {
    final options = {
      // Replace with your actual Razorpay key
      'key': razorPayKey,
      'amount': calculateAmount(sendAmount),
      'name': 'Test',
      'description': 'Test Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      },
      'currency': '$selectedCurrency'
    };

    try {
      razorpay!.open(options);
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  ///-------------------------Monnify Payment Integration
  late Monnify? monnify;
  Future initMonnify() async {
    monnify = await Monnify.initialize(
      applicationMode: ApplicationMode.TEST,
      apiKey: monnifyApiKey,
      contractCode: monnifyContractCode,
    );
  }

  Future<void> makeMonnifyPayment() async {
    final paymentReference = DateTime.now().toIso8601String();

    final transaction = TransactionDetails().copyWith(
      amount: double.parse(sendAmount),
      currencyCode: '$selectedCurrency',
      customerName: 'Customer Name',
      customerEmail: 'custo.mer@email.com',
      paymentReference: paymentReference,
    );

    try {
      var res = await monnify?.initializePayment(transaction: transaction);
      if (res!.transactionStatus == 'SUCCESS') {
        onPaymentDone(fields: {
          "trx_id": this.trxId,
        });
      } else {
        Get.dialog(AppPaymentFail(errorText: "Payment failed!"));
        print("Make Monnify Payment: ${res}");
      }
    } catch (e) {
      // handle exceptions in here.
      print(e);
    }
  }

  ///-------------------------Paytm Payment Integration
  String paytmOrderId = "orderId" + DateTime.now().toIso8601String();
  String paytmTxnToken =
      "txnToken" + DateTime.now().millisecondsSinceEpoch.toString();
  bool isStaging = true; // true = testing; false = production

  bool restrictAppInvoke = false;
  Future makePaytmPayment() async {
    try {
      var response = AllInOneSdk.startTransaction(paytmMid, paytmOrderId,
          sendAmount, paytmTxnToken, "", isStaging, restrictAppInvoke);
      response.then((value) async {
        onPaymentDone(fields: {
          "trx_id": this.trxId,
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          if (kDebugMode) {
            print("OnError: " + onError.toString());
          }
        } else {
          print("Other error occurred!");
        }
      });
    } catch (err) {
      if (kDebugMode) {
        print("Catch Error: " + err.toString());
      }
    }
  }

  ///---------------------------Paystack Payment Integration
  final plugin = PaystackPlugin();

  // init paystack
  Future initPayStack() async {
    if (payStackpublicKey.isNotEmpty) {
      await plugin.initialize(publicKey: payStackpublicKey);
    }
  }

  // show message
  void _showMessage(String message, context, Color? bgColor) {
    final snackBar = SnackBar(
        backgroundColor: bgColor,
        content: Text(
          message,
          style: TextStyle(color: AppColors.whiteColor),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// refer
  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }

// checkout
  payStackchargeCard(context) async {
    var charge = Charge()
      ..amount = double.parse(sendAmount).toInt() *
          100 //the money should be in kobo hence the need to multiply the value by 100
      ..currency = selectedCurrency
      ..reference = _getReference()
      ..putCustomField('custom_id',
          '846gey6w') //to pass extra parameters to be retrieved on the response from Paystack
      ..email = 'example@email.com';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      onPaymentDone(fields: {
        "trx_id": this.trxId,
      });
    } else {
      _showMessage('Payment Failed!', context, AppColors.redColor);
    }
  }

  ///-----------------------------Paypal Payment Integration
  //Paypal checkout
  Future makePaypalPaymentRequest() async {
    Get.to(() => PaypalCheckout(
          sandboxMode: true, // true = test mode; false = production mode
          clientId: paypalClientId,
          secretKey: paypalSecretKey,
          returnURL: "success.snippetcoder.com",
          cancelURL: "success.snippetcoder.com",
          transactions: [
            {
              "amount": {
                "total": '$sendAmount',
                "currency": '$selectedCurrency',
                "details": {
                  "subtotal": '$sendAmount',
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description."
            }
          ],
          note: "PAYMENT_NOTE",
          onSuccess: (Map params) async {
            onPaymentDone(fields: {
              "trx_id": this.trxId,
            });
          },
          onError: (error) {
            print("onError: ${error['message']}");
            Get.back();
            Helpers.showSnackBar(
                title: error['name'],
                msg: error['message'],
                bgColor: AppColors.redColor);
          },
          onCancel: () {
            print('cancelled:');
          },
        ));
  }

  ///-----------------------------Flutter wave Payment Integration
  String flutterwaveTxRef = DateTime.now().toIso8601String();
  Flutterwave? flutterwave;
  Future handleFlutterwavePaymentInitialization(context) async {
    final Customer customer = Customer(
        name: "Flutterwave Developer",
        phoneNumber: "1234566677777",
        email: "customer@customer.com");
    flutterwave = await Flutterwave(
        context: context,
        publicKey: "$flutterwavePublicKey",
        currency: "$selectedCurrency",
        redirectUrl: "add-your-redirect-url-here",
        txRef: "$flutterwaveTxRef",
        amount: sendAmount,
        customer: customer,
        paymentOptions: "ussd, card, barter, payattitude",
        customization: Customization(title: "My Payment"),
        isTestMode: true);
    final ChargeResponse response = await flutterwave!.charge();

    if (response.toJson()['success'] == true) {
      onPaymentDone(fields: {
        "trx_id": this.trxId,
      });
    } else {
      Get.dialog(AppPaymentFail());
      if (kDebugMode) {
        print("Something Went Wrong");
      }
    }
  }
}

// create a model class for dynamic form list of manual payment gateway
class ManualPaymentDynamicFormModel {
  String note;
  String gatewayName;
  String fieldName;
  String fieldLevel;
  String type;
  String validation;

  ManualPaymentDynamicFormModel({
    required this.note,
    required this.gatewayName,
    required this.fieldName,
    required this.fieldLevel,
    required this.type,
    required this.validation,
  });
}
