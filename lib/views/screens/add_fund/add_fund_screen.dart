import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/add_fund_controller.dart';
import '../../../controllers/money_transfer_controller.dart';
import '../../../controllers/wallet_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class AddFundScreen extends StatefulWidget {
  const AddFundScreen({super.key});

  @override
  State<AddFundScreen> createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
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
    Get.put(AddFundController());
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<AddFundController>(builder: (addFundCtrl) {
      if (addFundCtrl.isLoading) {
        return Scaffold(
            appBar:
                CustomAppBar(title: storedLanguage['Add Fund'] ?? "Add Fund"),
            body: Helpers.appLoader());
      }
      return Scaffold(
        appBar: CustomAppBar(title: storedLanguage['Add Fund'] ?? "Add Fund"),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(32.h),
              CustomTextField(
                isOnlyBorderColor: true,
                hintext: storedLanguage['Search Gateway'] ?? "Search Gateway",
                controller: addFundCtrl.gatewaySearchCtrl,
                isSuffixIcon: true,
                isSuffixBgColor: true,
                suffixIcon: "search",
                suffixIconColor: AppColors.blackColor,
                onChanged: addFundCtrl.queryPaymentGateway,
              ),
              VSpace(32.h),
              addFundCtrl.isLoading
                  ? Helpers.appLoader()
                  : Expanded(
                      child: ListView.builder(
                          itemCount: addFundCtrl.isGatewaySearching
                              ? addFundCtrl.searchedGatewayItem.length
                              : addFundCtrl.paymentGatewayList.length,
                          itemBuilder: (context, i) {
                            var data = addFundCtrl.isGatewaySearching
                                ? addFundCtrl.searchedGatewayItem[i]
                                : addFundCtrl.paymentGatewayList[i];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: InkWell(
                                borderRadius: Dimensions.kBorderRadius / 2,
                                onTap: () async {
                                  Helpers.hideKeyboard();
                                  addFundCtrl.selectedGatewayIndex = i;
                                  addFundCtrl.getGatewayData(i);
                                  addFundCtrl.getSelectedGatewayData(i,
                                      isFromMoneyTransferPage: false);

                                  // reset selectedCrypto
                                  addFundCtrl.selectedCryptoCurrency = null;

                                  addFundCtrl.update();
                                  buildDialog(
                                      context, addFundCtrl, storedLanguage);
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
                                                    .contains(
                                                        "wallet_payment.png")
                                                ? DecorationImage(
                                                    image:
                                                        AssetImage(data.image),
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
                                      addFundCtrl.isLoadingDetails == true &&
                                              addFundCtrl
                                                      .selectedGatewayIndex ==
                                                  i
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  width: 15.h,
                                                  height: 15.h,
                                                  child: Helpers.appLoader()),
                                            )
                                          : Container(
                                              width: 20.h,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                color: addFundCtrl
                                                            .selectedGatewayIndex ==
                                                        i
                                                    ? AppColors.mainColor
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: addFundCtrl
                                                                .selectedGatewayIndex !=
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
                                                  color: addFundCtrl
                                                              .selectedGatewayIndex ==
                                                          i
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
            ],
          ),
        ),
      );
    });
  }

  Future<dynamic> buildDialog(
      BuildContext context, AddFundController addFundCtrl, storedLanguage) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<AddFundController>(builder: (addFundCtrl) {
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
                  if (addFundCtrl.gatewayName != "")
                    Padding(
                      padding: Dimensions.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                addFundCtrl.is_crypto == true
                                    ? addFundCtrl.selectedCryptoCurrency == null
                                        ? const SizedBox()
                                        : Text(
                                            "${storedLanguage['Transaction Limit:'] ?? "Transaction Limit:"} ${addFundCtrl.minAmount}-${addFundCtrl.maxAmount} ${addFundCtrl.selectedCryptoCurrency}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.t.bodySmall
                                                ?.copyWith(
                                                    color: AppColors.redColor),
                                          )
                                    : addFundCtrl.selectedCurrency == null
                                        ? const SizedBox()
                                        : Text(
                                            "${storedLanguage['Transaction Limit:'] ?? "Transaction Limit:"} ${addFundCtrl.minAmount}-${addFundCtrl.maxAmount} ${addFundCtrl.selectedCurrency}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.t.bodySmall
                                                ?.copyWith(
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
                          VSpace(20.h),
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
                                bgColor: Get.isDarkMode
                                    ? AppColors.darkBgColor
                                    : AppColors.fillColorColor,
                                items: WalletController.to.walletDataList
                                    .map((e) => e.currencyAndCountryName)
                                    .toList(),
                                selectedValue: addFundCtrl.selectedWallet,
                                onChanged: (value) async {
                                  addFundCtrl.selectedWallet = value;
                                  // get the currency rate for wallet payment
                                  addFundCtrl.wallet_id = WalletController
                                      .to.walletDataList
                                      .firstWhere((e) =>
                                          e.currencyAndCountryName == value)
                                      .id
                                      .toString();

                                  addFundCtrl.update();
                                },
                                hint: storedLanguage['Select Your Wallet'] ??
                                    "Select Your Wallet",
                                selectedStyle: context.t.displayMedium,
                              )),
                          VSpace(20.h),
                          addFundCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          Text(
                            storedLanguage['Select Gateway Currency'] ??
                                "Select Gateway Currency",
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
                              items: addFundCtrl.is_crypto == true
                                  ? ["USD"]
                                  : addFundCtrl.supportedCurrencyList
                                      .map((e) => e)
                                      .toList(),
                              selectedValue: addFundCtrl.selectedCurrency,
                              onChanged: (value) async {
                                addFundCtrl.selectedCurrency = value;
                                if (addFundCtrl.is_crypto == false) {
                                  addFundCtrl.getSelectedCurrencyData(value);
                                }
                                addFundCtrl.update();
                              },
                              hint: storedLanguage['Select currency'] ??
                                  "Select currency",
                              selectedStyle: context.t.displayMedium,
                              bgColor: Get.isDarkMode
                                  ? AppColors.darkBgColor
                                  : AppColors.fillColorColor,
                            ),
                          ),
                          if (addFundCtrl.is_crypto == true) ...[
                            VSpace(20.h),
                            Text(
                              storedLanguage['Pay to crypto currency'] ??
                                  "Pay to crypto currency",
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
                                items: addFundCtrl.supportedCurrencyList
                                    .map((e) => e)
                                    .toList(),
                                selectedValue:
                                    addFundCtrl.selectedCryptoCurrency,
                                onChanged: (value) async {
                                  addFundCtrl.selectedCryptoCurrency = value;
                                  addFundCtrl.amountCtrl.clear();
                                  addFundCtrl.getSelectedCurrencyData(value);
                                  addFundCtrl.update();
                                },
                                hint:
                                    storedLanguage['Select crypto currency'] ??
                                        "Select crypto currency",
                                selectedStyle: context.t.displayMedium,
                                bgColor: Get.isDarkMode
                                    ? AppColors.darkBgColor
                                    : AppColors.fillColorColor,
                              ),
                            ),
                          ],
                          VSpace(20.h),
                          addFundCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : Text(storedLanguage['Amount'] ?? 'Amount',
                                  style: context.t.bodyMedium),
                          addFundCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : VSpace(12.h),
                          addFundCtrl.selectedCurrency == null
                              ? const SizedBox()
                              : CustomTextField(
                                  focusNode: node,
                                  isOnlyBorderColor: true,
                                  isSuffixIcon: addFundCtrl.amountValue.isEmpty
                                      ? false
                                      : true,
                                  suffixIcon:
                                      addFundCtrl.isFollowedTransactionLimit
                                          ? "check"
                                          : "warning",
                                  suffixIconSize:
                                      addFundCtrl.isFollowedTransactionLimit
                                          ? 20.h
                                          : 15.h,
                                  suffixIconColor:
                                      addFundCtrl.isFollowedTransactionLimit
                                          ? AppColors.greenColor
                                          : AppColors.redColor,
                                  contentPadding: EdgeInsets.only(left: 20.w),
                                  hintext: storedLanguage['Enter Amount'] ??
                                      'Enter Amount',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(
                                        addFundCtrl.maxAmount.length),
                                  ],
                                  controller: addFundCtrl.amountCtrl,
                                  onChanged: addFundCtrl.onChangedAmount,
                                ),
                          VSpace(16.h),
                          if (addFundCtrl.amountValue.isNotEmpty &&
                              addFundCtrl.selectedCurrency != null)
                            Container(
                              height: 130.h,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: Dimensions.kBorderRadius,
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.black60
                                        : AppColors.black30,
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
                                              "Amount In ${addFundCtrl.selectedCurrency}",
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
                                                "${addFundCtrl.amountValue} ${addFundCtrl.selectedCurrency}",
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
                                          ? AppColors.black60
                                          : AppColors.black30,
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
                                                "${addFundCtrl.charge} ${addFundCtrl.selectedCurrency}",
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
                                          ? AppColors.black60
                                          : AppColors.black30,
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
                                                "${double.parse(addFundCtrl.amountValue) + double.parse(addFundCtrl.charge)} ${addFundCtrl.selectedCurrency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .greenColor,
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
                              isLoading: addFundCtrl.isLoadingPaymentSheet
                                  ? true
                                  : false,
                              onTap: addFundCtrl.isLoadingPaymentSheet
                                  ? null
                                  : () async {
                                      Helpers.hideKeyboard();
                                      if (addFundCtrl.amountCtrl.text.isEmpty) {
                                        Helpers.showSnackBar(
                                            msg: "Amount field is required");
                                      } else {
                                        if (double.parse(
                                                addFundCtrl.amountCtrl.text) <
                                            double.parse(
                                                addFundCtrl.minAmount)) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "Please follow the transaction limit");
                                        } else if (addFundCtrl
                                                .isFollowedTransactionLimit ==
                                            false) {
                                          Helpers.showSnackBar(
                                              msg:
                                                  "minimum payment ${addFundCtrl.minAmount} and maximum payment limit ${addFundCtrl.maxAmount}");
                                        } else {
                                          if (addFundCtrl.wallet_id.isEmpty) {
                                            Helpers.showSnackBar(
                                                msg:
                                                    "Please select your wallet");
                                          } else if (addFundCtrl.is_crypto ==
                                                  true &&
                                              (addFundCtrl
                                                      .selectedCryptoCurrency
                                                      .isEmpty ||
                                                  addFundCtrl
                                                          .selectedCryptoCurrency ==
                                                      null)) {
                                            Helpers.showSnackBar(
                                                msg:
                                                    "Please select crypto currency");
                                          } else {
                                            await addFundCtrl.paymentRequest(
                                              context: context,
                                              fields: {
                                                "amount":
                                                    MoneyTransferController.to
                                                        .amountInSelectedCurr,
                                                "gateway_id": addFundCtrl
                                                    .gatewayId
                                                    .toString(),
                                                "supported_currency":
                                                    addFundCtrl
                                                        .selectedCurrency,
                                                "wallet_id":
                                                    addFundCtrl.wallet_id,
                                                if (addFundCtrl.is_crypto ==
                                                    true)
                                                  "supported_crypto_currency":
                                                      addFundCtrl
                                                          .selectedCryptoCurrency,
                                              },
                                            );
                                          }
                                        }
                                      }
                                    },
                              text: storedLanguage['Confirm & Next'] ??
                                  "Confirm & Next",
                            ),
                          ),
                          VSpace(node.hasFocus ? 150.h : 50.h),
                        ],
                      ),
                    ),
                  VSpace(32.h),
                ],
              ));
        });
      },
    );
  }
}
