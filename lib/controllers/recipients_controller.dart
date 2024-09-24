import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/models/recipient_details_model.dart' as r;
import '../data/repositories/recipients_repo.dart';
import '../data/source/check_status.dart';
import 'recipients_list_controller.dart';

class RecipientDetailsController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<r.Recipient> recipientDetailsList = [];
  List<BankInfo> bankInfo = [];
  bool isValidRecipient = false;
  int tappedIndex = 0;
  Future getRecipientDetails(
      {required String uuid, bool? isFromNameUpdate = false}) async {
    if (isFromNameUpdate == false) {
      _isLoading = true;
    }
    update();
    http.Response response =
        await RecipientsRepo.getRecipientDetails(uuid: uuid);
    recipientDetailsList = [];
    bankInfo = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        isValidRecipient = true;
        recipientDetailsList
            .add(r.RecipientDetailsModel.fromJson(data).message!.recipient!);
        if (data['message']['recipient']['bank_info'] != null &&
            data['message']['recipient']['bank_info'] is Map) {
          Map<String, dynamic> infoMap =
              data['message']['recipient']['bank_info'];
          infoMap.entries.forEach((e) {
            bankInfo.add(
                BankInfo(info: Info(fieldName: e.key, value: e.value ?? "")));
          });
        }
        if (recipientDetailsList.isNotEmpty) {
          if (isFromNameUpdate == false) {
            _isLoading = false;
          }
          nameEditingController.text = recipientDetailsList[0].name;
          update();
        }
        update();
      } else {
        isValidRecipient = false;
        if (isFromNameUpdate == false) {
          _isLoading = false;
        }
        update();
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      if (isFromNameUpdate == false) {
        _isLoading = false;
      }
      recipientDetailsList = [];
      update();
    }
  }

  bool isChangingName = false;
  TextEditingController nameEditingController = TextEditingController();
  Future changeRecipientName({required String id, required String name}) async {
    isChangingName = true;
    update();
    http.Response response =
        await RecipientsRepo.changeRecipientName(id: id, name: name);
    isChangingName = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Get.back();
      ApiStatus.checkStatus(data['status'], data['message']);
    } else {
      recipientDetailsList = [];
    }
  }

  bool isDeleting = false;
  Future deleteRecipient({required String id}) async {
    isDeleting = true;
    update();
    http.Response response = await RecipientsRepo.deleteRecipient(id: id);
    isDeleting = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await Get.find<RecipientListController>().resetDataAfterSearching();
      await Get.find<RecipientListController>()
          .getRecipientList(page: 1, search: "", isLoadMoreRunning: true);
      Get.back();
      Get.back();
      ApiStatus.checkStatus(data['status'], data['message']);
    } else {
      recipientDetailsList = [];
    }
  }
}

class BankInfo {
  Info info;
  BankInfo({required this.info});
}

class Info {
  final String fieldName;
  final String value;
  Info({required this.fieldName, required this.value});
}
