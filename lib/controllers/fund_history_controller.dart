import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/data/repositories/add_fund_repo.dart';
import '../data/models/fund_history_model.dart' as f;
import '../data/source/check_status.dart';

class FundHistoryController extends GetxController {
  TextEditingController transactionIdEditingCtrlr = TextEditingController();
  TextEditingController gatewayEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<f.Funds> fundHistoryList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await geFundHistoryList(
          page: page,
          transaction_id: transactionIdEditingCtrlr.text,
          gateway: gatewayEditingCtrlr.text,
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
    fundHistoryList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    page = 1;
    update();
  }

  Future geFundHistoryList(
      {required int page,
      required String transaction_id,
      required String gateway,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await AddFundnRepo.getFundHistoryList(
        page: page, transaction_id: transaction_id, gateway: gateway);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['funds'];
        if (fetchedData.isNotEmpty) {
          fundHistoryList
              .addAll(f.FundHistoryModel.fromJson(data).message!.funds!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          fundHistoryList
              .addAll(f.FundHistoryModel.fromJson(data).message!.funds!);
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
      fundHistoryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    geFundHistoryList(page: page, transaction_id: '', gateway: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    fundHistoryList.clear();
  }
}
