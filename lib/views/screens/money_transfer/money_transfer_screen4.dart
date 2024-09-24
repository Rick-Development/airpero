import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/add_fund_controller.dart';
import 'package:waiz/controllers/money_transfer_controller.dart';
import 'package:waiz/routes/page_index.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_textfield.dart';

class MoneyTransferScreen4 extends StatefulWidget {
  final String? recipientName;
  MoneyTransferScreen4({super.key, this.recipientName = ""});

  @override
  State<MoneyTransferScreen4> createState() => _MoneyTransferScreen4State();
}

class _MoneyTransferScreen4State extends State<MoneyTransferScreen4> {
  @override
  Widget build(BuildContext context) {
    Get.put(MoneyTransferController(), permanent: true);
    TextTheme t = Theme.of(context).textTheme;
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
        return Scaffold(
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
                      Text(storedLanguage['Pay'] ?? "Pay", style: t.bodyMedium),
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
                Center(
                    child: Text(
                        storedLanguage['How Would You Like To Pay?'] ??
                            "How Would You Like To Pay?",
                        style: context.t.bodyLarge)),
                VSpace(24.h),
                CustomTextField(
                  hintext: storedLanguage['Search Gateway'] ?? "Search Gateway",
                  controller: payoutCtrl.gatewaySearchCtrl,
                  isSuffixIcon: true,
                  isSuffixBgColor: true,
                  isOnlyBorderColor: true,
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
                                payoutCtrl.isLoadingDetails = true;
                                payoutCtrl.update();
                                payoutCtrl.selectedGatewayIndex = i;
                                await payoutCtrl.getGatewayData(i);
                                await payoutCtrl.getSelectedGatewayData(i);
                                payoutCtrl.isLoadingDetails = false;
                                if (payoutCtrl.gatewayName == "Wallet") {
                                  Get.toNamed(RoutesName.walletGetOtpScreen);
                                } else {
                                  Get.to(() => MoneyTransferScreen5(
                                      recipientName:
                                          MoneyTransferController.to.name));
                                }
                                payoutCtrl.update();
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
                                          image: data.image.toString().contains(
                                                  "wallet_payment.png")
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
                                    payoutCtrl.isLoadingDetails == true &&
                                            payoutCtrl.selectedGatewayIndex == i
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                width: 15.h,
                                                height: 15.h,
                                                child: Helpers.appLoader()),
                                          )
                                        : Container(
                                            width: 20.h,
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              color: payoutCtrl
                                                          .selectedGatewayIndex ==
                                                      i
                                                  ? AppColors.mainColor
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: payoutCtrl
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
                                                color: payoutCtrl
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
