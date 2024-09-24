import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';

class WalletExchangeScreen extends StatelessWidget {
  const WalletExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    WalletController.to.textEditingController1.clear();
    WalletController.to.textEditingController2.clear();
    return GetBuilder<WalletController>(builder: (walletCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
            title: storedLanguage['Wallet Exchange'] ?? "Wallet Exchange"),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(30.h),
                Text(
                    "Exchange Money From Your ${walletCtrl.walletCurrency} Wallet",
                    style: t.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                VSpace(7.h),
                Text(
                    storedLanguage[
                            'Fast and reliable international money transfer app.'] ??
                        "Fast and reliable international money transfer app.",
                    style: t.bodySmall),
                VSpace(27.h),
                Container(
                  height: .3,
                  width: double.maxFinite,
                  color: Get.isDarkMode ? AppColors.black60 : AppColors.black20,
                ),
                VSpace(27.h),
                Wrap(
                  children: [
                    Text("Your Account Balance is ", style: t.bodyMedium),
                    Text(
                        "${double.parse(walletCtrl.walletBalance).toStringAsFixed(2)} ${walletCtrl.walletCurrency}",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                VSpace(30.h),
                Text(storedLanguage['Enter Amount You Want To Exchange'] ??"Enter Amount You Want To Exchange",
                    style: t.displayMedium),
                VSpace(15.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.black60
                            : AppColors.black20,
                        width: .4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Amount is required';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (v) {
                            walletCtrl.getExchangeAmount(v);
                          },
                          controller: walletCtrl.textEditingController1,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'),
                            ),
                          ],
                          style: t.displayMedium,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.w),
                            hintText: "0.00",
                            hintStyle: t.bodyLarge
                                ?.copyWith(color: AppColors.textFieldHintColor),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            height: 48.h,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Get.isDarkMode
                                          ? AppColors.black60
                                          : AppColors.black20,
                                      width: .4)),
                            ),
                            child: Row(
                              children: [
                                HSpace(10.w),
                                ClipOval(
                                    child: CachedNetworkImage(
                                  imageUrl:
                                      walletCtrl.walletCountryImage.toString(),
                                  fit: BoxFit.cover,
                                  height: 20.h,
                                  width: 20.h,
                                )),
                                HSpace(15.w),
                                Text("${walletCtrl.walletCurrency}",
                                    style: context.t.bodyMedium),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                if (double.parse(walletCtrl.textEditingCtrl1Val.toString()) >
                    double.parse(walletCtrl.walletBalance))
                  VSpace(10.h),
                if (double.parse(walletCtrl.textEditingCtrl1Val.toString()) >
                    double.parse(walletCtrl.walletBalance))
                  Text(storedLanguage['Insufficient Balance']??"Insufficient Balance",
                      style:
                          t.displayMedium?.copyWith(color: AppColors.redColor)),
                VSpace(20.h),
                Text(storedLanguage['Receive Wallet Amount'] ??"Receive Wallet Amount", style: t.displayMedium),
                VSpace(15.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.black60
                            : AppColors.black20,
                        width: .4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Amount is required';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (v) {
                            walletCtrl.getReversedExchangeAmount(v);
                          },
                          controller: walletCtrl.textEditingController2,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*$'),
                            ),
                          ],
                          style: t.displayMedium,
                          decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.w),
                            hintText: "0.00",
                            hintStyle: t.bodyLarge
                                ?.copyWith(color: AppColors.textFieldHintColor),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Get.isDarkMode
                                        ? AppColors.black60
                                        : AppColors.black20,
                                    width: .4)),
                          ),
                          child: Row(
                            children: [
                              HSpace(10.w),
                              ClipOval(
                                  child: CachedNetworkImage(
                                imageUrl: walletCtrl
                                    .selectedWalletCurrCountryImage
                                    .toString(),
                                fit: BoxFit.cover,
                                height: 20.h,
                                width: 20.h,
                              )),
                              Flexible(
                                child: AppCustomDropDown(
                                  height: 50.h,
                                  width: double.infinity,
                                  items: walletCtrl.walletCurrencyList
                                      .map((e) => e.currencyCode)
                                      .toList(),
                                  selectedValue: walletCtrl.selectedWalletCurr,
                                  onChanged: walletCtrl.receiveDropDownOnchange,
                                  hint: storedLanguage['Select currency'] ??
                                      "Select currency",
                                  selectedStyle: context.t.bodyMedium,
                                  bgColor: AppThemes.getDarkCardColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                VSpace(50.h),
                GetBuilder<MoneyTransferController>(builder: (_) {
                  return AppButton(
                    text:storedLanguage['Continue'] ?? "Continue",
                    bgColor: MoneyTransferController.to.isGettingRate
                        ? AppColors.sliderInActiveColor
                        : Get.isDarkMode
                            ? AppColors.mainColor
                            : AppColors.blackColor,
                    isLoading: walletCtrl.isLoading ? true : false,
                    onTap: MoneyTransferController.to.isGettingRate ||
                            walletCtrl.isLoading
                        ? null
                        : () async {
                            if (walletCtrl
                                .textEditingController1.text.isEmpty) {
                              Helpers.showSnackBar(
                                  msg: "Send Amount should not be empty!");
                            } else if (walletCtrl
                                .textEditingController2.text.isEmpty) {
                              Helpers.showSnackBar(
                                  msg: "Receive Amount should not be empty!");
                            } else {
                              if (double.parse(walletCtrl.textEditingCtrl1Val
                                      .toString()) >
                                  double.parse(walletCtrl.walletBalance)) {
                                Helpers.showSnackBar(
                                    msg: "Insufficient Balance");
                              } else {
                                walletCtrl.isFromWalletExchangePage = true;
                                Get.toNamed(RoutesName.walletGetOtpScreen);
                              }
                            }
                          },
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
