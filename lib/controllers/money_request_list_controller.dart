import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/data/repositories/money_request_repo.dart';
import 'package:waiz/utils/services/helpers.dart';
import '../data/models/money_request_history_model.dart' as m;
import '../data/source/check_status.dart';

class MoneyRequestListController extends GetxController {
  static MoneyRequestListController get to =>
      Get.find<MoneyRequestListController>();
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<m.Datum> moneyRequestList = [];
  String userId = "";
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getMoneyRequestHistory(page: page, isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    moneyRequestList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    page = 1;
    update();
  }

  Future getMoneyRequestHistory(
      {required int page, bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response =
        await MoneyRequestRepo.getMoneyRequestHistory(page: page.toString());
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fetchedData = data['message']['data'];
        if (fetchedData.isNotEmpty) {
          moneyRequestList = [
            ...moneyRequestList,
            ...m.MoneyRequestHistoryModel.fromJson(data).message!.data!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          moneyRequestList = [
            ...moneyRequestList,
            ...m.MoneyRequestHistoryModel.fromJson(data).message!.data!
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
      moneyRequestList = [];
    }
  }

  Future recipientstore({required Map<String, dynamic> fields}) async {
    update();
    http.Response response =
        await MoneyRequestRepo.recipientstore(fields: fields);
    update();
    print(response.body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        ApiStatus.checkStatus(data['status'], data['message']['message']);
        RecipientListController.to.searchEditingCtrlr.clear();
        resetDataAfterSearching();
        getMoneyRequestHistory(page: page);
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['message']);
    }
  }

  bool isActioning = false;
  bool isTappedFromApprove = false;
  Future moneyRequestAction(
      {required Map<String, dynamic> fields,
      required BuildContext context}) async {
    isActioning = true;
    update();
    http.Response response =
        await MoneyRequestRepo.moneyRequestAction(fields: fields);
    isActioning = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        print(data);
        isTappedFromApprove = false;
        resetDataAfterSearching();
        getMoneyRequestHistory(page: page);
        Navigator.pop(context);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['message']);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getMoneyRequestHistory(page: page);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    moneyRequestList.clear();
  }
}
