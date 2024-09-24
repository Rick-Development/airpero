import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/transfer_history_model.dart' as t;
import '../data/repositories/transfer_history_repo.dart';
import '../data/source/check_status.dart';

class TransferHistoryController extends GetxController {
  TextEditingController nameEditingCtrlr = TextEditingController();
  TextEditingController startDateTimeEditingCtrlr = TextEditingController();
  TextEditingController endDateTimeEditingCtrlr = TextEditingController();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<t.Transfer> transferHistoryList = [];
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getTransferHistory(
          page: page,
          name: nameEditingCtrlr.text,
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
    transferHistoryList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    page = 1;
    update();
  }

  Future getTransferHistory(
      {required int page,
      required String name,
      required String start_date,
      required String end_date,
      bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await TransferHistoryRepo.getTransferHistory(
        page: page, name: name, start_date: start_date, end_date: end_date);
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['transfers'];
        if (fetchedData.isNotEmpty) {
          transferHistoryList.addAll(
              t.TransferHistoryModel.fromJson(data).message!.transfers!);
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          transferHistoryList.addAll(
              t.TransferHistoryModel.fromJson(data).message!.transfers!);
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
      transferHistoryList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getTransferHistory(page: page, name: '', start_date: '', end_date: '');
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    transferHistoryList.clear();
  }
}
