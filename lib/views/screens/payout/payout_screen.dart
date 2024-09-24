import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class PayoutScreen extends StatefulWidget {
  const PayoutScreen({super.key});

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  FocusNode node = FocusNode();
  @override
  void initState() {
    node.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.put(PayoutController());
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PayoutController>(builder: (payoutCtrl) {
      if (payoutCtrl.isLoading) {
        return Scaffold(
            appBar: CustomAppBar(title: storedLanguage['Payout'] ?? "Payout"),
            body: Helpers.appLoader());
      }
      if (payoutCtrl.paymentGatewayList.isEmpty) {
        return Scaffold(
          appBar: CustomAppBar(title: storedLanguage['Payout'] ?? "Payout"),
          body: Helpers.notFound(top: 0),
        );
      }
      return Scaffold(
        appBar: CustomAppBar(title: storedLanguage['Payout'] ?? "Payout"),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(32.h),
              CustomTextField(
                isOnlyBorderColor: true,
                hintext: storedLanguage['Search Gateway'] ?? "Search Gateway",
                controller: payoutCtrl.gatewaySearchCtrl,
                isSuffixIcon: true,
                isSuffixBgColor: true,
                suffixIcon: "search",
                suffixIconColor: AppColors.blackColor,
                onChanged: payoutCtrl.queryPaymentGateway,
              ),
              VSpace(32.h),
              Expanded(
                  child: ListView.builder(
                      itemCount: payoutCtrl.isGatewaySearching
                          ? payoutCtrl.searchedGatewayItem.length
                          : payoutCtrl.paymentGatewayList.length,
                      itemBuilder: (context, i) {
                        var data = payoutCtrl.isGatewaySearching
                            ? payoutCtrl.searchedGatewayItem[i]
                            : payoutCtrl.paymentGatewayList[i];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: InkWell(
                            borderRadius: Dimensions.kBorderRadius / 2,
                            onTap: () async {
                              Helpers.hideKeyboard();
                              payoutCtrl.selectedGatewayIndex = i;
                              payoutCtrl.getSelectedGatewayData(i);
                              payoutCtrl.update();
                              buildDialog(context, payoutCtrl, storedLanguage);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Get.isDarkMode
                                            ? AppColors.black70
                                            : AppColors.black20,
                                        width: .2)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 42.h,
                                    width: 64.w,
                                    decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? AppColors.darkBgColor
                                            : AppColors.fillColorColor,
                                        borderRadius:
                                            Dimensions.kBorderRadius / 2,
                                        image: data.image
                                                .toString()
                                                .contains("wallet_payment.png")
                                            ? DecorationImage(
                                                image: AssetImage(data.image),
                                                fit: BoxFit.fill,
                                              )
                                            : DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        data.image),
                                                fit: BoxFit.cover,
                                              )),
                                  ),
                                  HSpace(16.w),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(data.name, style: t.bodyMedium),
                                      VSpace(1.h),
                                      Text(
                                          data.name
                                                  .toString()
                                                  .toLowerCase()
                                                  .contains("wallet")
                                              ? "Send money from your wallet"
                                              : data.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: t.bodySmall?.copyWith(
                                              color: AppThemes
                                                  .getParagraphColor())),
                                    ],
                                  )),
                                  Container(
                                    width: 20.h,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color:
                                          payoutCtrl.selectedGatewayIndex == i
                                              ? AppColors.mainColor
                                              : Colors.transparent,
                                      border: Border.all(
                                          color:
                                              payoutCtrl.selectedGatewayIndex !=
                                                      i
                                                  ? AppThemes
                                                      .getSliderInactiveColor()
                                                  : Colors.transparent),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.done_rounded,
                                        size: 14.h,
                                        color:
                                            payoutCtrl.selectedGatewayIndex == i
                                                ? AppColors.blackColor
                                                : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
              VSpace(24.h),
            ],
          ),
        ),
      );
    });
  }

  Future<dynamic> buildDialog(
      BuildContext context, PayoutController payoutCtrl, storedLanguage) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<PayoutController>(builder: (payoutCtrl) {
          return Container(
              padding: Dimensions.kDefaultPadding,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppThemes.getDarkCardColor(),
                borderRadius: Dimensions.kBorderRadius * 2,
              ),
              child: ListView(
                children: [
                  VSpace(32.h),
                  if (payoutCtrl.gatewayName != "")
                    Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                payoutCtrl.selectedCurrency == null
                                    ? const SizedBox()
                                    : Text(
                                        "Transaction Limit: ${payoutCtrl.minAmount}-${payoutCtrl.maxAmount} ${payoutCtrl.selectedCurrency}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.bodySmall?.copyWith(
                                            color: AppColors.redColor),
                                      ),
                                Spacer(),
                                Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(50),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(50),
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Ink(
                                      height: 26.h,
                                      width: 26.h,
                                      padding: EdgeInsets.all(3.h),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Get.isDarkMode
                                              ? AppColors.darkBgColor
                                              : AppColors.sliderInActiveColor),
                                      child: Icon(
                                        Icons.close,
                                        size: 15.h,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          payoutCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          Text(
                            storedLanguage['Select Your Wallet'] ??
                                "Select Your Wallet",
                            style: context.t.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          VSpace(12.h),
                          Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppThemes.getSliderInactiveColor()),
                                borderRadius: Dimensions.kBorderRadius,
                              ),
                              child: AppCustomDropDown(
                                height: 50.h,
                                width: double.infinity,
                                items: WalletController.to.walletDataList
                                    .map((e) => e.currencyAndCountryName)
                                    .toList(),
                                selectedValue: payoutCtrl.selectedWallet,
                                onChanged: (value) async {
                                  payoutCtrl.selectedWallet = value;
                                  // get the currency rate for wallet payment
                                  payoutCtrl.wallet_id = WalletController
                                      .to.walletDataList
                                      .firstWhere((e) =>
                                          e.currencyAndCountryName == value)
                                      .id
                                      .toString();

                                  payoutCtrl.update();
                                },
                                hint: storedLanguage['Select Your Wallet'] ??
                                    "Select Your Wallet",
                                selectedStyle: context.t.displayMedium,
                                bgColor: Get.isDarkMode
                                    ? AppColors.darkBgColor
                                    : AppColors.fillColorColor,
                              )),
                          VSpace(20.h),
                          Text(
                            storedLanguage['Select Currency'] ??
                                "Select Currency",
                            style: context.t.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          VSpace(12.h),
                          Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppThemes.getSliderInactiveColor()),
                                borderRadius: Dimensions.kBorderRadius,
                              ),
                              child: AppCustomDropDown(
                                height: 50.h,
                                width: double.infinity,
                                items: payoutCtrl.supportedCurrencyList
                                    .map((e) => e)
                                    .toList(),
                                selectedValue: payoutCtrl.selectedCurrency,
                                onChanged: (value) async {
                                  payoutCtrl.selectedCurrency = value;
                                  payoutCtrl.getSelectedCurrencyData(value);
                                  if (payoutCtrl.gatewayName == "Paystack") {
                                    payoutCtrl.getBankFromCurrency(
                                        currencyCode: value);
                                  }

                                  payoutCtrl.update();
                                },
                                hint: storedLanguage['Select currency'] ??
                                    "Select currency",
                                selectedStyle: context.t.displayMedium,
                                bgColor: Get.isDarkMode
                                    ? AppColors.darkBgColor
                                    : AppColors.fillColorColor,
                              )),
                          VSpace(20.h),
                          payoutCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : Text(storedLanguage['Amount'] ?? 'Amount',
                                  style: context.t.bodyMedium),
                          payoutCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          payoutCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : CustomTextField(
                                  focusNode: node,
                                  isOnlyBorderColor: true,
                                  isSuffixIcon: payoutCtrl.amountValue.isEmpty
                                      ? false
                                      : true,
                                  suffixIcon:
                                      payoutCtrl.isFollowedTransactionLimit
                                          ? "check"
                                          : "warning",
                                  suffixIconSize:
                                      payoutCtrl.isFollowedTransactionLimit
                                          ? 20.h
                                          : 15.h,
                                  suffixIconColor:
                                      payoutCtrl.isFollowedTransactionLimit
                                          ? AppColors.greenColor
                                          : AppColors.redColor,
                                  contentPadding: EdgeInsets.only(left: 20.w),
                                  hintext: storedLanguage['Enter Amount'] ??
                                      'Enter Amount',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                        payoutCtrl.maxAmount.length),
                                  ],
                                  controller: payoutCtrl.amountCtrl,
                                  onChanged: payoutCtrl.onChangedAmount,
                                ),
                          VSpace(16.h),
                          if (payoutCtrl.amountValue.isNotEmpty &&
                              payoutCtrl.selectedCurrency != null)
                            Container(
                              height: 130.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: Dimensions.kBorderRadius,
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.mainColor
                                        : AppColors.black20,
                                    width: Dimensions.appThinBorder),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Amount In ${payoutCtrl.selectedCurrency}",
                                              style: context
                                                  .t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${payoutCtrl.amountValue} ${payoutCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600)),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.mainColor
                                          : AppColors.black20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              storedLanguage['Charge'] ??
                                                  "Charge",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${payoutCtrl.charge} ${payoutCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                        color:
                                                            AppColors.redColor,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: .2,
                                      color: Get.isDarkMode
                                          ? AppColors.mainColor
                                          : AppColors.black20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              storedLanguage[
                                                      'Payable Amount'] ??
                                                  "Payable Amount",
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .textFieldHintColor
                                                          : AppColors
                                                              .paragraphColor)),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${payoutCtrl.payableAmount} ${payoutCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                        color:
                                                            AppColors.mainColor,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          VSpace(32.h),
                          Material(
                            color: Colors.transparent,
                            child: AppButton(
                              isLoading:
                                  payoutCtrl.isPayoutSubmitting ? true : false,
                              onTap: payoutCtrl.isPayoutSubmitting
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (payoutCtrl.gatewayName == "") {
                                        Helpers.showSnackBar(
                                            msg:
                                                "Please select a gateway first");
                                      } else if (payoutCtrl
                                          .amountCtrl.text.isEmpty) {
                                        Helpers.showSnackBar(
                                            msg: "Amount field is required");
                                      } else {
                                        if (double.parse(
                                                payoutCtrl.amountCtrl.text) <
                                            double.parse(
                                                payoutCtrl.minAmount)) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "Please follow the transaction limit");
                                        } else if (payoutCtrl
                                                .isFollowedTransactionLimit ==
                                            false) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "minimum payment ${payoutCtrl.minAmount} and maximum payment limit ${payoutCtrl.maxAmount}");
                                        } else {
                                          //------ for showing these data in the paymentSuccess page
                                          MoneyTransferController
                                                  .to.amountInSelectedCurr =
                                              payoutCtrl.amountCtrl.text;
                                          AddFundController
                                                  .to.selectedCurrency =
                                              payoutCtrl.selectedCurrency
                                                  .toString();
                                          AddFundController.to.gatewayName =
                                              payoutCtrl.gatewayName.toString();
                                          // till here for showing these data in the paymentSuccess page ------
                                          if (payoutCtrl.gatewayName ==
                                              "Flutterwave") {
                                            await payoutCtrl
                                                .payoutRequest(fields: {
                                              "payout_method_id": payoutCtrl
                                                  .gatewayId
                                                  .toString(),
                                              "supported_currency": payoutCtrl
                                                  .selectedCurrency
                                                  .toString(),
                                              "amount":
                                                  payoutCtrl.amountCtrl.text,
                                              "wallet_id": payoutCtrl.wallet_id,
                                            });
                                            if (payoutCtrl
                                                    .isPayoutRequestSuccess ==
                                                true) {
                                              Get.toNamed(RoutesName
                                                  .flutterWaveWithdrawScreen);
                                            }
                                          } else if (payoutCtrl.gatewayName ==
                                              "Paystack") {
                                            payoutCtrl.selectedDynamicList =
                                                await payoutCtrl.dynamicList
                                                    .where((e) =>
                                                        e.name ==
                                                        payoutCtrl.gatewayName)
                                                    .toList();
                                            await payoutCtrl.filterData();
                                            await payoutCtrl
                                                .payoutRequest(fields: {
                                              "payout_method_id": payoutCtrl
                                                  .gatewayId
                                                  .toString(),
                                              "supported_currency": payoutCtrl
                                                  .selectedCurrency
                                                  .toString(),
                                              "amount":
                                                  payoutCtrl.amountCtrl.text,
                                              "wallet_id": payoutCtrl.wallet_id,
                                            });
                                            if (payoutCtrl
                                                    .isPayoutRequestSuccess ==
                                                true) {
                                              Get.toNamed(RoutesName
                                                  .payoutPreviewScreen);
                                            }
                                          } else {
                                            if (payoutCtrl.wallet_id.isEmpty) {
                                              Helpers.showSnackBar(
                                                  msg:
                                                      "Please select your wallet");
                                            } else {
                                              payoutCtrl.selectedDynamicList =
                                                  await payoutCtrl.dynamicList
                                                      .where((e) =>
                                                          e.name ==
                                                          payoutCtrl
                                                              .gatewayName)
                                                      .toList();
                                              await payoutCtrl.filterData();
                                              await payoutCtrl
                                                  .payoutRequest(fields: {
                                                "payout_method_id": payoutCtrl
                                                    .gatewayId
                                                    .toString(),
                                                "supported_currency": payoutCtrl
                                                    .selectedCurrency
                                                    .toString(),
                                                "amount":
                                                    payoutCtrl.amountCtrl.text,
                                                "wallet_id":
                                                    payoutCtrl.wallet_id,
                                              });
                                              if (payoutCtrl
                                                      .isPayoutRequestSuccess ==
                                                  true) {
                                                Get.toNamed(RoutesName
                                                    .payoutPreviewScreen);
                                              }
                                            }
                                          }
                                        }
                                      }
                                    },
                              text: storedLanguage['Make Payment'] ??
                                  "Make Payment",
                            ),
                          ),
                          VSpace(node.hasFocus ? 250.h : 50.h),
                        ],
                      ),
                    ),
                ],
              ));
        });
      },
    );
  }
}
