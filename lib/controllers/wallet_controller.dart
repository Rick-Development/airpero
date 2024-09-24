import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/screens/success/payment_success_screen.dart';
import '../data/models/dashboard_model.dart' as d;
import '../data/repositories/wallet_repo.dart';
import '../data/source/check_status.dart';

class WalletController extends GetxController {
  static WalletController get to => Get.find<WalletController>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isFromWalletExchangePage = false;

  // for showing as accounts in home page
  List<d.Wallet> walletList = [];
  // filtered list for showing in add new wallet section
  List<d.Currency> currencyList = [];
  // for showing in the card
  List<String> countryCurrencyList = [];
  List<String> countryImageList = [];
  // for showing in the money transfer payment, add fund, payout page
  List<WalletData> walletDataList = [];

  Future getWallets() async {
    _isLoading = true;
    update();
    http.Response response = await WalletRepo.getWallets();
    _isLoading = false;
    walletList = [];
    currencyList = [];
    countryCurrencyList = [];
    countryImageList = [];
    walletDataList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        walletList = [
          ...walletList,
          ...d.DashboardModel.fromJson(data).message!.wallets!
        ];
        currencyList = [
          ...currencyList,
          ...d.DashboardModel.fromJson(data).message!.currency!
        ];

        // filtered the currency code and get the countryName
        if (walletList.isNotEmpty && currencyList.isNotEmpty) {
          // will be showed these data in the add new wallet section
          if (currencyList[0].country != null) {
            selectedCountryFlug = currencyList[0].country!.image;
          }
          selectedCountryCode = currencyList[0].code;
          selectedCountryAndCurr =
              currencyList[0].code + " - " + currencyList[0].name;
          // for showing in the card page
          for (var i in walletList) {
            List<d.Currency> list =
                currencyList.where((e) => e.code == i.currencyCode).toList();
            if (list.isNotEmpty) {
              for (var i in list) {
                countryCurrencyList.add(i.name);
                countryImageList.add(i.country!.image);
              }
            }
          }

          // for showing in the money transfer payment, add fund, payout page
          // get the country code and country name from currency list and get the ID from wallet list based on countryCode and name.
          // Example: {"id": 1, "name": "BDT - Bangladesh"}
          for (var i in currencyList) {
            List<d.Wallet> list =
                walletList.where((e) => e.currencyCode == i.code).toList();
            for (var j in list) {
              if (i.code == j.currencyCode) {
                if (j.currencyRate != null) {
                  walletDataList.add(WalletData(
                      id: j.id.toString(),
                      currencyAndCountryName: i.code + " - " + i.country!.name,
                      rate: j.currencyRate!.rate));

                  // get the first item of walletDataList for showing in payout page, addFund page
                  if (walletDataList.isNotEmpty) {
                    PayoutController.to.wallet_id =
                        walletDataList[0].id.toString();
                    PayoutController.to.selectedWallet =
                        walletDataList[0].currencyAndCountryName;

                    AddFundController.to.wallet_id =
                        walletDataList[0].id.toString();
                    AddFundController.to.selectedWallet =
                        walletDataList[0].currencyAndCountryName;
                  }
                }
              }
            }
          }
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!!!");
      walletList = [];
      currencyList = [];
      update();
    }
  }

  bool isCreatingWallet = false;
  Future walletStore(
      {required String currency_code, required BuildContext context}) async {
    isCreatingWallet = true;
    update();
    http.Response response =
        await WalletRepo.walletStore(currency_code: currency_code);
    isCreatingWallet = false;
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Navigator.pop(context);
        getWallets();
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!!!");
      update();
    }
  }

  Future defaultWallet({required String id}) async {
    update();
    http.Response response = await WalletRepo.defaultWallet(id: id);
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        getWallets();
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!!!");
      update();
    }
  }

  Future moneyExchange({required Map<String, dynamic>? fields}) async {
    _isLoading = true;
    update();
    http.Response response = await WalletRepo.moneyExchange(fields: fields);
    _isLoading = false;
    update();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        Get.to(() => PaymentSuccessScreen(
              isFromWalletExchangePage: true,
              exchangeAmount:
                  textEditingController1.text.toString() + " $walletCurrency",
              receiveAmount: textEditingController2.text.toString() +
                  " $selectedWalletCurr",
            ));
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!!!");
      update();
    }
  }

  // for showing in the add new wallet section
  String selectedCountryFlug = "";
  String selectedCountryCode = "";
  var selectedCountryAndCurr;

  String walletUUID = "";

  // wallet exchange page
  String senderWalletId = "";
  String receiverWalletId = "";
  String walletBalance = "";
  String walletCurrency = "";
  String walletCountryImage = "";
  var selectedWalletCurr;
  String selectedWalletCurrCountryImage = "";
  List<d.Wallet> walletCurrencyList = [];
  List filteredImageList = [];

  Future getWalletExchData(d.Wallet data, i) async {
    senderWalletId = data.id.toString();
    walletBalance = data.balance == null || data.balance == ""
        ? "0.00"
        : data.balance.toString();
    walletCurrency = data.currencyCode.toString();
    walletCountryImage = countryImageList[i];
    sendCurrRate = data.currencyRate == null ? "0.00" : data.currencyRate!.rate;
    walletCurrencyList = [...walletList];
    filteredImageList = [...countryImageList];

    // for showing image in wallet exchange page
    int indexToRemove = walletCurrencyList
        .indexWhere((e) => e.currencyCode == data.currencyCode);
    if (indexToRemove != -1) {
      filteredImageList.removeAt(indexToRemove);
    }

    walletCurrencyList.removeWhere((e) => data.currencyCode == e.currencyCode);

    if (walletCurrencyList.isNotEmpty) {
      selectedWalletCurrCountryImage =
          filteredImageList.isNotEmpty ? filteredImageList[0] : "";
      selectedWalletCurr = walletCurrencyList[0].currencyCode ?? "";
      receiverWalletId = walletCurrencyList[0].id.toString();

      // for calculating the exchange currency
      receiveCurrRate = walletCurrencyList[0].currencyRate == null
          ? "0.00"
          : walletCurrencyList[0].currencyRate!.rate.toString();
    }
    update();
  }

  receiveDropDownOnchange(v) {
    // select the country image based on walletCurrencyList's selected index
    selectedWalletCurrCountryImage = filteredImageList[
        walletCurrencyList.indexWhere((e) => e.currencyCode == v)];

    selectedWalletCurr = v;
    var selectedWallet =
        walletCurrencyList.firstWhere((e) => e.currencyCode == v);
    // for sending this value in the wallet exchange api
    receiverWalletId = selectedWallet.id.toString();
    // for calculating the exchange currency
    receiveCurrRate = selectedWallet.currencyRate == null
        ? "0.00"
        : selectedWallet.currencyRate!.rate.toString();

    // make calculate
    getExchangeAmount(textEditingController1.text);

    update();
  }

  // for calculating the exchange currency
  String receiveCurrRate = "0.00";
  String sendCurrRate = "0.00";

  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  String revceiveWalletAmount = "0.00";
  var textEditingCtrl1Val = "0.00";
  // exchange money
  getExchangeAmount(dynamic v) {
    if (v.toString().isNotEmpty) {
      textEditingCtrl1Val = v;
      revceiveWalletAmount =
          ((double.parse(receiveCurrRate) / double.parse(sendCurrRate)) *
                  double.parse(v.toString()))
              .toStringAsFixed(2);
      textEditingController2.text = revceiveWalletAmount;
    } else {
      textEditingCtrl1Val = "0.00";
      textEditingController2.clear();
    }
    update();
  }

  // reversed exchange money
  getReversedExchangeAmount(dynamic v) {
    if (v.toString().isNotEmpty) {
      textEditingController1.text =
          ((double.parse(sendCurrRate) / double.parse(receiveCurrRate)) *
                  double.parse(v.toString()))
              .toStringAsFixed(2);
      textEditingCtrl1Val = textEditingController1.text;
    } else {
      textEditingCtrl1Val = "0.00";
      textEditingController1.clear();
    }
    update();
  }

  @override
  void onInit() {
    getWallets();
    super.onInit();
  }
}

class WalletData {
  final String id;
  final String currencyAndCountryName;
  final String rate;
  WalletData(
      {required this.id,
      required this.currencyAndCountryName,
      required this.rate});
}
