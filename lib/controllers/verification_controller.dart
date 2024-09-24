import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/repositories/verification_repo.dart';
import '../data/source/check_status.dart';
import '../routes/routes_name.dart';
import '../utils/services/helpers.dart';

class VerificationController extends GetxController {
  bool isLoading = false;
  //----------------Two Factor Security------------//
  var TwoFAEditingController = TextEditingController();
  bool isTwoFactorEnabled = false;
  String secretKey = '';
  String qrCodeUrl = '';
  Future getTwoFa() async {
    isLoading = true;
    update();
    http.Response response = await VerificationRepo.getTwoFa();
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        isTwoFactorEnabled = data['message']['twoFactorEnable'] ?? false;
        secretKey = data['message']['secret'] ?? "";
        qrCodeUrl = data['message']['qrCodeUrl'] ?? "";
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  bool isVerifying = false;
  Future enableTwoFa({Map<String, dynamic>? fields, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.enableTwoFa(fields: fields);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        getTwoFa();
        Navigator.of(context).pop();
        TwoFAEditingController.clear();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  Future disableTwoFa({Map<String, dynamic>? fields, context}) async {
    isVerifying = true;
    update();
    http.Response response =
        await VerificationRepo.disableTwoFa(fields: fields);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        getTwoFa();
        Navigator.of(context).pop();
        TwoFAEditingController.clear();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  final field1 = TextEditingController();
  final field2 = TextEditingController();
  final field3 = TextEditingController();
  final field4 = TextEditingController();
  final field5 = TextEditingController();
  final field6 = TextEditingController();

  //-----------------mail verify-------------------//
  Future mailVerify({required String code, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.mailVerify(code: code);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //-----------------sms verify-------------------//
  Future smsVerify({required String code, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.smsVerify(code: code);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //-----------------twofa verify-------------------//
  final twoFaController = TextEditingController();
  Future twoFaVerify({required String code, context}) async {
    isVerifying = true;
    update();
    http.Response response = await VerificationRepo.twoFaVerify(code: code);
    isVerifying = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //-----------------resend code-------------------//
  bool isResending = false;
  Future resendCode({required String type}) async {
    isResending = true;
    update();
    http.Response response = await VerificationRepo.resendCode(type: type);
    isResending = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {}
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //----------------address verify-----------------//
  String imagePath = "";
  XFile? pickedImageFile;

  Future<void> pickFiles() async {
    final storageStatus = await Permission.camera.request();
    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        pickedImageFile = await picker.pickImage(source: ImageSource.gallery);

        imagePath = pickedImageFile!.path;
        update();
      } catch (e) {
        Helpers.showSnackBar(msg: e.toString());
      }
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
    }
  }

  //------------------identity verification-------------------//
  List<CategoryNameModel> categoryNameList = [];
  Future getVerificationList() async {
    isLoading = true;
    update();
    http.Response response = await VerificationRepo.getVerificationList();

    isLoading = false;
    categoryNameList = [];
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        List list = data['message']['kyc_list'];
        for (var i in list) {
          categoryNameList
              .add(CategoryNameModel(categoryName: i['name'], id: i['id']));
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  List<VerificationServicesForm> verificationList = [];
  bool isFromCheckStatus = false;
  bool isGettingSingleVerification = false;
  String userIdentityVerifyMsg = "";
  bool userIdentityVerifyFromShow = false;
  int selectedVerficationIndex = -1;
  Color fileColorOfDField = Colors.transparent;
  Future getSingleVerification({required String id}) async {
    isGettingSingleVerification = true;
    update();
    http.Response response =
        await VerificationRepo.getSingleVerification(id: id);

    isGettingSingleVerification = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        userIdentityVerifyMsg =
            data['message'] == null ? "" : data['message']['msg'] ?? "";
        userIdentityVerifyFromShow = data['message']['isFormShow'] ?? false;
        // print(userIdentityVerifyMsg);
        // clear the list initially
        verificationList = [];
        // filter the dynamic field data
        if (data['message']['kycFormData'] != null &&
            data['message']['kycFormData'] is Map) {
          Map<String, dynamic> kForm = data['message']['kycFormData'];
          // dynamic field
          if (kForm['input_form'] != null && kForm['input_form'] is Map) {
            Map<String, dynamic> dForm = kForm['input_form'];
            dForm.forEach((key, value) {
              verificationList.add(VerificationServicesForm(
                  fieldName: value['field_name'],
                  fieldLevel: value['field_label'],
                  type: value['type'],
                  validation: value['validation']));
            });
          }

          update();
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  bool isIdentitySubmitting = false;
  Future submitVerification(
      {required Map<String, String> fields,
      required BuildContext context,
      required String id,
      required Iterable<http.MultipartFile>? fileList}) async {
    isIdentitySubmitting = true;
    update();
    http.Response response = await VerificationRepo.submitVerification(
        type: id, fields: fields, fileList: fileList);
    isIdentitySubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        refreshIndentityVerificationDynamicData();
        Navigator.of(context)
          ..pop()
          ..pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<VerificationServicesForm> fileType = [];
  List<VerificationServicesForm> requiredFile = [];

  Future filterData() async {
    // check if the field type is text, textarea, number or date
    var textType =
        await verificationList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      textEditingControllerMap[field.fieldName!] = TextEditingController();
    }

    // check if the field type is file
    fileType = await verificationList.where((e) => e.type == 'file').toList();
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
  XFile? pickedFile;
  Map<String, http.MultipartFile> fileMap = {};
  Map<String, XFile?> imagePickerResults = {};
  Future<void> pickFile(String fieldName) async {
    final storageStatus = await Permission.camera.request();

    if (storageStatus.isGranted) {
      try {
        final picker = ImagePicker();
        final pickedImageFile =
            await picker.pickImage(source: ImageSource.camera);

        if (pickedImageFile != null) {
          imagePickerResults[fieldName] = pickedImageFile;
          final file = await http.MultipartFile.fromPath(
              fieldName, pickedImageFile.path);
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

  refreshIndentityVerificationDynamicData() {
    verificationList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    pickedImageFile = null;
    fileMap.clear();
    pickedFile = null;
  }
  //--------------------------------------------------//

  refreshData() {
    verificationList.clear();
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    pickedImageFile = null;
    fileMap.clear();
  }
}

class VerificationServicesForm {
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;

  VerificationServicesForm({
    this.fieldName,
    this.fieldLevel,
    this.type,
    this.validation,
  });
}

class CategoryNameModel {
  dynamic categoryName;
  dynamic id;
  CategoryNameModel({this.categoryName, this.id});
}
