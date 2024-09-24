import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:http/http.dart' as http;
import 'package:waiz/themes/themes.dart';
import '../data/models/money_transfer_currency_model.dart' as m;
import '../data/models/recipient_services_model.dart' as s;
import '../data/repositories/add_recipient_repo.dart';
import '../data/repositories/money_transfer_repo.dart';
import '../data/source/check_status.dart';
import '../utils/services/helpers.dart';

class AddRecipientController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController nameEditingCtrl = TextEditingController();
  TextEditingController emailEditingCtrl = TextEditingController();

  int selectedServiceIndex = 0;
  dynamic selectedBankVal = null;

  String receiverInitialSelectedCountryId = "0";
  String receiverInitialSelectedCountryImage = "";
  dynamic receiverInitialSelectedCountry;

  List<m.SenderCurrency> receiverCurrencyList = [];
  Future getTransferCurrencies() async {
    _isLoading = true;
    update();
    http.Response response = await MoneyTransferRepo.getTransferCurrencies();
    receiverCurrencyList = [];
    _isLoading = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        receiverCurrencyList.addAll(m.MoneyTransferCurrencyModel.fromJson(data)
            .message!
            .receiverCurrencies!);
        if (receiverCurrencyList.isNotEmpty) {
          receiverInitialSelectedCountryId =
              receiverCurrencyList.last.id.toString();
          receiverInitialSelectedCountryImage =
              receiverCurrencyList.last.countryImage;
          receiverInitialSelectedCountry =
              receiverCurrencyList.last.currencyCode +
                  " - " +
                  receiverCurrencyList.last.currency_name;
          if (receiverInitialSelectedCountryId != "0") {
            await getServices(country_id: receiverInitialSelectedCountryId);
          }
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      receiverCurrencyList = [];
      update();
    }
  }

  bool isGettingServices = false;
  List<s.Service> serviceList = [];
  List<DynamicFieldModel> dynamicFormList = [];
  List<DynamicFieldModel> selectedDynamicFormList = [];
  Future getServices({required String country_id}) async {
    isGettingServices = true;
    update();

    http.Response response =
        await AddRecipientRepo.getServices(country_id: country_id);
    serviceList = [];
    dynamicFormList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        if (data['message'] != null &&
            data['message']['services'] != null &&
            data['message']['services'] is List &&
            data['message']['services'].isNotEmpty) {
          serviceList.addAll(
              s.RecipientServicesModel.fromJson(data).message!.services!);
          isGettingServices = false;
          // get the dynamic form data
          for (var i in data['message']['services']) {
            if (i['banks'] != null && i['banks'] is List) {
              for (var j in i['banks']) {
                if (j['services_form'] != null && j['services_form'] is Map) {
                  Map<String, dynamic> map = j['services_form'];
                  map.entries.forEach((e) {
                    dynamicFormList.add(DynamicFieldModel(
                      serviceName: i['name'],
                      bankName: j['name'],
                      bankId: j['id'],
                      fieldName: e.value['field_name'],
                      fieldLevel: e.value['field_label'],
                      type: e.value['type'],
                      validation: e.value['validation'],
                    ));
                  });
                }
              }
            }
          }
          // get the selected dynamic list
          if (serviceList.isNotEmpty &&
              serviceList[selectedServiceIndex].banks!.isNotEmpty) {
            selectedDynamicFormList = await dynamicFormList
                .where((e) =>
                    e.serviceName == serviceList[selectedServiceIndex].name &&
                    e.bankName ==
                        serviceList[selectedServiceIndex].banks![0].name &&
                    e.bankId == serviceList[selectedServiceIndex].banks![0].id)
                .toList();
            bank_id = serviceList[selectedServiceIndex].banks![0].id.toString();

            if (selectedDynamicFormList.isNotEmpty) {
              await filterData();
              isGettingServices = false;
              update();
            }
          }
        } else {
          isGettingServices = false;
          serviceList = [];
          update();
        }
        update();
      } else {
        isGettingServices = false;
        update();
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      isGettingServices = false;
      print("something went wrong!");
      ApiStatus.checkStatus("error", "Something went wrong!");
      update();
    }
  }

  onCurrencyChanged(value) async {
    // reset service index and bankVal initially
    selectedServiceIndex = 0; // set initially 0
    selectedBankVal = null; // set null
    receiverInitialSelectedCountry = value;
    receiverInitialSelectedCountryImage = receiverCurrencyList
        .firstWhere((e) => e.currencyCode == value.toString().split(" ").first)
        .countryImage;
    receiverInitialSelectedCountryId = receiverCurrencyList
        .firstWhere((e) => e.currencyCode == value.toString().split(" ").first)
        .id
        .toString();
    if (receiverInitialSelectedCountryId != "0") {
      await getServices(country_id: receiverInitialSelectedCountryId);
    }
    update();
  }

  var bank_id;
  Future onBankChanged(value) async {
    bank_id = await serviceList[selectedServiceIndex]
        .banks!
        .firstWhere((e) => e.name == value)
        .id;
    selectedDynamicFormList = await dynamicFormList
        .where((e) =>
            e.serviceName == serviceList[selectedServiceIndex].name &&
            e.bankName == value &&
            e.bankId == bank_id)
        .toList();
    if (selectedDynamicFormList.isNotEmpty) {
      await filterData();
    }
  }

  bool isSubmitting = false;
  Future addRecipient(
      {required Map<String, String> fields,
      required BuildContext context,
      required Iterable<http.MultipartFile>? fileList}) async {
    isSubmitting = true;
    update();
    http.Response response =
        await AddRecipientRepo.addRecipient(fields: fields, fileList: fileList);
    isSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        refreshDynamicData();
        RecipientListController.to
            .resetDataAfterSearching(isFromOnRefreshIndicator: true);
        RecipientListController.to.getRecipientList(
          page: 1,
          search: '',
        );
        Navigator.of(context).pop();

        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  @override
  void onInit() {
    getTransferCurrencies();
    super.onInit();
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<DynamicFieldModel> fileType = [];
  List<DynamicFieldModel> requiredFile = [];

  Future filterData() async {
    // check if the field type is text, textarea, number or date
    var textType =
        await selectedDynamicFormList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      textEditingControllerMap[field.fieldName!] = TextEditingController();
    }

    // check if the field type is file
    fileType =
        await selectedDynamicFormList.where((e) => e.type == 'file').toList();
    // listing the all required file
    requiredFile =
        await fileType.where((e) => e.validation == 'required').toList();
  }

  Map<String, dynamic> dynamicData = {};
  List<String> imgPathList = [];

  Future renderDynamicFieldData() async {
    imgPathList.clear();
    textEditingControllerMap.forEach((key, controller) {
      dynamicData[key] = controller.text;
    });
    await Future.forEach(imagePickerResults.keys, (String key) async {
      String filePath = imagePickerResults[key]!.path;
      imgPathList.add(imagePickerResults[key]!.path);
      dynamicData[key] = await http.MultipartFile.fromPath("", filePath);
    });

    // if (kDebugMode) {
    //   print("Posting data: $dynamicData");
    // }
  }

  final formKey = GlobalKey<FormState>();
  Color fileColorOfDField = AppThemes.getSliderInactiveColor();
  XFile? pickedFile;
  Map<String, http.MultipartFile> fileMap = {};
  Map<String, XFile?> imagePickerResults = {};
  Future<void> pickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          imagePickerResults[fieldName] = pickedFile;
          final file =
              await http.MultipartFile.fromPath(fieldName, pickedFile!.path);
          fileMap[fieldName] = file;
          update();
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error while picking files: $e");
        }
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
    }
  }

  refreshDynamicData() {
    selectedDynamicFormList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    pickedFile = null;
    fileMap.clear();
    pickedFile = null;
  }
}

class DynamicFieldModel {
  String serviceName;
  String bankName;
  int bankId;
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;
  DynamicFieldModel(
      {required this.serviceName,
      required this.bankName,
      required this.bankId,
      this.fieldName,
      this.fieldLevel,
      this.type,
      this.validation});
}
