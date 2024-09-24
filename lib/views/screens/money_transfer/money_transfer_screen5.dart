import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/add_fund_controller.dart';
import 'package:waiz/controllers/money_transfer_controller.dart';
import 'package:waiz/controllers/wallet_controller.dart';
import 'package:waiz/routes/page_index.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';

class MoneyTransferScreen5 extends StatefulWidget {
  final String? recipientName;
  MoneyTransferScreen5({super.key, this.recipientName = ""});

  @override
  State<MoneyTransferScreen5> createState() => _MoneyTransferScreen5State();
}

class _MoneyTransferScreen5State extends State<MoneyTransferScreen5> {
  bool isTappedOnQuestionMark = false;
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.put(MoneyTransferController(), permanent: true);
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyTransferController>(builder: (_) {
      return GetBuilder<AddFundController>(builder: (payoutCtrl) {
        if (payoutCtrl.isLoading || _.isTransferPayLoading) {
          return Scaffold(
              appBar: CustomAppBar(
                  title: storedLanguage['Money Transfer'] ?? "Money Transfer"),
              body: Helpers.appLoader());
        }
        if (payoutCtrl.paymentGatewayList.isEmpty) {
          return Scaffold(
            appBar: CustomAppBar(
                title: storedLanguage['Money Transfer'] ?? "Money Transfer"),
            body: Helpers.notFound(top: 0),
          );
        }
        return GestureDetector(
          onTap: () {
            isTappedOnQuestionMark = false;
            setState(() {});
          },
          child: Scaffold(
            backgroundColor: Get.isDarkMode
                ? AppColors.darkBgColor
                : AppColors.fillColorColor,
            appBar: CustomAppBar(
              title: storedLanguage['Money Transfer'] ?? "Money Transfer",
            ),
            body: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(30.h),
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Text(storedLanguage['Amount'] ?? "Amount",
                                style: t.bodyMedium)),
                        Text(storedLanguage['Recipient'] ?? "Recipient",
                            style: t.bodyMedium),
                        Text(storedLanguage['Review'] ?? "Review",
                            style: t.bodyMedium),
                        Text(storedLanguage['Pay'] ?? "Pay",
                            style: t.bodyMedium),
                      ],
                    );
                  }),
                  VSpace(10.h),
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Row(
                      children: [
                        buildWidget(
                          constraints,
                          AppColors.mainColor,
                        ),
                        buildWidget(constraints, AppColors.mainColor,
                            isOnlyCircleColor: true,
                            circleColor: AppColors.mainColor),
                        buildWidget(constraints, AppColors.mainColor,
                            isOnlyCircleColor: true,
                            circleColor: AppColors.mainColor),
                        Container(
                          height: 18.h,
                          width: 18.h,
                          padding: EdgeInsets.all(3.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.mainColor),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  VSpace(32.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? AppColors.darkCardColor
                          : AppColors.whiteColor,
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            storedLanguage['Transfer details'] ??
                                "Transfer details",
                            style: context.t.bodyMedium),
                        VSpace(12.h),
                        Container(
                          height: .2,
                          width: double.maxFinite,
                          color: Get.isDarkMode
                              ? AppColors.mainColor
                              : AppColors.black20,
                        ),
                        VSpace(20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                storedLanguage['You send exactly'] ??
                                    "You send exactly",
                                style: context.t.displayMedium?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.textFieldHintColor
                                        : AppColors.paragraphColor)),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("${_.send_amount}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.displayMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                            )),
                          ],
                        ),
                        VSpace(24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                storedLanguage['Transfer fees (included)'] ??
                                    "Transfer fees (included)",
                                style: context.t.displayMedium?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.textFieldHintColor
                                        : AppColors.paragraphColor)),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("${_.transfer_fee}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.displayMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                            )),
                          ],
                        ),
                        VSpace(24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(storedLanguage['Send Total'] ?? "Send Total",
                                style: context.t.displayMedium?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.textFieldHintColor
                                        : AppColors.paragraphColor)),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(_.send_total,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.displayMedium
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                            )),
                          ],
                        ),
                        VSpace(24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${widget.recipientName} will get",
                                style: context.t.displayMedium?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.textFieldHintColor
                                        : AppColors.paragraphColor)),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("${_.receiver_amount}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.greenColor)),
                            )),
                          ],
                        ),
                        if (_.r_user_id == null) VSpace(24.h),
                        if (_.r_user_id == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(storedLanguage['Service'] ?? "Service",
                                  style: context.t.displayMedium?.copyWith(
                                      color: Get.isDarkMode
                                          ? AppColors.textFieldHintColor
                                          : AppColors.paragraphColor)),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.centerRight,
                                child: Text("${_.serviceName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.displayMedium?.copyWith(
                                        fontWeight: FontWeight.w600)),
                              )),
                            ],
                          ),
                        VSpace(24.h),
                        if (payoutCtrl.selectedGatewayIndex != -1) ...[
                          Row(
                            children: [
                              Text(
                                payoutCtrl.is_crypto == true
                                    ? storedLanguage[
                                            'Select Crypto Currency'] ??
                                        "Select Crypto Currency"
                                    : payoutCtrl.isPaymentTypeIsWallet
                                        ? storedLanguage[
                                                'Select Your Wallet'] ??
                                            "Select Your Wallet"
                                        : storedLanguage[
                                                'Select Gateway Currency'] ??
                                            "Select Gateway Currency",
                                style: context.t.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              HSpace(8.w),
                              Tooltip(
                                preferBelow: false,
                                message:
                                    "Enter the amount & choose the currency you'd like to transfer.",
                                child: InkResponse(
                                  onTap: () {
                                    isTappedOnQuestionMark = true;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppThemes.getIconBlackColor(),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.question_mark,
                                        size: 14.h,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          VSpace(12.h),
                          Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: isTappedOnQuestionMark
                                        ? AppColors.greenColor
                                        : AppThemes.getSliderInactiveColor()),
                                borderRadius: Dimensions.kBorderRadius,
                              ),
                              child: AppCustomDropDown(
                                height: 50.h,
                                width: double.infinity,
                                items: payoutCtrl.isPaymentTypeIsWallet
                                    ? WalletController.to.walletDataList
                                        .map((e) => e.currencyAndCountryName)
                                        .toList()
                                    : payoutCtrl.supportedCurrencyList,
                                // items: payoutCtrl.is_crypto == true
                                //     ? ["USD"]
                                //     : payoutCtrl.isPaymentTypeIsWallet
                                //         ? WalletController.to.walletDataList
                                //             .map(
                                //                 (e) => e.currencyAndCountryName)
                                //             .toList()
                                //         : payoutCtrl.supportedCurrencyList,
                                selectedValue: payoutCtrl.selectedCurrency,
                                onChanged: (value) async {
                                  Helpers.hideKeyboard();
                                  payoutCtrl.selectedCurrency = value;
                                  // if the payment type is wallet
                                  if (payoutCtrl.isPaymentTypeIsWallet) {
                                    // get the currency rate for wallet payment
                                    payoutCtrl.wallet_id = WalletController
                                        .to.walletDataList
                                        .firstWhere((e) =>
                                            e.currencyAndCountryName == value)
                                        .id
                                        .toString();
                                  }
                                  // if the payment type is not wallet
                                  if (!payoutCtrl.isPaymentTypeIsWallet &&
                                      payoutCtrl.is_crypto == false) {
                                    payoutCtrl.getSelectedCurrencyData(value);
                                  }
                                  _.getCurrencyRate(fields: {
                                    "selectedCurrency":
                                        payoutCtrl.isPaymentTypeIsWallet
                                            ? value.toString().split(" ").first
                                            : value.toString(),
                                    "senderCurrency": _.senderCurrency,
                                  });
                                  ;
                                  payoutCtrl.update();
                                },
                                hint: storedLanguage['Select currency'] ??
                                    "Select currency",
                                selectedStyle: context.t.displayMedium,
                                bgColor: Get.isDarkMode
                                    ? AppColors.darkBgColor
                                    : AppColors.fillColorColor,
                              )),
                          VSpace(24.h),
                          if (payoutCtrl.selectedCurrency != null)
                            double.parse(_.amountInSelectedCurr) <= 0.00
                                ? Container(
                                    height: 50.h,
                                    width: double.maxFinite,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 17.w),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppThemes
                                              .getSliderInactiveColor()),
                                      borderRadius: Dimensions.kBorderRadius,
                                    ),
                                    child: Text(
                                      "Currency not found or rate is 0", // if the currency rate is 0 then calculated amount will be 0;
                                      style: t.displayMedium
                                          ?.copyWith(color: AppColors.redColor),
                                    ),
                                  )
                                : Container(
                                    width: double.maxFinite,
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: Dimensions.kBorderRadius,
                                      border: Border.all(
                                          color: AppThemes
                                              .getSliderInactiveColor()),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Amount In ${payoutCtrl.isPaymentTypeIsWallet ? payoutCtrl.selectedCurrency.split(" ").first : payoutCtrl.selectedCurrency}",
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
                                                "${_.amountInSelectedCurr} ${payoutCtrl.isPaymentTypeIsWallet ? payoutCtrl.selectedCurrency.split(" ").first : payoutCtrl.selectedCurrency}",
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
                                  ),
                        ],
                      ],
                    ),
                  ),
                  if (payoutCtrl.selectedCurrency != null) VSpace(32.h),
                  if (payoutCtrl.selectedCurrency != null)
                    double.parse(_.amountInSelectedCurr) <= 0.00
                        ? const SizedBox()
                        : Material(
                            color: Colors.transparent,
                            child: AppButton(
                              isLoading: payoutCtrl.isLoadingPaymentSheet
                                  ? true
                                  : false,
                              onTap: payoutCtrl.isLoadingPaymentSheet
                                  ? null
                                  : () async {
                                      await _.transferPost(
                                          context: context,
                                          fields: {
                                            "trx_id": _.transferStore_trxId,
                                            "gateway_id":
                                                payoutCtrl.gatewayId.toString(),
                                            "currency": payoutCtrl
                                                    .isPaymentTypeIsWallet
                                                ? payoutCtrl.selectedCurrency
                                                    .toString()
                                                    .split(" ")
                                                    .first
                                                : payoutCtrl.selectedCurrency,
                                            if (payoutCtrl
                                                .isPaymentTypeIsWallet)
                                              "wallet_id": payoutCtrl.wallet_id,
                                          });
                                    },
                              text: storedLanguage['Confirm & Continue'] ??
                                  "Confirm & Continue",
                            ),
                          ),
                  VSpace(24.h),
                  Material(
                    color: Colors.transparent,
                    child: AppButton(
                      bgColor: AppColors.redColor,
                      style: t.bodyLarge?.copyWith(color: AppColors.whiteColor),
                      onTap: () {
                        Get.offAllNamed(RoutesName.bottomNavBar);
                      },
                      text: storedLanguage['Cancel This Transfer'] ??
                          "Cancel This Transfer",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
  }

  Row buildWidget(BoxConstraints constraints, Color color,
      {bool? isOnlyCircleColor = false, Color? circleColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 18.h,
          width: 18.h,
          padding: EdgeInsets.all(3.h),
          decoration: BoxDecoration(
            border: Border.all(
                color: isOnlyCircleColor == true ? circleColor! : color),
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isOnlyCircleColor == true ? circleColor : color,
              shape: BoxShape.circle,
            ),
          ),
        ),
        ...List.generate(
            (constraints.maxWidth / 12.3).floor(),
            (index) => Container(
                  height: 3.h,
                  width: index == 0 ||
                          index == (constraints.maxWidth / 25).floor() - 1
                      ? 1
                      : (constraints.maxWidth / 100),
                  color: color,
                )),
      ],
    );
  }
}
