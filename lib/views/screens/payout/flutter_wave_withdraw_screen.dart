import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/payout_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_searchable_dropdown.dart';

// ignore: must_be_immutable
class FlutterWaveWithdrawScreen extends StatelessWidget {
  FlutterWaveWithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PayoutController.to.flutterWaveSelectedTransfer = null;
    PayoutController.to.bankFromBankDynamicList = [];
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
                  height: 180.h,
                  width: double.maxFinite,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AppThemes.getFillColor(),
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(
                      color: AppColors.mainColor,
                      width: .2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storedLanguage['Payout by'] ?? 'Payout by',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getBlack50Color())),
                          Text(
                            '${payoutCtrl.gatewayName}',
                            style: context.t.displayMedium
                                ?.copyWith(color: AppColors.mainColor),
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
                                  color: AppThemes.getBlack50Color())),
                          Text(
                            '${payoutCtrl.amountCtrl.text} ${payoutCtrl.selectedCurrency}',
                            style: context.t.displayMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storedLanguage['Percentage'] ?? 'Percentage',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getBlack50Color())),
                          Text(
                            '${payoutCtrl.percentage} ${payoutCtrl.selectedCurrency}',
                            style: context.t.displayMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(storedLanguage['Charge'] ?? 'Charge',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getBlack50Color())),
                          Text(
                            '${payoutCtrl.charge} ${payoutCtrl.selectedCurrency}',
                            style: context.t.displayMedium,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              storedLanguage['Amount In Base Currency'] ??
                                  'Amount In Base Currency',
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getBlack50Color())),
                          if (payoutCtrl.amountCtrl.text.isNotEmpty)
                            Text(
                              "${payoutCtrl.totalPayableAmount} ${payoutCtrl.baseCurrency}",
                              style: context.t.displayMedium,
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                VSpace(24.h),
                if (payoutCtrl.flutterwaveTransferList.isNotEmpty)
                  Text(storedLanguage['Select Transfer'] ?? "Select Transfer",
                      style: context.t.bodyMedium),
                if (payoutCtrl.flutterwaveTransferList.isNotEmpty) VSpace(5.h),
                if (payoutCtrl.flutterwaveTransferList.isNotEmpty)
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppThemes.getFillColor(),
                      borderRadius: Dimensions.kBorderRadius,
                      border: Border.all(color: AppColors.mainColor, width: .2),
                    ),
                    child: AppCustomDropDown(
                      height: 46.h,
                      width: double.infinity,
                      items: payoutCtrl.flutterwaveTransferList
                          .map((e) => e)
                          .toList(),
                      selectedValue: payoutCtrl.flutterWaveSelectedTransfer,
                      onChanged: (value) async {
                        payoutCtrl.flutterWaveSelectedTransfer = value;
                        payoutCtrl.getBankFromBank(bankName: value);
                        payoutCtrl.update();
                      },
                      hint: storedLanguage['Select Transfer'] ??
                          "Select Transfer",
                      selectedStyle: context.t.displayMedium,
                    ),
                  ),
                VSpace(15.h),
                if (payoutCtrl.bankFromBankList.isNotEmpty)
                  Text(storedLanguage['Select Bank'] ?? "Select Bank",
                      style: context.t.bodyMedium),
                if (payoutCtrl.bankFromBankList.isNotEmpty) VSpace(5.h),
                if (payoutCtrl.bankFromBankList.isNotEmpty)
                  CustomSearchableDropDown(
                    padding: EdgeInsets.all(4),
                    items: payoutCtrl.bankFromBankList,
                    prefixIcon: SizedBox(),
                    decoration: BoxDecoration(
                        color: AppThemes.getFillColor(),
                        borderRadius: Dimensions.kBorderRadius,
                        border:
                            Border.all(color: AppColors.mainColor, width: .2)),
                    label: storedLanguage['Select Bank'] ?? 'Select Bank',
                    dropdownItemStyle: TextStyle(
                      color: Colors.black,
                    ),
                    labelStyle: context.t.bodySmall?.copyWith(
                        color: Get.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.blackColor),
                    dropDownMenuItems: [
                      for (int i = 0;
                          i < payoutCtrl.bankFromBankList.length;
                          i++)
                        payoutCtrl.bankFromBankList[i].name,
                    ],
                    suffixIcon: Icon(
                      Icons.arrow_drop_down,
                      color: payoutCtrl.bankFromBankList.isEmpty
                          ? Colors.grey[400]
                          : Get.isDarkMode
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                    ),
                    onChanged: (value) {
                      payoutCtrl.flutterWaveSelectedBank = value.name;
                      var data = payoutCtrl.bankFromBankList
                          .firstWhere((e) => e.name == value.name);
                      payoutCtrl.flutterwaveSelectedBankNumber =
                          data.code.toString();
                      payoutCtrl.update();
                    },
                  ),
                VSpace(24.h),
                Form(
                  key: payoutCtrl.formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (payoutCtrl.isBankLoading) Helpers.appLoader(),
                        if (payoutCtrl.bankFromBankDynamicList.isNotEmpty) ...[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                payoutCtrl.bankFromBankDynamicList.length,
                            itemBuilder: (context, index) {
                              var data =
                                  payoutCtrl.bankFromBankDynamicList[index];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.replaceAll("_", " "),
                                        style: context.t.displayMedium,
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      TextFormField(
                                        validator: (value) {
                                          // Perform validation based on the 'validation' property
                                          if (value!.isEmpty) {
                                            return storedLanguage[
                                                    'Field is required'] ??
                                                "Field is required";
                                          }
                                          return null;
                                        },
                                        onChanged: (v) {
                                          payoutCtrl
                                              .bankFromBanktextEditingControllerMap[
                                                  data]!
                                              .text = v;
                                        },
                                        controller: payoutCtrl
                                                .bankFromBanktextEditingControllerMap[
                                            data],
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
                                ],
                              );
                            },
                          ),
                        ],
                      ]),
                ),
                VSpace(40.h),
                if (payoutCtrl.flutterWaveSelectedTransfer != null &&
                    payoutCtrl.flutterWaveSelectedBank != null)
                  Material(
                    color: Colors.transparent,
                    child: AppButton(
                      isLoading: payoutCtrl.isPayoutSubmitting ? true : false,
                      onTap: payoutCtrl.isPayoutSubmitting
                          ? null
                          : () async {
                              Helpers.hideKeyboard();
                              if (payoutCtrl.selectedCurrency == null) {
                                Helpers.showSnackBar(
                                    msg: "Please select bank currency");
                              } else if (payoutCtrl.flutterWaveSelectedBank ==
                                  null) {
                                Helpers.showSnackBar(msg: "Please select bank");
                              } else if (payoutCtrl.formKey.currentState!
                                  .validate()) {
                                Map<String, String> body = {
                                  "transfer_name":
                                      payoutCtrl.flutterWaveSelectedTransfer,
                                  "currency_code": payoutCtrl.selectedCurrency,
                                  "bank":
                                      payoutCtrl.flutterwaveSelectedBankNumber,
                                  "amount": payoutCtrl.amountCtrl.text,
                                  "gateway": payoutCtrl.gatewayId.toString(),
                                };
                                payoutCtrl.bankFromBanktextEditingControllerMap
                                    .forEach((key, value) {
                                  body[key] = value.text;
                                });
                                await Future.delayed(
                                    Duration(milliseconds: 100));
                                print(body);
                                await payoutCtrl.submitFlutterwavePayout(
                                    context: context, fields: body);
                              } else {
                                print(
                                    "required type file list===========================: ${payoutCtrl.requiredTypeFileList}");
                                Helpers.showSnackBar(
                                    msg: "Please fill in all required fields.");
                              }
                            },
                      text: storedLanguage['Confirm Now'] ?? 'Confirm Now',
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                  ),
                VSpace(40.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
