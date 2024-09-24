import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/card_controller.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class VirtualCardFormScreen extends StatelessWidget {
  final bool? isFromResubmit;
  const VirtualCardFormScreen({super.key, this.isFromResubmit = false});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<CardController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: isFromResubmit == true ? "Card Re-Order" : _.title,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (isFromResubmit == false) {
              await _.getCardOrder(isFromRefreshIndicator: true);
              await _.filterData();
            } else {
              _.dynamicFormList.clear();
              _.filterData(isFromResubmit: isFromResubmit);
              await _.getVirtualCards();
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _.isCardOrderLoad
                ? SizedBox(
                    height: Dimensions.screenHeight,
                    width: Dimensions.screenWidth,
                    child: Helpers.appLoader(),
                  )
                : Column(
                    children: [
                      if (isFromResubmit == true) VSpace(35.h),
                      if (isFromResubmit == false)
                        Padding(
                          padding: EdgeInsets.only(top: 35.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                                color: AppColors.pendingColor.withOpacity(.1),
                                border: Border.all(
                                    color: AppColors.pendingColor, width: .4),
                                borderRadius: BorderRadius.circular(6.r)),
                            child: Wrap(
                              children: [
                                HSpace(10.w),
                                Icon(
                                  Icons.info,
                                  size: 22.h,
                                ),
                                HSpace(10.w),
                                Text(
                                  "${_.description}",
                                  style: context.t.bodySmall?.copyWith(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      VSpace(20.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                  storedLanguage['Card Currency'] ??
                                      "Card Currency",
                                  style: context.t.displayMedium),
                              HSpace(10.w),
                              ...List.generate(
                                  _.cardOrderCurrencyList.length,
                                  (index) => Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: InkWell(
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          onTap: () {
                                            _.selectedCurr =
                                                _.cardOrderCurrencyList[index];
                                            _.update();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: _.selectedCurr ==
                                                      _.cardOrderCurrencyList[
                                                          index]
                                                  ? AppColors.mainColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              border: Border.all(
                                                  color: AppColors.mainColor),
                                            ),
                                            child: Text(
                                              _.cardOrderCurrencyList[index],
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                color: _.selectedCurr ==
                                                        _.cardOrderCurrencyList[
                                                            index]
                                                    ? AppColors.blackColor
                                                    : Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 20.h),
                        child: Form(
                          key: _.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (_.dynamicFormList.isNotEmpty) ...[
                                VSpace(30.h),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _.dynamicFormList.length,
                                  itemBuilder: (context, index) {
                                    final dynamicField =
                                        _.dynamicFormList[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  color:
                                                      AppThemes.getFillColor(),
                                                  borderRadius:
                                                      Dimensions.kBorderRadius,
                                                  border: Border.all(
                                                      color:
                                                          _.fileColorOfDField,
                                                      width:
                                                          _.fileColorOfDField ==
                                                                  AppColors
                                                                      .redColor
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
                                                              ? AppColors
                                                                  .greenColor
                                                              : AppColors
                                                                  .black60),
                                                    ),
                                                    const Spacer(),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          Helpers
                                                              .hideKeyboard();

                                                          await _.pickFile(
                                                              dynamicField
                                                                  .fieldName);
                                                        },
                                                        borderRadius: Dimensions
                                                            .kBorderRadius,
                                                        child: Ink(
                                                          width: 113.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .mainColor,
                                                            borderRadius:
                                                                Dimensions
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
                                                                      .t
                                                                      .bodySmall
                                                                      ?.copyWith(
                                                                          color:
                                                                              AppColors.whiteColor))),
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
                                                    style:
                                                        context.t.displayMedium,
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
                                                          dynamicField
                                                              .fieldName]!
                                                      .text = v;
                                                },
                                                controller:
                                                    _.textEditingControllerMap[
                                                        dynamicField.fieldName],
                                                decoration: InputDecoration(
                                                  hintText:
                                                      dynamicField.placeholder,
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
                                                    style:
                                                        context.t.displayMedium,
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
                                                          dynamicField
                                                              .fieldName]!
                                                      .text = v;
                                                },
                                                controller:
                                                    _.textEditingControllerMap[
                                                        dynamicField.fieldName],
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                decoration: InputDecoration(
                                                  hintText:
                                                      dynamicField.placeholder,
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
                                                    style:
                                                        context.t.displayMedium,
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
                                                                    onPrimary:
                                                                        AppColors
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
                                                          firstDate:
                                                              DateTime(1900),
                                                          lastDate:
                                                              DateTime(2025))
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
                                                      if (dynamicField
                                                                  .validation ==
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
                                                            dynamicField
                                                                .fieldName],
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
                                                      hintText: dynamicField
                                                          .placeholder,
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
                                                    dynamicField.fieldLevel,
                                                    style:
                                                        context.t.displayMedium,
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
                                                  hintText:
                                                      dynamicField.placeholder,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8,
                                                          horizontal: 16),
                                                  filled: true,
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
                              AppButton(
                                  isLoading: _.isFormSubmtting ? true : false,
                                  text: storedLanguage['Apply'] ?? 'Apply',
                                  onTap: _.isFormSubmtting ||
                                          _.dynamicFormList.isEmpty
                                      ? null
                                      : () async {
                                          Helpers.hideKeyboard();
                                          if (_.selectedCurr.isEmpty) {
                                            Helpers.showSnackBar(
                                                msg:
                                                    "Please select card currency.");
                                          } else if (_.formKey.currentState!
                                                  .validate() &&
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

                                            Map<String, String> body = {
                                              "currency": _.selectedCurr
                                            };
                                            body.addAll(stringMap);

                                            if (isFromResubmit == true) {
                                              await _.cardOrderReSubmit(
                                                context: context,
                                                fields: body,
                                                fileList: _.fileMap.entries
                                                    .map((e) => e.value)
                                                    .toList(),
                                              );
                                            } else {
                                              await _.cardOrderSubmit(
                                                context: context,
                                                fields: body,
                                                fileList: _.fileMap.entries
                                                    .map((e) => e.value)
                                                    .toList(),
                                              );
                                            }
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
