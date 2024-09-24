import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/verification_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class IdentityVerificationScreen extends StatelessWidget {
  final String? id;
  final String? verificationType;
  const IdentityVerificationScreen(
      {super.key, this.verificationType = "", this.id = "0"});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<VerificationController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: '$verificationType',
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _.getSingleVerification(id: id.toString());
            await _.filterData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                  child: Form(
                    key: _.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _.isLoading
                            ? Helpers.appLoader()
                            : _.userIdentityVerifyFromShow == false
                                ? Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 100.h),
                                          height: 160.h,
                                          width: 160.h,
                                          padding: EdgeInsets.all(25.h),
                                          decoration: BoxDecoration(
                                            color: Get.find<
                                                        VerificationController>()
                                                    .userIdentityVerifyMsg
                                                    .toLowerCase()
                                                    .contains('pending')
                                                ? AppColors.pendingColor
                                                    .withOpacity(.2)
                                                : AppColors.greenColor
                                                    .withOpacity(.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            Get.find<VerificationController>()
                                                    .userIdentityVerifyMsg
                                                    .toLowerCase()
                                                    .contains('pending')
                                                ? '$rootImageDir/pending.png'
                                                : '$rootImageDir/approved.png',
                                            color: Get.find<
                                                        VerificationController>()
                                                    .userIdentityVerifyMsg
                                                    .toLowerCase()
                                                    .contains('pending')
                                                ? AppColors.pendingColor
                                                : AppColors.greenColor,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        VSpace(20.h),
                                        Text(
                                            Get.find<VerificationController>()
                                                .userIdentityVerifyMsg,
                                            style: context.t.bodyMedium?.copyWith(
                                                color: Get.find<
                                                            VerificationController>()
                                                        .userIdentityVerifyMsg
                                                        .toLowerCase()
                                                        .contains('pending')
                                                    ? AppColors.pendingColor
                                                    : AppColors.greenColor)),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                        if (_.userIdentityVerifyFromShow == true)
                          if (_.verificationList.isNotEmpty) ...[
                            VSpace(30.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _.verificationList.length,
                              itemBuilder: (context, index) {
                                final dynamicField = _.verificationList[index];
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
                                                dynamicField.fieldLevel!,
                                                style: context.t.bodyLarge,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
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
                                                horizontal: 8.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              color: AppThemes.getFillColor(),
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              border: Border.all(
                                                  color: _.fileColorOfDField,
                                                  width: _.fileColorOfDField ==
                                                          AppColors.redColor
                                                      ? 1
                                                      : .2),
                                            ),
                                            child: Row(
                                              children: [
                                                HSpace(12.w),
                                                Text(
                                                  _.imagePickerResults[
                                                              dynamicField
                                                                  .fieldName] !=
                                                          null
                                                      ? storedLanguage[
                                                              '1 File selected'] ??
                                                          "1 File selected"
                                                      : storedLanguage[
                                                              'No File selected'] ??
                                                          "No File selected",
                                                  style: context.t.bodySmall?.copyWith(
                                                      color: _.imagePickerResults[
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

                                                      await _.pickFile(
                                                          dynamicField
                                                              .fieldName!);
                                                    },
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    child: Ink(
                                                      width: 113.w,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.mainColor,
                                                        borderRadius: Dimensions
                                                            .kBorderRadius,
                                                        border: Border.all(
                                                            color: AppColors
                                                                .mainColor,
                                                            width: .2),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              storedLanguage[
                                                                      'Choose File'] ??
                                                                  'Choose File',
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
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
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
                                              _
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
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
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
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
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
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
                                              _
                                                  .textEditingControllerMap[
                                                      dynamicField.fieldName]!
                                                  .text = v;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],
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
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
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
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
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
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                            data: Theme.of(
                                                                    context)
                                                                .copyWith(
                                                              colorScheme:
                                                                  ColorScheme
                                                                      .dark(
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
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime(2025))
                                                  .then((value) {
                                                if (value != null) {
                                                  _
                                                      .textEditingControllerMap[
                                                          dynamicField
                                                              .fieldName]!
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
                                                    _.textEditingControllerMap[
                                                        dynamicField.fieldName],
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
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
                                                    borderSide: BorderSide(
                                                      color: AppThemes
                                                          .getSliderInactiveColor(),
                                                      width: 1,
                                                    ),
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                  ),

                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                    borderSide: BorderSide(
                                                        color: AppColors
                                                            .mainColor),
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
                                                dynamicField.fieldLevel!,
                                                style: context.t.displayMedium,
                                              ),
                                              dynamicField.validation ==
                                                      'required'
                                                  ? const SizedBox()
                                                  : Text(
                                                      " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                      style: context
                                                          .t.displayMedium,
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
                                                return storedLanguage[
                                                        'Field is required'] ??
                                                    "Field is required";
                                              }
                                              return null;
                                            },
                                            controller:
                                                _.textEditingControllerMap[
                                                    dynamicField.fieldName],
                                            maxLines: 7,
                                            minLines: 5,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                color: AppColors
                                                    .textFieldHintColor,
                                              ),
                                              fillColor: Colors
                                                  .transparent, // Background color
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    Dimensions.kBorderRadius,
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
                          height: 30.h,
                        ),
                        if (_.userIdentityVerifyFromShow == true)
                          AppButton(
                              isLoading: _.isIdentitySubmitting ? true : false,
                              text: storedLanguage['Submit'] ?? 'Submit',
                              onTap: _.isIdentitySubmitting
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (_.formKey.currentState!.validate() &&
                                          _.requiredFile.isEmpty) {
                                        _.fileColorOfDField =
                                            AppColors.mainColor;
                                        _.update();
                                        await _.renderDynamicFieldData();

                                        Map<String, String> stringMap = {};
                                        _.dynamicData.forEach((key, value) {
                                          if (value is String) {
                                            stringMap[key] = value;
                                          }
                                        });

                                        await Future.delayed(
                                            Duration(milliseconds: 300));

                                        Map<String, String> body = {};
                                        body.addAll(stringMap);

                                        await _
                                            .submitVerification(
                                                id: id!,
                                                fields: body,
                                                fileList: _.fileMap.entries
                                                    .map((e) => e.value)
                                                    .toList(),
                                                context: context)
                                            .then((value) {});
                                      } else {
                                        _.fileColorOfDField =
                                            AppColors.redColor;
                                        _.update();
                                        print(
                                            "required type file list===========================: $_.requiredTypeFileList");
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
          ),
        ),
      );
    });
  }
}
