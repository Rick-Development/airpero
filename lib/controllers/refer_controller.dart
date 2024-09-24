import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/refer_list_model.dart' as r;
import '../data/repositories/refer_repo.dart';
import '../data/source/check_status.dart';

class ReferController extends GetxController {
  late ScrollController scrollController;
  int page = 1;
  bool isLoadMore = false;
  bool hasNextPage = true;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<r.ReferUser> referList = [];
  String url = "";
  String earnAmount = "0";
  String freeTransfer = "0";
  bool referStatus = false;
  Future loadMore() async {
    if (_isLoading == false &&
        isLoadMore == false &&
        hasNextPage == true &&
        scrollController.position.extentAfter < 300) {
      isLoadMore = true;
      update();
      page += 1;
      await getRefer(page: page, isLoadMoreRunning: true);
      if (kDebugMode) {
        print("====================loaded from load more: " + page.toString());
      }
      isLoadMore = false;
      update();
    }
  }

  bool isSearchTapped = false;
  resetDataAfterSearching({bool? isFromOnRefreshIndicator = false}) {
    referList.clear();
    isSearchTapped = true;
    hasNextPage = true;
    page = 1;
    update();
  }

  Future getRefer({required int page, bool? isLoadMoreRunning = false}) async {
    if (isLoadMoreRunning == false) {
      _isLoading = true;
    }
    update();
    http.Response response = await ReferRepo.getRefer(page: page.toString());
    if (isLoadMoreRunning == false) {
      _isLoading = false;
    }
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        url = data['message']['refer']['url'].toString();
        earnAmount = data['message']['refer']['earnAmount'].toString();
        freeTransfer = data['message']['refer']['freeTransfer'].toString();
        referStatus = data['message']['refer']['referStatus'];
        final fetchedData = data['message']['referUser'];

        if (fetchedData.isNotEmpty) {
          referList = [
            ...referList,
            ...r.ReferralList.fromJson(data).message!.referUser!
          ];
          if (isLoadMoreRunning == false) {
            _isLoading = false;
          }
          update();
        } else {
          referList = [
            ...referList,
            ...r.ReferralList.fromJson(data).message!.referUser!
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
      referList = [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    getRefer(page: page);
    scrollController = ScrollController()..addListener(loadMore);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    referList.clear();
  }
}
