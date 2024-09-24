import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/controllers/bindings/controller_index.dart';
import '../data/models/money_transfer_currency_model.dart' as m;
import '../data/models/transfer_details_model.dart' as t;
import '../data/repositories/money_transfer_repo.dart';
import '../data/source/check_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/localstorage/hive.dart';
import '../utils/services/localstorage/keys.dart';

class MoneyTransferController extends GetxController {
  static MoneyTransferController get to => Get.find<MoneyTransferController>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isTappedOnQuestionMark1 = false;
  bool isTappedOnQuestionMark2 = false;

  TextEditingController sendCtrl = TextEditingController();
  TextEditingController receiveCtrl = TextEditingController();
  String sendVal = "";
  String receiveVal = "";

  // these data will be displayed in moneyTransfer1 page
  String transferFee = "0.00";
  String transferFeeInLocal = "0.00";
  String amountWillConvert = "0.00";

  // these data are initial value and will be displayed in moneyTransfer1 page
  String senderInitialSelectedId = "0";
  String senderInitialSelectedCountryImage = "";
  String senderInitialSelectedCurrency = "";
  String senderInitialSelectedRate = "0.00";

  String receiverInitialSelectedId = "0";
  String receiverInitialSelectedCountryImage = "";
  String receiverInitialSelectedCurrency = "";
  String receiverInitialSelectedRate = "0.00";

  // if the transfer user is waiz user
  dynamic r_user_id = "";

  // get the countryName for getting the recipient list base on this countryName
  String countryName = "";
  bool isFromMoneyTransferPage = false;

  List<m.SenderCurrency> senderCurrencyList = [];
  List<m.SenderCurrency> receiverCurrencyList = [];
  String minAmount = "0.00";
  String maxAmount = "0.00";
  String minTransferFees = "0.00";
  String maxTransferFees = "0.00";
  String currency = "";
  Future getTransferCurrencies({bool? isFromRefreshIndicator = false}) async {
    if (isFromRefreshIndicator == false) {
      _isLoading = true;
    }

    update();
    http.Response response = await MoneyTransferRepo.getTransferCurrencies();
    senderCurrencyList = [];
    receiverCurrencyList = [];
    if (isFromRefreshIndicator == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        minAmount = data['message']['limitations']['minimum_amount'].toString();
        RecipientListController.to.minAmount =
            data['message']['limitations']['minimum_amount'].toString();
        maxAmount = data['message']['limitations']['maximum_amount'].toString();
        RecipientListController.to.maxAmount =
            data['message']['limitations']['maximum_amount'].toString();
        minTransferFees =
            data['message']['limitations']['minimum_transfer_fee'].toString();
        RecipientListController.to.minTransferFees =
            data['message']['limitations']['minimum_transfer_fee'].toString();
        transferFee = minTransferFees;
        RecipientListController.to.transferFee = minTransferFees;
        maxTransferFees =
            data['message']['limitations']['maximum_transfer_fee'].toString();
        RecipientListController.to.maxTransferFees =
            data['message']['limitations']['maximum_transfer_fee'].toString();
        currency = data['message']['limitations']['currency'].toString();
        RecipientListController.to.currency =
            data['message']['limitations']['currency'].toString();
        senderCurrencyList.addAll(m.MoneyTransferCurrencyModel.fromJson(data)
            .message!
            .senderCurrencies!);
        receiverCurrencyList.addAll(m.MoneyTransferCurrencyModel.fromJson(data)
            .message!
            .receiverCurrencies!);
        if (senderCurrencyList.isNotEmpty) {
          senderInitialSelectedId = senderCurrencyList[0].id.toString();
          senderInitialSelectedCountryImage =
              senderCurrencyList[0].countryImage;
          senderInitialSelectedCurrency = senderCurrencyList[0].currencyCode;
          senderCurrency = senderCurrencyList[0].currencyCode;
          senderInitialSelectedRate = senderCurrencyList[0].rate;

          RecipientListController.to.senderInitialSelectedId =
              senderCurrencyList[0].id.toString();
          RecipientListController.to.senderInitialSelectedCurrency =
              senderCurrencyList[0].currencyCode;
          RecipientListController.to.senderInitialSelectedRate =
              senderCurrencyList[0].rate;
        }
        if (receiverCurrencyList.isNotEmpty) {
          receiverInitialSelectedId = receiverCurrencyList.last.id.toString();
          receiverInitialSelectedCountryImage =
              receiverCurrencyList.last.countryImage;
          receiverInitialSelectedCurrency =
              receiverCurrencyList.last.currencyCode;
          receiverInitialSelectedRate = receiverCurrencyList.last.rate;
          countryName = receiverCurrencyList.last.countryName;
          RecipientListController.to.selectedCountry =
              receiverCurrencyList.last.countryName;

          RecipientListController.to.receiverInitialSelectedId =
              receiverCurrencyList.last.id.toString();
          RecipientListController.to.receiverInitialSelectedCurrency =
              receiverCurrencyList.last.currencyCode;
          RecipientListController.to.receiverInitialSelectedRate =
              receiverCurrencyList.last.rate;
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      senderCurrencyList = [];
      receiverCurrencyList = [];
      update();
    }
  }

  onChanged(value) {
    if (value.toString().startsWith(".")) {
      return;
    }
    sendVal = value;
    RecipientListController.to.sendVal = sendVal;
    calculateSenderAmount();
    update();
  }

  // this value is for validation
  double sendAmountInSelectedCurr = 0.00;

  // transfer fee, transfer fee in local, converted amount
  double getConvertedRate = 0.00;
  Future calculateSenderAmount() async {
    // send amount in selected currency based on usd
    sendAmountInSelectedCurr =
        (double.parse(senderInitialSelectedRate) * 15).toDouble();
    update();
    if (sendVal.isNotEmpty) {
      // get fees
      // transfer fee
      if (sendAmountInSelectedCurr.toInt() >= 3000 &&
          sendAmountInSelectedCurr.toInt() < 10000) {
        transferFee =
            await (double.parse(minTransferFees) * 2).toStringAsFixed(2);
        update();
      } else if (sendAmountInSelectedCurr.toInt() >= 10000) {
        transferFee = await double.parse(maxTransferFees).toStringAsFixed(2);
        update();
      } else {
        transferFee = minTransferFees;
      }

      // transfer fee in local
      transferFeeInLocal = await (double.parse(transferFee) *
              double.parse(senderInitialSelectedRate))
          .toStringAsFixed(2);

      // total amount we will convert
      getConvertedRate = await double.parse(receiverInitialSelectedRate) /
          double.parse(senderInitialSelectedRate);
      double calculatedAmount =
          await double.parse(sendVal) - double.parse(transferFeeInLocal);
      amountWillConvert =
          await (calculatedAmount * getConvertedRate).toStringAsFixed(2);
      // recipients gets
      receiveCtrl.text =
          (getConvertedRate * double.parse(sendVal)).toStringAsFixed(2);
      receiveVal =
          (getConvertedRate * double.parse(sendVal)).toStringAsFixed(2);
      update();
    } else if (sendVal.isEmpty) {
      transferFee = minTransferFees;
      transferFeeInLocal = "0.00";
      amountWillConvert = "0.00";
      sendVal = "";
      receiveCtrl.text = "";
      receiveVal = "";
      update();
    }
  }

  void reverseCalculateReceiverAmount() {
    if (receiveVal.isNotEmpty) {
      if (sendVal.isNotEmpty) {
        // transfer fee
        if (sendAmountInSelectedCurr.toInt() >= 3000 &&
            sendAmountInSelectedCurr.toInt() < 10000) {
          transferFee = (double.parse(minTransferFees) * 2).toStringAsFixed(2);
          update();
        } else if (sendAmountInSelectedCurr.toInt() >= 10000) {
          transferFee = double.parse(maxTransferFees).toStringAsFixed(2);
          update();
        } else {
          transferFee = minTransferFees;
        }

        // transfer fee in local
        transferFeeInLocal = (double.parse(transferFee) *
                double.parse(senderInitialSelectedRate))
            .toStringAsFixed(2);
      }

      // Calculate the amount that was converted back from the recipient gets value
      double getConvertedRate = double.parse(receiverInitialSelectedRate) /
          double.parse(senderInitialSelectedRate);

      // send amount
      double convertedAmount = double.parse(receiveVal);
      // Adjust for any transfer fees that were deducted during the initial calculation
      double originalAmount = convertedAmount / getConvertedRate;
      // Update the senderCtrl textfield with the recalculated sender's original amount
      sendCtrl.text = originalAmount.toStringAsFixed(2);
      sendVal = originalAmount.toStringAsFixed(2);
      RecipientListController.to.sendVal = sendVal;

      // total amount we will convert
      double calculatedAmount =
          double.parse(sendVal) - double.parse(transferFeeInLocal);
      amountWillConvert =
          (calculatedAmount * getConvertedRate).toStringAsFixed(2);
      update();
    } else if (receiveVal.isEmpty) {
      // Reset senderCtrl textfield if receiverCtrl is empty
      transferFee = minTransferFees;
      transferFeeInLocal = "0.00";
      amountWillConvert = "0.00";
      sendCtrl.text = "";
      sendVal = "";
      update();
    }
  }

  String name = "";
  String email = "";
  String bank_name = "";
  String service_name = "";
  dynamic service_id = 0;
  dynamic recipientId = 0;
  Future getTransferReview({required String uuid}) async {
    _isLoading = true;
    update();
    http.Response response =
        await MoneyTransferRepo.getTransferReview(uuid: uuid);
    senderCurrencyList = [];
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        recipientId = data['message']['transferReview']['id'];
        name = data['message']['transferReview']['Recipients details']['name']
            .toString();
        email = data['message']['transferReview']['Recipients details']['email']
            .toString();
        bank_name = data['message']['transferReview']['Recipients details']
                ['bank_name']
            .toString();
        service_name = data['message']['transferReview']['Recipients details']
                ['service_name']
            .toString();
        service_id = data['message']['transferReview']['Recipients details']
            ['service_id'];
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      receiverCurrencyList = [];
      update();
    }
  }

  bool isPaymentStore = false;
  String transferStore_trxId = "";
  Future transferPaymentStore({Map<String, dynamic>? fields}) async {
    isPaymentStore = true;
    update();
    http.Response response =
        await MoneyTransferRepo.transferPaymentStore(fields: fields);
    isPaymentStore = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      if (data['status'] == 'success') {
        transferStore_trxId = data['message'].toString();
        Get.toNamed(RoutesName.moneyTransferScreen4);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
      update();
    }
  }

  Future transferPost(
      {Map<String, dynamic>? fields, required BuildContext context}) async {
    Get.find<AddFundController>().isLoadingPaymentSheet = true;
    update();
    http.Response response =
        await MoneyTransferRepo.transferPost(fields: fields);
    Get.find<AddFundController>().isLoadingPaymentSheet = false;
    update();

    if (response.statusCode == 200) {
      print(response.body);
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // if the payment type is wallet
        if (AddFundController.to.isPaymentTypeIsWallet) {
          Get.offAllNamed(RoutesName.paymentSuccessScreen);
        }
        // if the payment type is other
        else {
          Get.find<AddFundController>().trxId = data['message'].toString();
          await Get.find<AddFundController>().onBuyNowTapped(context: context);
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
      update();
    }
  }

  // when transfert history status will be initiate
  // these data will be showed in the moneyTransferPage4 as transfer details
  String send_amount = "0.00";
  String transfer_fee = "0.00";
  String send_total = "0.00";
  String receiver_amount = "0.00";
  String serviceName = "";
  String senderCurrency = "";

  bool isTransferPayLoading = false;
  Future getTransferPay({required String uuid}) async {
    isTransferPayLoading = true;
    update();
    http.Response response = await MoneyTransferRepo.transferPay(uuid: uuid);
    isTransferPayLoading = false;
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        send_amount = data['message']['payDetails']['send_amount'] ?? "0.00";
        transfer_fee = data['message']['payDetails']['transfer_fee'] ?? "0.00";
        send_total = data['message']['payDetails']['send_total'] ?? "0.00";
        receiver_amount =
            data['message']['payDetails']['receiver_amount'] ?? "0.00";
        serviceName = data['message']['payDetails']['service_name'] ?? "";
        senderCurrency = data['message']['payDetails']['senderCurrency'] ?? "";
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      receiverCurrencyList = [];
      update();
    }
  }

  t.TransferDetailsClass? transferDetails;
  List<BankInfo> bankInfoList = [];
  String capitalize(String s) {
    return s.substring(0, 1).toUpperCase() + s.substring(1);
  }

  String convertToTitleCase(String input) {
    List<String> words = input.split('_');
    List<String> capitalizedWords =
        words.map((word) => capitalize(word)).toList();
    return capitalizedWords.join(' ');
  }

  Future getTransferDetails({required String uuid}) async {
    isTransferPayLoading = true;
    update();
    http.Response response =
        await MoneyTransferRepo.transferDetails(uuid: uuid);
    isTransferPayLoading = false;
    bankInfoList = [];
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        transferDetails =
            t.TransferDetails.fromJson(data).message!.transferDetails!;
        if (data['message']['transferDetails'] != null &&
            data['message']['transferDetails']['recipient_details'] != null &&
            data['message']['transferDetails']['recipient_details']
                    ['bank_info'] !=
                null &&
            data['message']['transferDetails']['recipient_details']['bank_info']
                is Map) {
          Map<String, dynamic> map = data['message']['transferDetails']
              ['recipient_details']['bank_info'];
          for (var i in map.entries) {
            bankInfoList.add(
                BankInfo(key: convertToTitleCase(i.key), value: i.value ?? ""));
          }
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
      update();
    }
  }

  double getRate = 0.00;
  bool isGettingRate = false;
  String amountInSelectedCurr = "0.00";
  String payable = "0.00";
  String payableAmountInBaseCurr = "0.00";
  Future getCurrencyRate({Map<String, dynamic>? fields}) async {
    isGettingRate = true;
    update();
    http.Response response =
        await MoneyTransferRepo.getCurrencyRate(fields: fields);
    isGettingRate = false;
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        getRate = double.parse(data['message']['rate'].toString());
        amountInSelectedCurr = (getRate *
                double.parse(send_amount.replaceAll(RegExp(r'[^0-9.]'), '')))
            .toStringAsFixed(2);
        AddFundController.to.sendAmount =
            amountInSelectedCurr; // for sending with sdk payment gateway (stripe, flutterwave etc.)
        payable = (double.parse(amountInSelectedCurr) +
                double.parse(AddFundController.to.charge))
            .toStringAsFixed(2);
        payableAmountInBaseCurr = (double.parse(payable) /
                double.parse(AddFundController.to.conversion_rate))
            .toStringAsFixed(2);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong! n\: $fields");
    }
  }

  // GET WALLET CONFIRMATION OTP
  bool isSendingOTP = false;
  Future getTransferOtp({required String option}) async {
    isSendingOTP = true;
    update();
    http.Response response =
        await MoneyTransferRepo.getTransferOtp(option: option);
    isSendingOTP = false;
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.toNamed(RoutesName.walletPaymentConfirmScreen);
        update();
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
    }
  }

  Future transferOtp({Map<String, dynamic>? fields}) async {
    _isLoading = true;
    update();
    http.Response response =
        await MoneyTransferRepo.transferOtp(fields: fields);
    _isLoading = false;
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        if (WalletController.to.isFromWalletExchangePage == true) {
          await WalletController.to.moneyExchange(fields: {
            "senderWalletId": WalletController.to.senderWalletId,
            "receiverWalletId": WalletController.to.receiverWalletId,
            "sendAmount": WalletController.to.textEditingController1.text,
            "receiveAmount": WalletController.to.textEditingController2.text,
          });
        } else {
          Get.toNamed(RoutesName.moneyTransferScreen5);
        }

        update();
      } else {
        pin1.clear();
        pin2.clear();
        pin3.clear();
        pin4.clear();
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong! n\: $fields");
    }
  }

  resetMoneyTransferData() {
    sendCtrl.clear();
    receiveCtrl.clear();
    transferFee = "0.00";
    transferFeeInLocal = "0.00";
    amountWillConvert = "0.00";
  }

  ///COUNT DOWN TIMER
  int counter = 60;
  late Timer timer;
  bool isStartTimer = false;
  Duration duration = const Duration(seconds: 1);

  void startTimer() {
    timer = Timer.periodic(duration, (timer) {
      if (counter > 0) {
        counter -= 1;
        isStartTimer = true;
        update();
      } else {
        timer.cancel();
        counter = 60;
        isStartTimer = false;
        update();
      }
    });
  }

  // MUSK PHONE NUMBER AND EMAIL OF USER
  String userPhoneNumber = "";
  void maskPhone() {
    if (HiveHelp.read(Keys.userPhone).toString().isNotEmpty) {
      if (HiveHelp.read(Keys.userPhone).toString().length >= 5) {
        userPhoneNumber =
            "${HiveHelp.read(Keys.userPhone).toString().substring(0, 3)}******${HiveHelp.read(Keys.userPhone).toString().substring(HiveHelp.read(Keys.userPhone).toString().length - 2)}";
      } else if (HiveHelp.read(Keys.userPhone).toString().length >= 4) {
        "${HiveHelp.read(Keys.userPhone).toString().substring(0, 2)}******${HiveHelp.read(Keys.userPhone).toString().substring(HiveHelp.read(Keys.userPhone).toString().length - 2)}";
      } else if (HiveHelp.read(Keys.userPhone).toString().length >= 3) {
        "${HiveHelp.read(Keys.userPhone).toString().substring(0, 1)}******${HiveHelp.read(Keys.userPhone).toString().substring(HiveHelp.read(Keys.userPhone).toString().length - 1)}";
      } else {
        "${HiveHelp.read(Keys.userPhone).toString().substring(0, 1)}******";
      }
    }
  }

  String userEmail = "";
  void maskEmail() {
    if (HiveHelp.read(Keys.userEmail).toString().isNotEmpty &&
        HiveHelp.read(Keys.userEmail).toString().contains("@")) {
      String firstPart =
          HiveHelp.read(Keys.userEmail).toString().split("@").first;
      String lastPart =
          HiveHelp.read(Keys.userEmail).toString().split("@").last;
      if (firstPart.length >= 4) {
        userEmail =
            "${firstPart.substring(0, 2)}****${firstPart.substring(firstPart.length - 2)}@$lastPart";
      } else if (HiveHelp.read(Keys.userPhone).toString().length >= 3) {
        userEmail =
            "${firstPart.substring(0, 1)}****${firstPart.substring(firstPart.length - 1)}@$lastPart";
      } else {
        userEmail = "${firstPart.substring(0, 1)}****@$lastPart";
      }
    }
  }

  //--------------- WALLET CONFIRMATION
  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();

  String selectedOption = "";
}

class BankInfo {
  String key;
  String value;
  BankInfo({required this.key, required this.value});
}
