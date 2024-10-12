import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app_colors.dart';
import '../data/models/virtual_card_model.dart' as v;
import '../data/repositories/card_repo.dart';
import '../data/source/check_status.dart';
import '../utils/services/helpers.dart';

class CardController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController reasonCtrl = TextEditingController();

  List<v.CardOrder> virtualCardList = [];
  List<v.CardOrder> virtualCardFormList = [];
  String orderLock = "";

  static const String _baseUrl =
      "https://issuecards.api.bridgecard.co/v1/issuing/sandbox/cardholder/register_cardholder_synchronously";

  static const String _authToken = 'at_test_f1d330d748e8b92be0dbe4978cac304701071fc9faa3d9f08dac8f645135e36f7bac9c458dcc4ed68653af5baf201ecfe8e24fd9b1c981fbb6932401b3a061a8016995a0ee3712dd5dedb0d705a2b7de4c32de1fe99783a60fa2385b1a67fa328c9c3b0a43ac197ded9db3857b7a2de39e23a51d9b6aefbb740cfd64ed3aa9bd4486b9aa20c7f0fe96a6bfd638b662c2597277980202ee4ff2b3a1b43a84012cd1da2860248de647f2cd432ea852735d257d6261efb04de678318c8722e4d7b37a8e7384163789505938caff7dc769b369af4efd05a0209a2c6f16534446bf3a347a1549b11824344a370bc17129b4f55d1b582a6dd2982d92d565f005858035';
  Future getVirtualCards({bool? isFromRefreshIndicator = false}) async {
    if (isFromRefreshIndicator == false) {
      _isLoading = true;
      update();
    }
    http.Response response = await CardRepo.getVirtualCards();
    if (isFromRefreshIndicator == false) {
      _isLoading = false;
      update();
    }
    virtualCardList = [];
    dynamicFormList = [];
    virtualCardFormList = [];
    update();
   
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        virtualCardList = [...virtualCardList, ...v.VirtualCardModel.fromJson(data).message!.approveCards!];
        virtualCardFormList
            .add(v.VirtualCardModel.fromJson(data).message!.cardOrder!);
        orderLock = data['message']['orderLock'].toString();

        // get virtual card form
        // if (data['message']['cardMethod'] != null &&
        //     data['message']['cardMethod'] is List &&
        //     data['message']['cardMethod'] != []) {
        //   print("=================cardfMethod");
        //   title = data['message']['cardMethod'][0]['name'] ?? "";
        //   description = data['message']['cardMethod'][0]['info_box'] ?? "";
        //   cardOrderCurrencyList = data['message']['cardMethod'][0]['currency'];
        // }

        if (data['message']['cardOrder'] != null &&
            data['message']['cardOrder'] is Map) {
          selectedCurr = data['message']['cardOrder']['currency'];
          cardOrderCurrencyList = [];
          cardOrderCurrencyList.add(selectedCurr);
          if (data['message']['cardOrder']['form_input'] != null &&
              data['message']['cardOrder']['form_input'] is Map) {
            Map<String, dynamic> form =
                data['message']['cardOrder']['form_input'];
            await Future.forEach(form.entries,
                (MapEntry<String, dynamic> e) async {
              dynamicFormList.add(DynamicFormModel(
                fieldName: e.value['field_name'] ?? "",
                fieldLevel: e.value['field_level'] ?? "",
                placeholder: e.value['field_value'] ?? "",
                type: e.value['type'] ?? "",
                validation: e.value['validation'] ?? "",
              ));
            });
            await filterData(isFromResubmit: true);
          }
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      virtualCardList = [];
    }
  }

  bool isBlocking = false;
  Future blockCard({required String id, required String reason}) async {
    isBlocking = true;
    update();
    http.Response response = await CardRepo.blockCard(id: id, reason: reason);
    isBlocking = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == "success") {
        reasonCtrl.clear();
        Get.back();
        getVirtualCards();
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
    }
  }

  Future cardOrderConfirm(
      {required String id, required BuildContext context}) async {
    isBlocking = true;
    update();
    http.Response response = await CardRepo.cardOrderConfirm(id: id);
    isBlocking = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == "success") {
        getVirtualCards();
        Navigator.pop(context);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
    }
  }

  var fileColorOfDField = AppColors.mainColor;
  List<dynamic> cardOrderCurrencyList = [];
  String selectedCurr = "";
  List<DynamicFormModel> dynamicFormList = [];
  String title = "";
  String description = "";
  bool isCardOrderLoad = false;
  Future getCardOrder({bool? isFromRefreshIndicator = false}) async {
    if (isFromRefreshIndicator == false) {
      isCardOrderLoad = true;
      update();
    }
    update();
    http.Response response = await CardRepo.cardOrder();
    if (isFromRefreshIndicator == false) {
      isCardOrderLoad = false;
      update();
    }
    cardOrderCurrencyList = [];
    dynamicFormList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        title = data['message']['virtualCardMethod']['name'] ?? "";
        description = data['message']['virtualCardMethod']['info_box'] ?? "";
        cardOrderCurrencyList =
            data['message']['virtualCardMethod']['currency'];
        if (cardOrderCurrencyList.contains("USD")) {
          selectedCurr = "USD";
        }
        if (data['message']['virtualCardMethod']['form_field'] != null &&
            data['message']['virtualCardMethod']['form_field'] is Map) {
          Map<String, dynamic> form =
              data['message']['virtualCardMethod']['form_field'];
          await Future.forEach(form.entries,
              (MapEntry<String, dynamic> e) async {
            dynamicFormList.add(DynamicFormModel(
              fieldName: e.value['field_name'] ?? "",
              fieldLevel: e.value['field_level'] ?? "",
              placeholder: e.value['field_place'] ?? "",
              type: e.value['type'] ?? "",
              validation: e.value['validation'] ?? "",
            ));
          });
          await filterData();
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      cardOrderCurrencyList = [];
    }
  }

  bool isFormSubmtting = false;




  // Future cardOrderSubmit(
  //     {required Iterable<http.MultipartFile>? fileList,
  //     required Map<String, String> fields,
  //     required BuildContext context}) async {
  //   isFormSubmtting = true;
  //   update();
  //   http.Response response =
  //       await CardRepo.cardOrderSubmit(fields: fields, fileList: fileList);
  //   isFormSubmtting = false;
  //   update();
  //
  //   if (response.statusCode == 200) {
  //     var data = jsonDecode(response.body);
  //     ApiStatus.checkStatus(data['status'], data['message']);
  //     if (data['status'] == "success") {
  //       await getVirtualCards();
  //       refreshData();
  //       Navigator.pop(context);
  //     }
  //   } else {
  //     ApiStatus.checkStatus("error", "Something went wrong!");
  //   }
  // }


  Future<void> registerCardholder() async {
    // API URL
    String url = "https://issuecards.api.bridgecard.co/v1/issuing/sandbox/cardholder/register_cardholder_synchronously";

    // Request body as a JSON payload
    Map<String, dynamic> payload = {
      "first_name": "John",
      "last_name": "Doe",
      "address": {
        "address": "9 Jibowu Street",
        "city": "Aba North",
        "state": "Abia",
        "country": "Nigeria",
        "postal_code": "1000242",
        "house_no": "13"
      },
      "phone": "08122277789",
      "email_address": "testingboy@gmail.com",
      "identity": {
        "id_type": "NIGERIAN_BVN_VERIFICATION",
        "bvn": "12345678902",
        "selfie_image": "https://image.com"
      },
      "meta_data": {"Secret Key": "any_value"}
    };

    // Headers
    Map<String, String> headers = {
      'token': 'Bearer $_authToken',  // Replace with your token
      'Content-Type': 'application/json'
    };

    try {
      // Making the POST request
      http.Response response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(payload), // Encode the payload to JSON
      );

      // Log response for debugging
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Handle the successful response
        log("Cardholder registered successfully: $data");
        // You can call a function here to handle the API response, e.g., show success dialog or update state
      } else {
        // Handle errors
        log("Error: ${response.statusCode}");
        log("Error Body: ${response.body}");
      }
    } catch (e) {
      // Handle any other errors, such as network issues
      log('An error occurred: $e');
    }
  }


  // Future BridgeCardOrderSubmit() async {
  //   isFormSubmtting = true;
  //   update();
  //   http.Response response =
  //       await CardRepo.cardOrderReSubmit(fields: fields, fileList: fileList);
  //   isFormSubmtting = false;
  //   update();
  //   if(response.statusCode==200){
  //     var data=jsonDecode(response.body);
  //     log("data from BridgeCardOrderSubmit $data");
  //     ApiStatus.checkStatus(data['status'], data['message']);
  //   }else {
  //     ApiStatus.checkStatus("error", "Something went wrong!");
  //   }
  // }

  Future cardOrderReSubmit(
      {required Iterable<http.MultipartFile>? fileList,
      required Map<String, String> fields,
      required BuildContext context}) async {
    isFormSubmtting = true;
    update();
    http.Response response =
        await CardRepo.cardOrderReSubmit(fields: fields, fileList: fileList);
    isFormSubmtting = false;
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == "success") {
        await getVirtualCards();
        refreshData();
        Navigator.pop(context);
      }
    } else {
      ApiStatus.checkStatus("error", "Something went wrong!");
    }
  }

  @override
  void onInit() {
    getVirtualCards();
    super.onInit();
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<DynamicFormModel> fileType = [];
  List<DynamicFormModel> requiredFile = [];

  Future filterData({bool? isFromResubmit = false}) async {
    // check if the field type is text, textarea, number or date
    var textType =
        await dynamicFormList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      if (isFromResubmit == true) {
        textEditingControllerMap[field.fieldName] =
            TextEditingController(text: field.placeholder);
      } else {
        textEditingControllerMap[field.fieldName] = TextEditingController();
      }
    }

    // check if the field type is file
    fileType = await dynamicFormList.where((e) => e.type == 'file').toList();
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
  XFile? pickedImageFile;
  Map<String, http.MultipartFile> fileMap = {};
  Map<String, XFile?> imagePickerResults = {};
  Future<void> pickFile(String fieldName) async {
    final storageStatus = await Permission.storage.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        pickedImageFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedImageFile != null) {
          imagePickerResults[fieldName] = pickedImageFile;
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile!.path);
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
  //--------------------------------------------------//

  refreshData() {
    dynamicFormList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    pickedImageFile = null;
    fileMap.clear();
    selectedCurr = "";
  }
}

class DynamicFormModel {
  String fieldName;
  String fieldLevel;
  String placeholder;
  String type;
  String validation;
  DynamicFormModel({
    required this.fieldName,
    required this.fieldLevel,
    required this.placeholder,
    required this.type,
    required this.validation,
  });
}
