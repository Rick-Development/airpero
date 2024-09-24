import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/app_custom_dropdown.dart';
import 'package:waiz/views/widgets/custom_textfield.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/add_recipient_controller.dart';
import '../../../controllers/money_transfer_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';

class AddRecipientsScreen extends StatelessWidget {
  final String? type;
  const AddRecipientsScreen({super.key, this.type = ""});

  @override
  Widget build(BuildContext context) {
    Get.put(MoneyTransferController(), permanent: true);
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<AddRecipientController>(builder: (addRecipientCtrl) {
      if (addRecipientCtrl.isLoading) {
        return Scaffold(
            appBar: CustomAppBar(
                title:
                    storedLanguage['Add New Recipient'] ?? "Add New Recipient"),
            body: Helpers.appLoader());
      }
      return DefaultTabController(
        length: addRecipientCtrl.serviceList.length,
        child: Scaffold(
          appBar: CustomAppBar(
            title: storedLanguage['Add New Recipient'] ?? "Add New Recipient",
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: addRecipientCtrl.isLoading
                  ? SizedBox(
                      height: Dimensions.screenHeight,
                      width: Dimensions.screenWidth,
                      child: Helpers.appLoader())
                  : Form(
                      key: addRecipientCtrl.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VSpace(30.h),
                          Text(
                            storedLanguage['Recipient Currency'] ??
                                "Recipient Currency",
                            style: context.t.displayMedium,
                          ),
                          VSpace(12.h),
                          Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                borderRadius: Dimensions.kBorderRadius,
                                border: Border.all(
                                    color: AppThemes.getSliderInactiveColor(),
                                    width: 1),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 26.h,
                                    width: 26.h,
                                    margin: EdgeInsets.only(left: 16.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              "${addRecipientCtrl.receiverInitialSelectedCountryImage}"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Expanded(
                                    child: AppCustomDropDown(
                                      paddingLeft: 10.w,
                                      height: 50.h,
                                      width: double.infinity,
                                      items: addRecipientCtrl
                                          .receiverCurrencyList.reversed
                                          .map((e) =>
                                              e.currencyCode +
                                              " - " +
                                              e.currency_name)
                                          .toList(),
                                      selectedValue: addRecipientCtrl
                                          .receiverInitialSelectedCountry,
                                      onChanged:
                                          addRecipientCtrl.onCurrencyChanged,
                                      hint: storedLanguage['Select currency'] ??
                                          "Select currency",
                                      selectedStyle: context.t.displayMedium,
                                      bgColor: AppThemes.getFillColor(),
                                    ),
                                  ),
                                ],
                              )),
                          VSpace(24.h),
                          Text(
                            storedLanguage['Recipient Name'] ??
                                "Recipient Name",
                            style: context.t.displayMedium,
                          ),
                          VSpace(12.h),
                          CustomTextField(
                              isOnlyBorderColor: true,
                              height: 55.h,
                              hintext: "Jhon Doe",
                              controller: addRecipientCtrl.nameEditingCtrl),
                          VSpace(24.h),
                          Text(
                            storedLanguage['Recipient Email'] ??
                                "Recipient Email",
                            style: context.t.displayMedium,
                          ),
                          VSpace(12.h),
                          CustomTextField(
                              isOnlyBorderColor: true,
                              height: 55.h,
                              hintext: "example@gmail.com",
                              controller: addRecipientCtrl.emailEditingCtrl),
                          VSpace(28.h),
                          //------------------------services---------------------//
                          Center(
                            child: Text(
                              storedLanguage['Choose a service'] ??
                                  "Choose a service",
                              style: context.t.bodyMedium
                                  ?.copyWith(fontSize: 20.sp),
                            ),
                          ),
                          VSpace(20.h),
                          addRecipientCtrl.isGettingServices
                              ? Helpers.appLoader()
                              : addRecipientCtrl.serviceList.isEmpty
                                  ? Center(
                                      child: Text(storedLanguage['No Service Available'] ?? "No Service Available",
                                          style: context.t.bodyLarge),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.maxFinite,
                                          padding: EdgeInsets.all(7.h),
                                          decoration: BoxDecoration(
                                            color: AppThemes.getFillColor(),
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                          ),
                                          child: TabBar(
                                            padding: EdgeInsets.zero,
                                            onTap: (index) async {
                                              addRecipientCtrl
                                                  .selectedServiceIndex = index;
                                              // reset textediting value
                                              addRecipientCtrl
                                                  .textEditingControllerMap
                                                  .clear();
                                              addRecipientCtrl.selectedBankVal =
                                                  null;
                                              await addRecipientCtrl
                                                  .onBankChanged(
                                                      addRecipientCtrl
                                                          .serviceList[index]
                                                          .banks![0]
                                                          .name);
                                              addRecipientCtrl.update();
                                            },
                                            labelPadding: EdgeInsets.zero,
                                            indicatorColor: Colors.transparent,
                                            dividerColor: Colors.transparent,
                                            isScrollable: true,
                                            tabAlignment: TabAlignment.start,
                                            overlayColor:
                                                WidgetStatePropertyAll(
                                                    Colors.transparent),
                                            tabs: List.generate(
                                                addRecipientCtrl.serviceList
                                                    .length, (index) {
                                              var data = addRecipientCtrl
                                                  .serviceList[index];

                                              return Material(
                                                color: Colors.transparent,
                                                child: Ink(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 9.h,
                                                      horizontal: 10.w),
                                                  decoration: BoxDecoration(
                                                    color: addRecipientCtrl
                                                                .selectedServiceIndex ==
                                                            index
                                                        ? Get.isDarkMode
                                                            ? AppColors
                                                                .darkBgColor
                                                            : AppColors
                                                                .whiteColor
                                                        : Colors.transparent,
                                                    borderRadius: Dimensions
                                                        .kBorderRadius,
                                                  ),
                                                  child: Text("${data.name}",
                                                      style: context
                                                          .t.displayMedium
                                                          ?.copyWith(
                                                              fontSize: 16.sp)),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                        VSpace(28.h),
                                        Text(
                                          storedLanguage['Bank Name'] ??
                                              "Bank Name",
                                          style: context.t.displayMedium,
                                        ),
                                        VSpace(12.h),
                                        Container(
                                            height: 55.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  Dimensions.kBorderRadius,
                                              border: Border.all(
                                                  color: AppThemes
                                                      .getSliderInactiveColor(),
                                                  width: 1),
                                            ),
                                            child: AppCustomDropDown(
                                              paddingLeft: 10.w,
                                              height: 50.h,
                                              width: double.infinity,
                                              items: addRecipientCtrl
                                                  .serviceList[addRecipientCtrl
                                                      .selectedServiceIndex]
                                                  .banks!
                                                  .map((e) => e.name)
                                                  .toList()
                                                  .toSet()
                                                  .toList(),
                                              selectedValue: addRecipientCtrl
                                                      .selectedBankVal ??
                                                  addRecipientCtrl
                                                      .serviceList[addRecipientCtrl
                                                          .selectedServiceIndex]
                                                      .banks![0]
                                                      .name,
                                              onChanged: (value) async {
                                                // reset textediting value
                                                addRecipientCtrl
                                                    .textEditingControllerMap
                                                    .clear();
                                                addRecipientCtrl
                                                    .selectedBankVal = value;
                                                await addRecipientCtrl
                                                    .onBankChanged(value);
                                                addRecipientCtrl.update();
                                              },
                                              hint: storedLanguage[
                                                      'Select currency'] ??
                                                  "Select currency",
                                              selectedStyle:
                                                  context.t.displayMedium,
                                              bgColor: AppThemes.getFillColor(),
                                            )),
                                        VSpace(24.h),
                                        if (addRecipientCtrl
                                            .selectedDynamicFormList
                                            .isNotEmpty) ...[
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: addRecipientCtrl
                                                .selectedDynamicFormList.length,
                                            itemBuilder: (context, index) {
                                              final dynamicField = addRecipientCtrl
                                                      .selectedDynamicFormList[
                                                  index];
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (dynamicField.type ==
                                                      "file")
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              dynamicField
                                                                  .fieldLevel!,
                                                              style: context.t.bodyLarge?.copyWith(
                                                                  color: Get
                                                                          .isDarkMode
                                                                      ? AppColors
                                                                          .whiteColor
                                                                      : AppColors
                                                                          .paragraphColor),
                                                            ),
                                                            dynamicField.validation ==
                                                                    'required'
                                                                ? const SizedBox()
                                                                : Text(
                                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium,
                                                                  ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        Container(
                                                          height: 45.5,
                                                          width:
                                                              double.maxFinite,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.w,
                                                                  vertical:
                                                                      10.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                Dimensions
                                                                    .kBorderRadius,
                                                            border: Border.all(
                                                                color: addRecipientCtrl
                                                                    .fileColorOfDField,
                                                                width: addRecipientCtrl
                                                                            .fileColorOfDField ==
                                                                        AppColors
                                                                            .redColor
                                                                    ? 1
                                                                    : .2),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              HSpace(12.w),
                                                              Text(
                                                                addRecipientCtrl.imagePickerResults[dynamicField
                                                                            .fieldName] !=
                                                                        null
                                                                    ? storedLanguage[
                                                                            '1 File selected'] ??
                                                                        "1 File selected"
                                                                    : storedLanguage[
                                                                            'No File selected'] ??
                                                                        "No File selected",
                                                                style: context.t.bodySmall?.copyWith(
                                                                    color: addRecipientCtrl.imagePickerResults[dynamicField.fieldName] !=
                                                                            null
                                                                        ? AppColors
                                                                            .greenColor
                                                                        : AppColors
                                                                            .black60),
                                                              ),
                                                              const Spacer(),
                                                              Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    Helpers
                                                                        .hideKeyboard();

                                                                    await addRecipientCtrl
                                                                        .pickFile(
                                                                            dynamicField.fieldName!);
                                                                  },
                                                                  borderRadius:
                                                                      Dimensions
                                                                          .kBorderRadius,
                                                                  child: Ink(
                                                                    width:
                                                                        113.w,
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
                                                                          width:
                                                                              .2),
                                                                    ),
                                                                    child: Center(
                                                                        child: Text(
                                                                            storedLanguage['Choose File'] ??
                                                                                'Choose File',
                                                                            style:
                                                                                context.t.bodySmall?.copyWith(color: AppColors.whiteColor))),
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
                                                  if (dynamicField.type ==
                                                      "text")
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              dynamicField
                                                                  .fieldLevel!,
                                                              style: context.t
                                                                  .displayMedium,
                                                            ),
                                                            dynamicField.validation ==
                                                                    'required'
                                                                ? const SizedBox()
                                                                : Text(
                                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium,
                                                                  ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        TextFormField(
                                                          validator: (value) {
                                                            // Perform validation based on the 'validation' property
                                                            if (dynamicField
                                                                        .validation ==
                                                                    "required" &&
                                                                value!
                                                                    .isEmpty) {
                                                              return storedLanguage[
                                                                      'Field is required'] ??
                                                                  "Field is required";
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (v) {
                                                            addRecipientCtrl
                                                                .textEditingControllerMap[
                                                                    dynamicField
                                                                        .fieldName]!
                                                                .text = v;
                                                          },
                                                          controller: addRecipientCtrl
                                                                  .textEditingControllerMap[
                                                              dynamicField
                                                                  .fieldName],
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        16),
                                                            filled:
                                                                true, // Fill the background with color
                                                            hintStyle:
                                                                TextStyle(
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

                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                              ),
                                                            ),
                                                          ),
                                                          style: context
                                                              .t.bodyMedium,
                                                        ),
                                                        SizedBox(
                                                          height: 16.h,
                                                        ),
                                                      ],
                                                    ),
                                                  if (dynamicField.type ==
                                                      "number")
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              dynamicField
                                                                  .fieldLevel!,
                                                              style: context.t
                                                                  .displayMedium,
                                                            ),
                                                            dynamicField.validation ==
                                                                    'required'
                                                                ? const SizedBox()
                                                                : Text(
                                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium,
                                                                  ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        TextFormField(
                                                          validator: (value) {
                                                            // Perform validation based on the 'validation' property
                                                            if (dynamicField
                                                                        .validation ==
                                                                    "required" &&
                                                                value!
                                                                    .isEmpty) {
                                                              return storedLanguage[
                                                                      'Field is required'] ??
                                                                  "Field is required";
                                                            }
                                                            return null;
                                                          },
                                                          onChanged: (v) {
                                                            addRecipientCtrl
                                                                .textEditingControllerMap[
                                                                    dynamicField
                                                                        .fieldName]!
                                                                .text = v;
                                                          },
                                                          controller: addRecipientCtrl
                                                                  .textEditingControllerMap[
                                                              dynamicField
                                                                  .fieldName],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly,
                                                          ],
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        16),
                                                            filled:
                                                                true, // Fill the background with color
                                                            hintStyle:
                                                                TextStyle(
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

                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                              ),
                                                            ),
                                                          ),
                                                          style: context
                                                              .t.bodyMedium,
                                                        ),
                                                        SizedBox(
                                                          height: 16.h,
                                                        ),
                                                      ],
                                                    ),
                                                  if (dynamicField.type ==
                                                      "date")
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              dynamicField
                                                                  .fieldLevel!,
                                                              style: context.t
                                                                  .displayMedium,
                                                            ),
                                                            dynamicField.validation ==
                                                                    'required'
                                                                ? const SizedBox()
                                                                : Text(
                                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium,
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
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context,
                                                                            child) {
                                                                      return Theme(
                                                                          data: Theme.of(context)
                                                                              .copyWith(
                                                                            colorScheme:
                                                                                ColorScheme.dark(
                                                                              surface: AppColors.bgColor,
                                                                              onPrimary: AppColors.whiteColor,
                                                                            ),
                                                                            textButtonTheme:
                                                                                TextButtonThemeData(
                                                                              style: TextButton.styleFrom(
                                                                                foregroundColor: AppColors.mainColor, // button text color
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              child!);
                                                                    },
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    firstDate:
                                                                        DateTime(
                                                                            1900),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2025))
                                                                .then((value) {
                                                              if (value !=
                                                                  null) {
                                                                addRecipientCtrl
                                                                    .textEditingControllerMap[
                                                                        dynamicField
                                                                            .fieldName]!
                                                                    .text = DateFormat(
                                                                        'yyyy-MM-dd')
                                                                    .format(
                                                                        value);
                                                              }
                                                            });
                                                          },
                                                          child: IgnorePointer(
                                                            ignoring: true,
                                                            child:
                                                                TextFormField(
                                                              validator:
                                                                  (value) {
                                                                // Perform validation based on the 'validation' property
                                                                if (dynamicField
                                                                            .validation ==
                                                                        "required" &&
                                                                    value!
                                                                        .isEmpty) {
                                                                  return storedLanguage[
                                                                          'Field is required'] ??
                                                                      "Field is required";
                                                                }
                                                                return null;
                                                              },
                                                              controller: addRecipientCtrl
                                                                      .textEditingControllerMap[
                                                                  dynamicField
                                                                      .fieldName],
                                                              decoration:
                                                                  InputDecoration(
                                                                contentPadding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            16),
                                                                filled:
                                                                    true, // Fill the background with color
                                                                hintStyle:
                                                                    TextStyle(
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

                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      Dimensions
                                                                          .kBorderRadius,
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: AppThemes
                                                                        .getSliderInactiveColor(),
                                                                  ),
                                                                ),
                                                              ),
                                                              style: context
                                                                  .t.bodyMedium,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 16.h,
                                                        ),
                                                      ],
                                                    ),
                                                  if (dynamicField.type ==
                                                      'textarea')
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              dynamicField
                                                                  .fieldLevel!,
                                                              style: context.t
                                                                  .displayMedium,
                                                            ),
                                                            dynamicField.validation ==
                                                                    'required'
                                                                ? const SizedBox()
                                                                : Text(
                                                                    " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8.h,
                                                        ),
                                                        TextFormField(
                                                          validator: (value) {
                                                            if (dynamicField
                                                                        .validation ==
                                                                    "required" &&
                                                                value!
                                                                    .isEmpty) {
                                                              return storedLanguage[
                                                                      'Field is required'] ??
                                                                  "Field is required";
                                                            }
                                                            return null;
                                                          },
                                                          controller: addRecipientCtrl
                                                                  .textEditingControllerMap[
                                                              dynamicField
                                                                  .fieldName],
                                                          maxLines: 7,
                                                          minLines: 5,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        16),
                                                            filled: true,
                                                            hintStyle:
                                                                TextStyle(
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

                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  Dimensions
                                                                      .kBorderRadius,
                                                              borderSide:
                                                                  BorderSide(
                                                                color: AppThemes
                                                                    .getSliderInactiveColor(),
                                                              ),
                                                            ),
                                                          ),
                                                          style: context
                                                              .t.bodyMedium,
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
                                        VSpace(24.h),
                                        AppButton(
                                            text: storedLanguage['Continue'] ??
                                                "Continue",
                                            isLoading:
                                                addRecipientCtrl.isSubmitting
                                                    ? true
                                                    : false,
                                            onTap: addRecipientCtrl.isSubmitting
                                                ? null
                                                : () async {
                                                    Helpers.hideKeyboard();
                                                    if (addRecipientCtrl
                                                        .nameEditingCtrl
                                                        .text
                                                        .isEmpty) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Recipient Name field is required.");
                                                    } else if (addRecipientCtrl
                                                        .emailEditingCtrl
                                                        .text
                                                        .isEmpty) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Recipient Email field is required.");
                                                    } else {
                                                      if (addRecipientCtrl
                                                          .formKey.currentState!
                                                          .validate()) {
                                                        addRecipientCtrl
                                                                .fileColorOfDField =
                                                            AppColors.mainColor;
                                                        addRecipientCtrl
                                                            .update();
                                                        await addRecipientCtrl
                                                            .renderDynamicFieldData();

                                                        Map<String, String>
                                                            stringMap = {};
                                                        addRecipientCtrl
                                                            .dynamicData
                                                            .forEach(
                                                                (key, value) {
                                                          if (value is String) {
                                                            stringMap[key] =
                                                                value;
                                                          }
                                                        });

                                                        await Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    300));

                                                        Map<String, String>
                                                            body = {
                                                          "type": "$type",
                                                          "currency_id":
                                                              addRecipientCtrl
                                                                  .receiverInitialSelectedCountryId,
                                                          "service_id": addRecipientCtrl
                                                              .serviceList[
                                                                  addRecipientCtrl
                                                                      .selectedServiceIndex]
                                                              .id
                                                              .toString(),
                                                          "bank_id":
                                                              addRecipientCtrl
                                                                  .bank_id
                                                                  .toString(),
                                                          "name": addRecipientCtrl
                                                              .nameEditingCtrl
                                                              .text,
                                                          "email": addRecipientCtrl
                                                              .emailEditingCtrl
                                                              .text,
                                                        };
                                                        body.addAll(stringMap);

                                                        await addRecipientCtrl
                                                            .addRecipient(
                                                                fields: body,
                                                                fileList: addRecipientCtrl
                                                                    .fileMap
                                                                    .entries
                                                                    .map((e) =>
                                                                        e.value)
                                                                    .toList(),
                                                                context:
                                                                    context)
                                                            .then((value) {});
                                                      } else {
                                                        addRecipientCtrl
                                                                .fileColorOfDField =
                                                            AppColors.redColor;
                                                        addRecipientCtrl
                                                            .update();
                                                        print(
                                                            "required type file list===========================: ${addRecipientCtrl.requiredFile}");
                                                        Helpers.showSnackBar(
                                                            msg:
                                                                "Please fill in all required fields.");
                                                      }
                                                    }
                                                  }),
                                      ],
                                    ),
                          VSpace(50.h),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}
