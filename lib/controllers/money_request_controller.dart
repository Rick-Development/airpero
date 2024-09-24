import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import '../data/models/money_request_wallet_model.dart' as r;
import '../data/repositories/money_request_repo.dart';
import '../data/source/check_status.dart';
import '../views/screens/money_request/money_request_history_screen.dart';

class MoneyRequestController extends GetxController {
  static MoneyRequestController get to => Get.find<MoneyRequestController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<r.Wallet> walletList = [];

  Future getMoneyRequestWallet({required String uuid}) async {
    _isLoading = true;
    update();
    http.Response response = await MoneyRequestRepo.getWallets(uuid: uuid);
    _isLoading = false;
    walletList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        walletList = [
          ...walletList,
          ...r.MoneyRequestWalletModel.fromJson(data).message!.wallets!
        ];
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      walletList = [];
    }
  }

  String walletId = "";
  String recipientId = "";
  bool isRequestingMoney = false;
  Future moneyRequest({required Map<String, dynamic> fields}) async {
    isRequestingMoney = true;
    update();
    http.Response response =
        await MoneyRequestRepo.moneyRequest(fields: fields);
    isRequestingMoney = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.to(() => MoneyRequestHistoryScreen(isFromMoneyRequestPage: true));
      }
    } else {
      Helpers.showSnackBar(msg: "Something went wrong!");
    }
  }



  var selectedWalletCurr;
  String selectedWalletCurrCountryImage = "";
  onCurrencyChanged(v) {
    selectedWalletCurr = v;
    // for showing currency's country image in money request page
    selectedWalletCurrCountryImage = WalletController.to.countryImageList[
        WalletController.to.walletList
            .map((e) => e.currencyCode)
            .toList()
            .indexOf(v.toString().split(" ").first)];
    // for requesting money with money request api
    walletId = walletList
        .firstWhere((e) =>
            e.currencyCode.toString() + " - " + e.currency!.name.toString() ==
            v.toString())
        .uuid
        .toString();
    update();
  }

  TextEditingController amountCtrl = TextEditingController();
}
