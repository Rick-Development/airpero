import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waiz/controllers/wallet_controller.dart';
import '../data/models/bank_from_bank_model.dart';
import '../data/models/bank_from_currency_model.dart' as currency;
import '../data/models/payout_gateways_model.dart';
import '../data/models/bank_from_bank_model.dart' as bank;
import '../data/repositories/payout_repo.dart';
import '../data/source/check_status.dart';
import '../routes/page_index.dart';
import '../utils/services/helpers.dart';
import 'payout_history_controller.dart';

class PayoutController extends GetxController {
  static PayoutController get to => Get.find<PayoutController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  TextEditingController amountCtrl = TextEditingController();

  List<DynamicFieldModel> dynamicList = [];
  List<DynamicFieldModel> selectedDynamicList = [];
  List<PayoutMethods> paymentGatewayList = [];
  List<String> flutterwaveTransferList = [];
  Future getPayouts() async {
    _isLoading = true;
    update();
    http.Response response = await PayoutRepo.getPayouts();
    _isLoading = false;
    paymentGatewayList = [];
    dynamicList = [];
    flutterwaveTransferList = [];
    update();

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        paymentGatewayList
            .addAll(PayoutModel.fromJson(data).message!.payoutMethods!);
        // filter the dynamic field data
        List list = data['message']['payoutMethods'];
        for (var i in list) {
          if (i['inputForm'] != null && i['inputForm'] is Map) {
            // dynamic field
            Map<String, dynamic> dForm = i['inputForm'];
            dForm.forEach((key, value) {
              if (value['field_name'] != null && value['field_label'] != null) {
                dynamicList.add(DynamicFieldModel(
                  name: i['name'],
                  fieldName: value['field_name'],
                  fieldLevel: value['field_label'],
                  type: value['type'],
                  validation: value['validation'],
                ));
              }
            });
          }
          // if the payment gateway is flutterwave
          if (i['name'] == "Flutterwave") {
            if (i['bank_name'] != null && i['bank_name'] is Map) {
              Map<String, dynamic> dBankMap = i['bank_name'];
              dBankMap.entries.forEach((e) {
                Map<String, dynamic> dNestedBankMap = e.value;
                dNestedBankMap.entries.forEach((x) {
                  flutterwaveTransferList.add(x.value);
                });
              });
            }
          }
        }

        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
        update();
      }
    } else {
      Helpers.showSnackBar(msg: jsonDecode(response.body)['message']);

      update();
    }
  }

  int selectedGatewayIndex = -1;
  List<PayoutMethods> searchedGatewayItem = [];
  bool isGatewaySearching = false;
  TextEditingController gatewaySearchCtrl = TextEditingController();
  queryPaymentGateway(String v) {
    searchedGatewayItem = paymentGatewayList
        .where((PayoutMethods e) => e.name.toString().toLowerCase().contains(v.toLowerCase()))
        .toList();
    selectedGatewayIndex = -1;
    if (v.isEmpty) {
      isGatewaySearching = false;
      searchedGatewayItem.clear();
      update();
    } else if (v.isNotEmpty) {
      isGatewaySearching = true;
      update();
    }
    update();
  }

  int gatewayId = 0;
  String gatewayName = "";
  dynamic selectedCurrency = null;
  String baseCurrency = "";
  List<PayoutCurrencies> payoutCurrencyList = [];
  List<dynamic> supportedCurrencyList = [];
  getSelectedGatewayData(index) {
    var data = paymentGatewayList[index];
    gatewayId = data.id;
    gatewayName = data.name;
    baseCurrency = data.currency;
    // get the selected payment gateway's currency for getting the min, max, charge
    payoutCurrencyList = [];
    if (data.payoutCurrencies != null) {
      payoutCurrencyList = data.payoutCurrencies!;
    }
    // get the supported currencies for displaying in the payout page
    supportedCurrencyList = [];
    selectedCurrency = null;
    if (data.supportedCurrency != null) {
      supportedCurrencyList = data.supportedCurrency!;
    }
    update();
  }

  // get the selected currency data
  String minAmount = "0.00";
  String maxAmount = "0.00";
  String charge = "0.00";
  String conversion_rate = "0.00";
  String percentage = "0";
  getSelectedCurrencyData(value) async {
    amountCtrl.clear();
    amountValue = "";
    var selectedCurr = await payoutCurrencyList.firstWhere((e) {
      if (e.name != null) {
        return e.name == value;
      } else {
        return e.currencySymbol == value;
      }
    });
    minAmount = selectedCurr.minLimit.toString();
    maxAmount = selectedCurr.maxLimit.toString();
    charge = selectedCurr.fixedCharge.toString();
    conversion_rate = selectedCurr.conversionRate.toString();
    percentage = selectedCurr.percentageCharge.toString();
    calculateAmount();
    update();
  }

  // calculate amount
  String payableAmount = "0.00";
  String totalPayableAmount = "0.00";
  calculateAmount() {
    if (amountValue.isNotEmpty && selectedCurrency != null) {
      payableAmount =
          (double.parse(amountValue.toString()) + double.parse(charge))
              .toStringAsFixed(2);
      totalPayableAmount =
          ((double.parse(amountValue.toString()) + double.parse(charge)) /
                  double.parse(conversion_rate))
              .toStringAsFixed(2);
      update();
    }
  }

  String amountValue = "";
  bool isFollowedTransactionLimit = true;
  onChangedAmount(v) {
    amountValue = v.toString();
    if (v.toString().isNotEmpty) {
      if ((double.parse(v.toString()) >= double.parse(minAmount)) &&
          (double.parse(v.toString()) <= double.parse(maxAmount))) {
        isFollowedTransactionLimit = true;
      } else {
        isFollowedTransactionLimit = false;
        Helpers.showSnackBar(
            msg:
                "minimum payment $minAmount and maximum payment limit $maxAmount");
      }
    }
    calculateAmount();
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // getPayouts();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      WalletController.to.getWallets();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  //----------PAYOUT REQUEST----------//
  String wallet_id = "";
  var selectedWallet;
  bool isPayoutRequestSuccess = false;
  String trxId = "";
  Future payoutRequest({required Map<String, String> fields}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response = await PayoutRepo.payoutRequest(fields: fields);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        trxId = data['message']['trx_id'] ?? "";
        isPayoutRequestSuccess = true;
        update();
      } else {
        isPayoutRequestSuccess = false;
        ApiStatus.checkStatus(data['status'], data['message']);
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //----------PAYOUT SUBMIT----------//
  bool isPayoutSubmitting = false;
  var selectedPaypalValue = null;
  Future submitPayout(
      {required Map<String, String> fields,
      required BuildContext context,
      required Iterable<http.MultipartFile>? fileList}) async {
    isPayoutSubmitting = true;
    update();
    try {
      http.Response response = await PayoutRepo.payoutSubmit(
          fields: fields, trxId: this.trxId, fileList: fileList);
      isPayoutSubmitting = false;
      update();
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ApiStatus.checkStatus(data['status'], data['message']);
        if (data['status'] == 'success') {
          refreshDynamicData();
          PayoutHistoryController.to
              .resetDataAfterSearching(isFromOnRefreshIndicator: true);
          ;
          PayoutHistoryController.to.getPayoutHistoryList(
              page: 1, transaction_id: '', start_date: '', end_date: '');
          Get.offAll(() => PayoutHistoryScreen(isFromPayoutPage: true));
          update();
        }
        update();
      } else {
        Helpers.showSnackBar(msg: '${data['message']}');
      }
    } catch (e) {
      isPayoutSubmitting = false;
      Helpers.showSnackBar(msg: "$e");
      update();
    }
  }

  //------------FLUTTER WAVE---------//
  var flutterWaveSelectedTransfer = null;
  var flutterWaveSelectedBank = null;
  String flutterwaveSelectedBankNumber = "0";
  List<bank.Data> bankFromBankList = [];
  List<String> bankFromBankDynamicList = [];
  Map<String, TextEditingController> bankFromBanktextEditingControllerMap = {};
  Future getBankFromBank({required String bankName}) async {
    isBankLoading = true;
    update();
    http.Response response =
        await PayoutRepo.getBankFromBank(bankName: bankName);
    bankFromBankList = [];
    bankFromBankDynamicList = [];
    isBankLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['message']['bank'] != null &&
            data['message']['bank']['data'] != null) {
          bankFromBankList
              .addAll(BankFromBankModel.fromJson(data).message!.bank!.data!);
        }
        if (data['message']['input_form'] != null &&
            data['message']['input_form'] is Map) {
          Map<String, dynamic> map = data['message']['input_form'];
          map.forEach((key, value) {
            bankFromBankDynamicList.add(key);
            bankFromBanktextEditingControllerMap[key] = TextEditingController();
          });
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  Future submitFlutterwavePayout(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response =
        await PayoutRepo.flutterwaveSubmit(fields: fields, trxId: this.trxId);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);

      if (data['status'] == 'success') {
        refreshDynamicData();
        PayoutHistoryController.to
            .resetDataAfterSearching(isFromOnRefreshIndicator: true);
        ;
        PayoutHistoryController.to.getPayoutHistoryList(
            page: 1, transaction_id: '', start_date: '', end_date: '');
        Get.offAll(() => PayoutHistoryScreen(isFromPayoutPage: true));
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //------------PAYSTACK---------//
  var paystackSelectedBank = null;
  String paystackSelectedBankNumber = "0";
  String paystackSelectedType = "";
  List<currency.Data> bankFromCurrencyList = [];
  bool isBankLoading = false;
  Future getBankFromCurrency({required String currencyCode}) async {
    isBankLoading = true;
    update();
    http.Response response =
        await PayoutRepo.getBankFromCurrency(currencyCode: currencyCode);
    bankFromCurrencyList = [];
    isBankLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        if (data['message']['data'] != null &&
            data['message']['data'] is List) {
          bankFromCurrencyList.addAll(
              currency.BankFromCurrencyModel.fromJson(data).message!.data!);
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  Future submitPaystackPayout(
      {required Map<String, String> fields,
      required BuildContext context}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response =
        await PayoutRepo.paystackSubmit(fields: fields, trxId: this.trxId);
    isPayoutSubmitting = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        refreshDynamicData();
        PayoutHistoryController.to
            .resetDataAfterSearching(isFromOnRefreshIndicator: true);
        ;
        PayoutHistoryController.to.getPayoutHistoryList(
            page: 1, transaction_id: '', start_date: '', end_date: '');
        Get.offAll(() => PayoutHistoryScreen(isFromPayoutPage: true));
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  bool isPayoutConfirmRequSuccess = false;
  int selectedPayoutConfirmIndex = -1;
  Future payoutConfirm({required String trxId}) async {
    isPayoutSubmitting = true;
    update();
    http.Response response = await PayoutRepo.payoutConfirm(trxId: trxId);
    isPayoutSubmitting = false;
    selectedDynamicList = [];
    flutterwaveTransferList = [];
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        // get needed data for submitting on the payout submit api
        baseCurrency = data['message']['base_currency'].toString();
        amountCtrl.text =
            double.parse(data['message']['payout']['amount'].toString())
                .toStringAsFixed(2);
        amountValue =
            double.parse(data['message']['payout']['amount'].toString())
                .toStringAsFixed(2);
        selectedCurrency = data['message']['payout']['payout_currency_code'];
        gatewayId =
            int.parse(data['message']['payout']['payout_method_id'].toString());
        totalPayableAmount = double.parse(data['message']['payout']
                    ['net_amount_in_base_currency']
                .toString())
            .toStringAsFixed(2);
        this.trxId = data['message']['payout']['trx_id'];

        // filter the dynamic field data
        Map<String, dynamic> i = data['message']['payoutMethod'];

        if (i['inputForm'] != null && i['inputForm'] is Map) {
          // dynamic field
          Map<String, dynamic> dForm = i['inputForm'];
          dForm.forEach((key, value) {
            if (value['field_name'] != null && value['field_label'] != null) {
              selectedDynamicList.add(DynamicFieldModel(
                name: i['name'],
                fieldName: value['field_name'],
                fieldLevel: value['field_label'],
                type: value['type'],
                validation: value['validation'],
              ));
            }
          });
        }
        // if the payment gateway is flutterwave
        if (i['name'] == "Flutterwave") {
          if (i['bank_name'] != null && i['bank_name'] is Map) {
            Map<String, dynamic> dBankMap = i['bank_name'];
            dBankMap.entries.forEach((e) {
              Map<String, dynamic> dNestedBankMap = e.value;
              dNestedBankMap.entries.forEach((x) {
                flutterwaveTransferList.add(x.value);
              });
            });
          }
        }

        // get needed data for submitting on the payout submit api
        gatewayName = i['name'];
        if (i['payout_currencies'] != null && i['payout_currencies'] is List) {
          List<dynamic> currencyList = i['payout_currencies'];
          var selectedCurr = await currencyList.firstWhere((e) =>
              e['currency_symbol'] ==
              data['message']['payout']['payout_currency_code']);
          charge = selectedCurr['fixed_charge'];
          percentage = selectedCurr['percentage_charge'];
        }
        // if the payment gateway is paystack then get the bank list from currency
        if (selectedCurrency != null) {
          if (gatewayName == "Paystack") {
            await getBankFromCurrency(currencyCode: selectedCurrency);
          }
        }
        await Future.delayed(Duration(milliseconds: 200));
        // make isPayoutConfirmRequSuccess = true, for navigate to the payout preview page
        if (this.gatewayName != "" && this.trxId != "") {
          isPayoutConfirmRequSuccess = true;
        }
        update();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //------------------let's manupulate the dynamic form data-----//
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<DynamicFieldModel> fileType = [];
  List<DynamicFieldModel> requiredFile = [];
  List<String> requiredTypeFileList = [];

  Future filterData() async {
    // check if the field type is text or textArea
    var textType =
        await selectedDynamicList.where((e) => e.type != 'file').toList();

    for (var field in textType) {
      textEditingControllerMap[field.fieldName] = TextEditingController();
    }

    // check if the field type is file
    fileType =
        await selectedDynamicList.where((e) => e.type == 'file').toList();
    // listing the all required file
    requiredFile =
        await fileType.where((e) => e.validation == 'required').toList();
    // add the required file name in a seperate list for validation
    for (var file in requiredFile) {
      requiredTypeFileList.add(file.fieldName);
    }
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

          if (requiredTypeFileList.contains(fieldName)) {
            requiredTypeFileList.remove(fieldName);
          }
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
    imagePickerResults.clear();
    dynamicData.clear();
    textEditingControllerMap.clear();
    fileType.clear();
    requiredFile.clear();
    requiredTypeFileList.clear();
    pickedFile = null;
    fileMap.clear();
  }
  //--------------------------------------------------//
}

class DynamicFieldModel {
  String name;
  dynamic fieldName;
  dynamic fieldLevel;
  dynamic type;
  dynamic validation;
  DynamicFieldModel(
      {required this.name,
      this.fieldName,
      this.fieldLevel,
      this.type,
      this.validation});
}

class OtherGatewayCurrencyModel {
  String gatewayName;
  String currency;
  OtherGatewayCurrencyModel(
      {required this.gatewayName, required this.currency});
}
