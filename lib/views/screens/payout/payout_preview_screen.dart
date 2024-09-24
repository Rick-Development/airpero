import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/payout_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_searchable_dropdown.dart';
import '../../widgets/spacing.dart';

// ignore: must_be_immutable
class PayoutPreviewScreen extends StatelessWidget {
  PayoutPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PayoutController.to.paystackSelectedBank = null;
    PayoutController.to.selectedPaypalValue = null;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PayoutController>(builder: (payoutCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Payout Preview'] ?? 'Payout Preview',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(20.h),
                VSpace(20.h),
                Container(
                  height: 250.h,
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: AppThemes.getFillColor(),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storedLanguage['Payout by'] ?? 'Payout by',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor())),
                          Text(
                            '${payoutCtrl.gatewayName}',
                            style: context.t.bodyMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              storedLanguage['Requested Amount'] ??
                                  'Requested Amount',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor())),
                          Text(
                            '${payoutCtrl.amountCtrl.text} ${payoutCtrl.selectedCurrency}',
                            style: context.t.bodyMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storedLanguage['Percentage'] ?? 'Percentage',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor())),
                          Text(
                            '${payoutCtrl.percentage} ${payoutCtrl.selectedCurrency}',
                            style: context.t.bodyMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storedLanguage['Charge'] ?? 'Charge',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor())),
                          Text(
                            '${payoutCtrl.charge} ${payoutCtrl.selectedCurrency}',
                            style: context.t.bodyMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              storedLanguage['In Base Currency'] ??
                                  'In Base Currency',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor())),
                          if (payoutCtrl.amountCtrl.text.isNotEmpty)
                            Text(
                              "${payoutCtrl.totalPayableAmount} ${payoutCtrl.baseCurrency}",
                              style: context.t.bodyMedium,
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                VSpace(24.h),
                Form(
                  key: payoutCtrl.formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //=====================if the gateway is paypal==============
                        if (payoutCtrl.gatewayName == "Paypal")
                          Text("Select Recipient Type",
                              style: context.t.bodyMedium),
                        if (payoutCtrl.gatewayName == "Paypal") VSpace(5.h),
                        if (payoutCtrl.gatewayName == "Paypal")
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppThemes.getFillColor(),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            child: AppCustomDropDown(
                              height: 46.h,
                              width: double.infinity,
                              items: ["Email", "Phone", "Paypal Id"],
                              selectedValue: payoutCtrl.selectedPaypalValue,
                              onChanged: (value) async {
                                payoutCtrl.selectedPaypalValue = value;
                                payoutCtrl.update();
                              },
                              hint: storedLanguage['Select type'] ??
                                  "Select type",
                              selectedStyle: context.t.displayMedium,
                            ),
                          ),
                        VSpace(25.h),
                        if (payoutCtrl.selectedDynamicList.isNotEmpty) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: payoutCtrl.selectedDynamicList.length,
                            itemBuilder: (context, index) {
                              final dynamicField =
                                  payoutCtrl.selectedDynamicList[index];
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
                                                BorderRadius.circular(34.r),
                                          ),
                                          child: Row(
                                            children: [
                                              HSpace(12.w),
                                              Text(
                                                payoutCtrl.imagePickerResults[
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
                                                    color: payoutCtrl
                                                                    .imagePickerResults[
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

                                                    await payoutCtrl.pickFile(
                                                        dynamicField
                                                            .fieldName!);
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                  child: Ink(
                                                    width: 113.w,
                                                    decoration: BoxDecoration(
                                                      color: Get.isDarkMode
                                                          ? AppColors.mainColor
                                                          : AppColors
                                                              .blackColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              24.r),
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
                                                            style: context.t.bodySmall?.copyWith(
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .blackColor
                                                                    : AppColors
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
                                            payoutCtrl
                                                .textEditingControllerMap[
                                                    dynamicField.fieldName]!
                                                .text = v;
                                          },
                                          controller: payoutCtrl
                                                  .textEditingControllerMap[
                                              dynamicField.fieldName],
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 16),
                                            filled:
                                                true, // Fill the background with color
                                            hintStyle: TextStyle(
                                              color:
                                                  AppColors.textFieldHintColor,
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
                                          height: index ==
                                                  payoutCtrl.selectedDynamicList
                                                          .length -
                                                      1
                                              ? 0
                                              : 16.h,
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
                                              return storedLanguage[
                                                      'Field is required'] ??
                                                  "Field is required";
                                            }
                                            return null;
                                          },
                                          controller: payoutCtrl
                                                  .textEditingControllerMap[
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
                                              color:
                                                  AppColors.textFieldHintColor,
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
                                                  BorderRadius.circular(25.r),
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

                        if (payoutCtrl.gatewayName == "Paystack" &&
                            payoutCtrl.bankFromCurrencyList.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: Text("Select Bank",
                                style: context.t.bodyMedium),
                          ),
                        if (payoutCtrl.gatewayName == "Paystack" &&
                            payoutCtrl.bankFromCurrencyList.isNotEmpty)
                          VSpace(5.h),
                        if (payoutCtrl.gatewayName == "Paystack" &&
                            payoutCtrl.bankFromCurrencyList.isNotEmpty)
                          CustomSearchableDropDown(
                            padding: EdgeInsets.all(4),
                            items: payoutCtrl.bankFromCurrencyList,
                            prefixIcon: SizedBox(),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppThemes.getSliderInactiveColor()),
                              borderRadius: Dimensions.kBorderRadius,
                            ),
                            label:
                                storedLanguage['Select Bank'] ?? 'Select Bank',
                            dropdownItemStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelStyle: context.t.bodySmall?.copyWith(
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor),
                            dropDownMenuItems: [
                              for (int i = 0;
                                  i < payoutCtrl.bankFromCurrencyList.length;
                                  i++)
                                payoutCtrl.bankFromCurrencyList[i].name,
                            ],
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: payoutCtrl.bankFromCurrencyList.isEmpty
                                  ? Colors.grey[400]
                                  : Get.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                            ),
                            onChanged: (value) {
                              payoutCtrl.paystackSelectedBank = value.name;
                              var data = payoutCtrl.bankFromCurrencyList
                                  .firstWhere((e) => e.name == value.name);
                              payoutCtrl.paystackSelectedBankNumber =
                                  data.code.toString();
                              payoutCtrl.paystackSelectedType =
                                  data.type.toString();

                              payoutCtrl.update();
                            },
                          ),
                        //=========================if ther selected gateway is other=====================//

                        VSpace(24.h),
                        VSpace(40.h),
                        Material(
                          color: Colors.transparent,
                          child: AppButton(
                            isLoading:
                                payoutCtrl.isPayoutSubmitting ? true : false,
                            onTap: payoutCtrl.isPayoutSubmitting
                                ? null
                                : () async {
                                    Helpers.hideKeyboard();
                                    // if the payment gateway is paystack
                                    if (payoutCtrl.gatewayName == "Paystack") {
                                      if (payoutCtrl.selectedCurrency == null) {
                                        Helpers.showSnackBar(
                                            msg: "Please select bank currency");
                                      } else if (payoutCtrl
                                              .paystackSelectedBank ==
                                          null) {
                                        Helpers.showSnackBar(
                                            msg: "Please select bank");
                                      } else if (payoutCtrl
                                          .formKey.currentState!
                                          .validate()) {
                                        Map<String, String> body = {
                                          "bank": payoutCtrl
                                              .paystackSelectedBankNumber,
                                        };
                                        payoutCtrl.textEditingControllerMap
                                            .forEach((key, value) {
                                          body[key] = value.text;
                                        });
                                        await Future.delayed(
                                            Duration(milliseconds: 100));
                                        await payoutCtrl.submitPaystackPayout(
                                            context: context, fields: body);
                                      } else {
                                        print(
                                            "required type file list===========================: ${payoutCtrl.requiredTypeFileList}");
                                        Helpers.showSnackBar(
                                            msg:
                                                "Please fill in all required fields.");
                                      }
                                    }
                                    // if the payment gateway is other
                                    else {
                                      if (payoutCtrl.gatewayName == "Paypal" &&
                                          payoutCtrl.selectedPaypalValue ==
                                              null) {
                                        Helpers.showSnackBar(
                                            msg: "Please select bank currency");
                                      } else if (payoutCtrl
                                          .formKey.currentState!
                                          .validate()) {
                                        Map<String, String> body = {
                                          if (payoutCtrl.selectedCurrency !=
                                              null)
                                            "currency_code":
                                                payoutCtrl.selectedCurrency,
                                          "amount": payoutCtrl.amountCtrl.text,
                                          "gateway":
                                              payoutCtrl.gatewayId.toString(),
                                          if (payoutCtrl.gatewayName ==
                                              "Paypal")
                                            "recipient_type":
                                                payoutCtrl.selectedPaypalValue,
                                        };
                                        payoutCtrl.textEditingControllerMap
                                            .forEach((key, value) {
                                          body[key] = value.text;
                                        });

                                        await Future.delayed(
                                            Duration(milliseconds: 100));
                                        if (payoutCtrl.fileMap.isNotEmpty) {
                                          await payoutCtrl.submitPayout(
                                              fileList: payoutCtrl
                                                  .fileMap.entries
                                                  .map((e) => e.value)
                                                  .toList(),
                                              fields: body,
                                              context: context);
                                        }
                                        if (payoutCtrl.fileMap.isEmpty) {
                                          await payoutCtrl.submitPayout(
                                              fileList: null,
                                              fields: body,
                                              context: context);
                                        }
                                      } else {
                                        print(
                                            "required type file list===========================: ${payoutCtrl.requiredTypeFileList}");
                                        Helpers.showSnackBar(
                                            msg:
                                                "Please fill in all required fields.");
                                      }
                                    }
                                  },
                            text:
                                storedLanguage['Confirm Now'] ?? 'Confirm Now',
                            borderRadius: BorderRadius.circular(32.r),
                          ),
                        ),
                        VSpace(40.h),
                      ]),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
