import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/data/repositories/payout_repo.dart';
import '../data/models/payout_history_model.dart' as p;
import '../data/source/check_status.dart';

class PayoutHistoryController extends GetxController {
  static PayoutHistoryController get to => Get.find<PayoutHistoryController>();
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<p.Payouts> payoutHistoryList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getPayoutHistoryList(
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
    payoutHistoryList.clear();
    transactionIdEditingCtrlr.clear();
    startDateTimeEditingCtrlr.clear();
    endDateTimeEditingCtrlr.clear();
    isSearchTapped = true;
    hasNextPage = true;
    page = 1;
    update();
  }

  Future getPayoutHistoryList(
      {required int page,
      required String transaction_id,
      required String start_date,
      required String end_date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await PayoutRepo.getPayoutHistoryList(
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
        final fetchedData = data['message']['Payout History'];
        if (fetchedData.isNotEmpty) {
          payoutHistoryList
              .addAll(p.PayoutHistoryModel.fromJson(data).message!.payouts!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          payoutHistoryList
              .addAll(p.PayoutHistoryModel.fromJson(data).message!.payouts!);
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
      payoutHistoryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getPayoutHistoryList(
        page: page, transaction_id: '', start_date: '', end_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    payoutHistoryList.clear();
  }
}
