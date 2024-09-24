import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waiz/controllers/money_transfer_controller.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/add_fund_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import 'package:http/http.dart' as http;

class ManualPaymentScreen extends StatefulWidget {
  ManualPaymentScreen({super.key});

  @override
  State<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends State<ManualPaymentScreen> {
  Map<String, TextEditingController> textEditingControllerMap = {};
  List<ManualPaymentDynamicFormModel> fileType = [];
  List<ManualPaymentDynamicFormModel> requiredFile = [];
  List<String> requiredTypeFileList = [];

  Future filterData() async {
    // check if the field type is text or textArea
    var textType = await Get.find<AddFundController>()
        .selectedManualPaymentList
        .where((e) => e.type != 'file')
        .toList();
    for (var field in textType) {
      textEditingControllerMap[field.fieldName] = TextEditingController();
    }
    // check if the field type is file
    fileType = await Get.find<AddFundController>()
        .selectedManualPaymentList
        .where((e) => e.type == 'file')
        .toList();
    // listing the all required file
    requiredFile =
        await fileType.where((e) => e.validation == 'required').toList();
    // add the required file name in a seperate list for validation
    for (var file in requiredFile) {
      requiredTypeFileList.add(file.fieldName);
    }
  }

  @override
  void initState() {
    super.initState();
    filterData();
  }

  @override
  void dispose() {
    for (var controller in textEditingControllerMap.values) {
      controller.dispose();
    }
    imagePickerResults = {};
    requiredTypeFileList.clear();
    super.dispose();
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

  final _formKey = GlobalKey<FormState>();
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
          Get.find<AddFundController>().update();
        }
      } catch (e) {
        Helpers.showSnackBar(msg: e.toString());
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

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<AddFundController>(builder: (payoutCtrl) {
      return GetBuilder<MoneyTransferController>(builder: (transferCtrl) {
        return Scaffold(
          appBar: CustomAppBar(
            title: storedLanguage['Manual Payment'] ?? "Manual Payment",
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                          storedLanguage[
                                  'PLEASE FOLLOW THE INSTRUCTION BELOW'] ??
                              "PLEASE FOLLOW THE INSTRUCTION BELOW",
                          style: context.t.bodyLarge),
                      VSpace(15.h),
                      Text(
                          "You have requested to deposit ${transferCtrl.payableAmountInBaseCurr} ${HiveHelp.read(Keys.baseCurrency) ?? "PKR"} , Please pay ${transferCtrl.amountInSelectedCurr} ${payoutCtrl.selectedCurrency} for successful payment",
                          style: context.t.displayMedium),
                      VSpace(20.h),
                      if (payoutCtrl.selectedManualPaymentList.isNotEmpty)
                        Text(
                            payoutCtrl.selectedManualPaymentList[0].note
                                .toString(),
                            style: context.t.bodySmall?.copyWith(
                                color: AppThemes.getIconBlackColor())),
                      VSpace(30.h),
                      if (payoutCtrl.selectedManualPaymentList.isNotEmpty) ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              payoutCtrl.selectedManualPaymentList.length,
                          itemBuilder: (context, index) {
                            final dynamicField =
                                payoutCtrl.selectedManualPaymentList[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (dynamicField.type == "file")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldLevel,
                                            style: context.t.bodyLarge,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " (Optional)",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Container(
                                        height: 45.5,
                                        width: double.maxFinite,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          color: AppThemes.getFillColor(),
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          border: Border.all(
                                              color:
                                                  payoutCtrl.fileColorOfDField,
                                              width: payoutCtrl
                                                          .fileColorOfDField ==
                                                      AppColors.redColor
                                                  ? 1
                                                  : .2),
                                        ),
                                        child: Row(
                                          children: [
                                            HSpace(12.w),
                                            Text(
                                              imagePickerResults[dynamicField
                                                          .fieldName] !=
                                                      null
                                                  ? "1 File selected"
                                                  : "No File selected",
                                              style: context.t.bodySmall?.copyWith(
                                                  color: imagePickerResults[
                                                              dynamicField
                                                                  .fieldName] !=
                                                          null
                                                      ? AppColors.greenColor
                                                      : AppColors.black60),
                                            ),
                                            const Spacer(),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  Helpers.hideKeyboard();

                                                  await pickFile(
                                                      dynamicField.fieldName);
                                                },
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                child: Ink(
                                                  width: 113.w,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.mainColor,
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    border: Border.all(
                                                        color:
                                                            AppColors.mainColor,
                                                        width: .2),
                                                  ),
                                                  child: Center(
                                                      child: Text('Choose File',
                                                          style: context
                                                              .t.bodySmall
                                                              ?.copyWith(
                                                                  color: AppColors
                                                                      .whiteColor))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == "text")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldLevel,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " (Optional)",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (dynamicField.validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          textEditingControllerMap[
                                                  dynamicField.fieldName]!
                                              .text = v;
                                        },
                                        controller: textEditingControllerMap[
                                            dynamicField.fieldName],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 16),
                                          filled:
                                              true, // Fill the background with color
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                            fillColor: Colors
                                                                .transparent, // Background color
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                                width: 1,
                                                              ),
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                            ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.bodyMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == "number")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldLevel,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (dynamicField.validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          textEditingControllerMap[
                                                  dynamicField.fieldName]!
                                              .text = v;
                                        },
                                        controller: textEditingControllerMap[
                                            dynamicField.fieldName],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 16),
                                          filled:
                                              true, // Fill the background with color
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                          fillColor: Colors
                                                                .transparent, // Background color
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                                width: 1,
                                                              ),
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                            ),

                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.bodyMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == "date")
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldLevel,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          /// SHOW DATE PICKER
                                          await showDatePicker(
                                                  context: context,
                                                  builder: (context, child) {
                                                    return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.dark(
                                                            surface:
                                                                AppColors
                                                                    .bgColor,
                                                            onPrimary: AppColors
                                                                .whiteColor,
                                                          ),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              foregroundColor:
                                                                  AppColors
                                                                      .mainColor, // button text color
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!);
                                                  },
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2025))
                                              .then((value) {
                                            if (value != null) {
                                              textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(value);
                                            }
                                          });
                                        },
                                        child: IgnorePointer(
                                          ignoring: true,
                                          child: TextFormField(
                                            validator: (value) {
                                              // Perform validation based on the 'validation' property
                                              if (dynamicField.validation ==
                                                      "required" &&
                                                  value!.isEmpty) {
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            controller:
                                                textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0,
                                                      horizontal: 16),
                                              filled:
                                                  true, // Fill the background with color
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                               fillColor: Colors
                                                                .transparent, // Background color
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                                width: 1,
                                                              ),
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                            ),

                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
                                                borderSide: BorderSide(
                                                    color: AppColors.mainColor),
                                              ),
                                            ),
                                            style: context.t.bodyMedium,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                if (dynamicField.type == 'textarea')
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            dynamicField.fieldLevel,
                                            style: context.t.displayMedium,
                                          ),
                                          dynamicField.validation == 'required'
                                              ? const SizedBox()
                                              : Text(
                                                  " (Optional)",
                                                  style:
                                                      context.t.displayMedium,
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          if (dynamicField.validation ==
                                                  "required" &&
                                              value!.isEmpty) {
                                            return "Field is required";
                                          }
                                          return null;
                                        },
                                        controller: textEditingControllerMap[
                                            dynamicField.fieldName],
                                        maxLines: 7,
                                        minLines: 5,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 16),
                                          filled: true,
                                          hintStyle: TextStyle(
                                            color: AppColors.textFieldHintColor,
                                          ),
                                           fillColor: Colors
                                                                .transparent, // Background color
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                                width: 1,
                                                              ),
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                            ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            borderSide: BorderSide(
                                                color: AppColors.mainColor),
                                          ),
                                        ),
                                        style: context.t.bodyMedium,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                      SizedBox(
                        height: 12.h,
                      ),
                      AppButton(
                          isLoading: payoutCtrl.isLoading ? true : false,
                          text: storedLanguage['Submit'] ?? 'Submit',
                          onTap: payoutCtrl.isLoading
                              ? null
                              : () async {
                                  Helpers.hideKeyboard();
                                  if (_formKey.currentState!.validate() &&
                                      requiredTypeFileList.isEmpty) {
                                    payoutCtrl.fileColorOfDField =
                                        AppColors.mainColor;
                                    payoutCtrl.update();
                                    await renderDynamicFieldData();
                                    Map<String, String> stringMap = {};
                                    dynamicData.forEach((key, value) {
                                      if (value is String) {
                                        stringMap[key] = value;
                                      }
                                    });

                                    await Future.delayed(
                                        Duration(milliseconds: 200));
                                    Map<String, String> body = {};

                                    body.addAll(stringMap);

                                    await payoutCtrl
                                        .manualPayment(
                                            trxId: payoutCtrl.trxId,
                                            fields: body,
                                            fileList: fileMap.entries
                                                .map((e) => e.value)
                                                .toList())
                                        .then((value) {});
                                  } else {
                                    payoutCtrl.fileColorOfDField =
                                        AppColors.redColor;
                                    payoutCtrl.update();
                                    print(
                                        "required type file list===========================: $requiredTypeFileList");
                                    Helpers.showSnackBar(
                                        msg:
                                            "Please fill in all required fields.");
                                  }
                                }),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      });
    });
  }
}
