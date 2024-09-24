import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/transaction_model.dart' as t;
import '../data/repositories/transaction_repo.dart';
import '../data/source/check_status.dart';

class TransactionController extends GetxController {
  bool? isFromWallet;
  TransactionController({this.isFromWallet = false});
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<t.Transactions> transactionList = [];
  List<DateTimeCategoriesTransaction> dateTimeCategoriestransactionList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getTransactionList(
          isFromWallet: isFromWallet,
          page: page,
          transaction_id: transactionIdEditingCtrlr.text,
          start_date: startDateTimeEditingCtrlr.text,
          end_date: endDateTimeEditingCtrlr.text,
          isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    transactionList.clear();
    page = 1;
    isSearchTapped = true;
    hasNextPage = true;
    update();
  }

  Future getTransactionList(
      {required int page,
      required String transaction_id,
      required String start_date,
      required String end_date,
      bool? isFromWallet = false,
      String? uuid,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await TransactionRepo.getTransactionList(
        isFromWallet: isFromWallet,
        uuid: uuid,
        page: page,
        transaction_id: transaction_id,
        start_date: start_date,
        end_date: end_date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['transactions'];
        if (fetchedData.isNotEmpty) {
          transactionList = [
            ...transactionList,
            ...t.TransactionModel.fromJson(data).message!.transactions!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          transactionList = [
            ...transactionList,
            ...t.TransactionModel.fromJson(data).message!.transactions!
          ];
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
      transactionList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTransactionList(
        isFromWallet: isFromWallet,
        page: page,
        transaction_id: '',
        start_date: '',
        end_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    transactionList.clear();
  }
}

class DateTimeCategoriesTransaction {
  String dateTime;
  List<t.Transactions> transactions;
  DateTimeCategoriesTransaction({
    required this.dateTime,
    required this.transactions,
  });
}
