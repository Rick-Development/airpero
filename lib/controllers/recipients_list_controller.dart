import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/data/repositories/money_transfer_repo.dart';
import '../config/app_colors.dart';
import '../data/models/recipients_list_model.dart' as r;
import '../data/models/recipients_list_model2.dart' as r2;
import '../data/repositories/recipients_repo.dart';
import '../data/source/check_status.dart';

class RecipientListController extends GetxController {
  static RecipientListController get to => Get.find<RecipientListController>();
  TextEditingController searchEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // type 0 = myself; type 1 = others
  String type = "all";
  //================================
  // send value from money_transfer_screen1 because MoneyTransferController is deleting and all data is removing
  // that's why seperate these data from that controller
  String sendVal = "";
  String receiveVal = "";

  // these data are initial value and will be displayed in moneyTransfer1 page
  String senderInitialSelectedId = "0";
  String senderInitialSelectedCurrency = "";
  String senderInitialSelectedRate = "0.00";

  String receiverInitialSelectedId = "0";
  String receiverInitialSelectedCurrency = "";
  String receiverInitialSelectedRate = "0.00";

  String transferFee = "0.00";

  String minAmount = "0.00";
  String maxAmount = "0.00";
  String minTransferFees = "0.00";
  String maxTransferFees = "0.00";
  String currency = "";

  // for searching selected country's recipient
  String selectedCountry = "";
  bool isFromMoneyTransferPage = false;

  //==================================
  // filter the list for showing myself, others recipient list in recipient_screen
  List<r.Recipient> filteredList = [];
  List<r.Recipient> recipientList = [];
  List<r2.User> recipientList2 = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getRecipientList(
          page: page, search: searchEditingCtrlr.text, isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    recipientList.clear();
    recipientList2.clear();
    isSearchTapped = true;
    hasNextPage = true;
    page = 1;
    update();
  }

  Future getRecipientList({
    required int page,
    required String search,
    bool? isLoadMoreRunning = false,
    bool? isFromUserTable = false,
  }) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = isFromMoneyTransferPage == false
        ? await RecipientsRepo.getRecipientsList(page: page, search: search)
        : await MoneyTransferRepo.getTransferRecipient(
            countryName: selectedCountry, search: search, page: page);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final fetchedData = isFromUserTable == true
            ? data['message']['users']
            : data['message']['recipients'];
        if (fetchedData != null) if (fetchedData.isNotEmpty) {
          if (isFromUserTable == true) {
            recipientList2 = [
              ...recipientList2,
              ...r2.RecipientListModel2.fromJson(data).message!.users!
            ];
          } else {
            recipientList2 = [];
            recipientList = [
              ...recipientList,
              ...r.RecipientListModel.fromJson(data).message!.recipients!
            ];
          }

          if (isFromMoneyTransferPage == true) {
            recipientList = recipientList.reversed.toList();
          }

          // filter the list for showing myself, others recipient list in recipient_screen
          filteredList =
              await recipientList.where((e) => e.type == type).toList();
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          searchEditingCtrlr.clear();
          if (isFromUserTable == true) {
            recipientList2 = [
              ...recipientList2,
              ...r2.RecipientListModel2.fromJson(data).message!.users!
            ];
          } else {
            recipientList2 = [];
            recipientList = [
              ...recipientList,
              ...r.RecipientListModel.fromJson(data).message!.recipients!
            ];
          }
          if (isFromMoneyTransferPage == true) {
            recipientList = recipientList.reversed.toList();
          }
          filteredList =
              await recipientList.where((e) => e.type == type).toList();
          hasNextPage = false;
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          if (kDebugMode) {
            print("================isDataEmpty: true");
          }

          update();
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      recipientList = [];
    }
  }

  dynamic pickRandomColor(data, {bool? isFromRecipientList2 = false}) {
    if (isFromRecipientList2 == true) {
      if (data.firstname[0].toString().toUpperCase() == "A" ||
          data.firstname[0].toString().toUpperCase() == "M" ||
          data.firstname[0].toString().toUpperCase() == "J") {
        return AppColors.random1;
      } else if (data.firstname[0].toString().toUpperCase() == "B" ||
          data.firstname[0].toString().toUpperCase() == "R" ||
          data.firstname[0].toString().toUpperCase() == "S") {
        return AppColors.random2;
      } else if (data.firstname[0].toString().toUpperCase() == "C" ||
          data.firstname[0].toString().toUpperCase() == "D" ||
          data.firstname[0].toString().toUpperCase() == "X") {
        return AppColors.random3;
      } else if (data.firstname[0].toString().toUpperCase() == "F" ||
          data.firstname[0].toString().toUpperCase() == "G") {
        return AppColors.random4;
      } else if (data.firstname[0].toString().toUpperCase() == "L" ||
          data.firstname[0].toString().toUpperCase() == "M" ||
          data.firstname[0].toString().toUpperCase() == "N") {
        return AppColors.random5;
      } else if (data.firstname[0].toString().toUpperCase() == "O" ||
          data.firstname[0].toString().toUpperCase() == "P" ||
          data.firstname[0].toString().toUpperCase() == "Q") {
        return AppColors.random6;
      } else if (data.firstname[0].toString().toUpperCase() == "R" ||
          data.firstname[0].toString().toUpperCase() == "S" ||
          data.firstname[0].toString().toUpperCase() == "T") {
        return AppColors.random7;
      } else if (data.firstname[0].toString().toUpperCase() == "U" ||
          data.firstname[0].toString().toUpperCase() == "V" ||
          data.firstname[0].toString().toUpperCase() == "W") {
        return AppColors.random8;
      } else if (data.firstname[0].toString().toUpperCase() == "Z" ||
          data.firstname[0].toString().toUpperCase() == "H" ||
          data.firstname[0].toString().toUpperCase() == "X") {
        return AppColors.random9;
      } else {
        return AppColors.random10;
      }
    } else {
      if (data.name[0].toString().toUpperCase() == "A" ||
          data.name[0].toString().toUpperCase() == "M" ||
          data.name[0].toString().toUpperCase() == "J") {
        return AppColors.random1;
      } else if (data.name[0].toString().toUpperCase() == "B" ||
          data.name[0].toString().toUpperCase() == "R" ||
          data.name[0].toString().toUpperCase() == "S") {
        return AppColors.random2;
      } else if (data.name[0].toString().toUpperCase() == "C" ||
          data.name[0].toString().toUpperCase() == "D" ||
          data.name[0].toString().toUpperCase() == "X") {
        return AppColors.random3;
      } else if (data.name[0].toString().toUpperCase() == "F" ||
          data.name[0].toString().toUpperCase() == "G") {
        return AppColors.random4;
      } else if (data.name[0].toString().toUpperCase() == "L" ||
          data.name[0].toString().toUpperCase() == "M" ||
          data.name[0].toString().toUpperCase() == "N") {
        return AppColors.random5;
      } else if (data.name[0].toString().toUpperCase() == "O" ||
          data.name[0].toString().toUpperCase() == "P" ||
          data.name[0].toString().toUpperCase() == "Q") {
        return AppColors.random6;
      } else if (data.name[0].toString().toUpperCase() == "R" ||
          data.name[0].toString().toUpperCase() == "S" ||
          data.name[0].toString().toUpperCase() == "T") {
        return AppColors.random7;
      } else if (data.name[0].toString().toUpperCase() == "U" ||
          data.name[0].toString().toUpperCase() == "V" ||
          data.name[0].toString().toUpperCase() == "W") {
        return AppColors.random8;
      } else if (data.name[0].toString().toUpperCase() == "Z" ||
          data.name[0].toString().toUpperCase() == "H" ||
          data.name[0].toString().toUpperCase() == "X") {
        return AppColors.random9;
      } else {
        return AppColors.random10;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRecipientList(page: page, search: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    recipientList.clear();
  }
}
