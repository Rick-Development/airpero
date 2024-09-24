import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/money_transfer_controller.dart';
import 'package:waiz/routes/page_index.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/add_fund_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class MoneyTransferScreen3 extends StatelessWidget {
  final bool? isWaizUser;
  const MoneyTransferScreen3({super.key, this.isWaizUser = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyTransferController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          title: storedLanguage['Money Transfer'] ?? "Money Transfer",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: _.isLoading
                ? SizedBox(
                    height: Dimensions.screenHeight,
                    width: Dimensions.screenWidth,
                    child: Helpers.appLoader(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VSpace(30.h),
                      LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                child: Text(
                                    storedLanguage['Amount'] ?? "Amount",
                                    style: t.bodyMedium)),
                            Text(storedLanguage['Recipient'] ?? "Recipient",
                                style: t.bodyMedium),
                            Text(storedLanguage['Review'] ?? "Review",
                                style: t.bodyMedium),
                            Text(storedLanguage['Pay'] ?? "Pay",
                                style: t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
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
                            buildWidget(
                                constraints,
                                Get.isDarkMode
                                    ? AppColors.black60
                                    : AppColors.sliderInActiveColor,
                                isOnlyCircleColor: true,
                                circleColor: AppColors.mainColor),
                            Container(
                              height: 18.h,
                              width: 18.h,
                              padding: EdgeInsets.all(3.h),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.isDarkMode
                                        ? AppColors.black60
                                        : AppColors.sliderInActiveColor),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? AppColors.black60
                                      : AppColors.sliderInActiveColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      VSpace(40.h),
                      Center(
                          child: Text(
                              storedLanguage[
                                      'Review Details of Your Transfer'] ??
                                  "Review Details of Your Transfer",
                              style: t.bodyLarge)),
                      VSpace(32.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 24.h),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Transfer details'] ??
                                        "Transfer details",
                                    style: context.t.displayMedium),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                        RoutesName.moneyTransferScreen1);
                                  },
                                  child: Container(
                                    width: 76.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: AppThemes.getSliderInactiveColor(),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "$rootImageDir/edit.png",
                                          height: 14.h,
                                          width: 14.h,
                                          color: AppThemes.getIconBlackColor(),
                                        ),
                                        HSpace(8.w),
                                        Text(storedLanguage['Edit'] ?? "Edit",
                                            style: context.t.displayMedium),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(12.h),
                            Container(
                              height: .2,
                              width: double.maxFinite,
                              color: Get.isDarkMode
                                  ? AppColors.black60
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
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${_.sendCtrl.text} ${_.senderInitialSelectedCurrency}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                            VSpace(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Transfer Fee'] ??
                                        "Transfer Fee",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${_.transferFeeInLocal} ${_.senderInitialSelectedCurrency}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                            VSpace(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Send Total'] ??
                                        "Send Total",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${double.parse(_.sendVal) - double.parse(_.transferFeeInLocal)} ${_.senderInitialSelectedCurrency}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                            VSpace(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Recipient will Get'] ??
                                        "Recipient will Get",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      "${_.amountWillConvert} ${_.receiverInitialSelectedCurrency}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      VSpace(20.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 24.h),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Recipient details'] ??
                                        "Recipient details",
                                    style: context.t.displayMedium),
                                GestureDetector(
                                  onTap: () {
                                    _.isFromMoneyTransferPage = true;
                                    Get.to(() => RecipientsScreen(
                                        countryName: _.countryName,
                                        isFromMoneyTransferPage: true));
                                  },
                                  child: Container(
                                    width: 103.w,
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: AppThemes.getSliderInactiveColor(),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "$rootImageDir/edit.png",
                                          height: 14.h,
                                          width: 14.h,
                                          color: AppThemes.getIconBlackColor(),
                                        ),
                                        HSpace(8.w),
                                        Text(
                                            storedLanguage['Change'] ??
                                                "Change",
                                            style: context.t.displayMedium),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(12.h),
                            Container(
                              height: .2,
                              width: double.maxFinite,
                              color: Get.isDarkMode
                                  ? AppColors.black60
                                  : AppColors.black20,
                            ),
                            VSpace(20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(storedLanguage['Name'] ?? "Name",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text("${_.name}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                            VSpace(24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(storedLanguage['Email'] ?? "Email",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text("${_.email}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                            if (isWaizUser == false) ...[
                              VSpace(24.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(storedLanguage['Send to'] ?? "Send to",
                                      style: context.t.displayMedium?.copyWith(
                                          color:
                                              AppThemes.getParagraphColor())),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text("${_.bank_name}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.bodyMedium),
                                  )),
                                ],
                              ),
                              VSpace(24.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(storedLanguage['Service'] ?? "Service",
                                      style: context.t.displayMedium?.copyWith(
                                          color:
                                              AppThemes.getParagraphColor())),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text("${_.service_name}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.bodyMedium),
                                  )),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      VSpace(32.h),
                      Material(
                        color: Colors.transparent,
                        child: AppButton(
                          isLoading: _.isPaymentStore ? true : false,
                          onTap: _.isPaymentStore
                              ? null
                              : () async {
                                  Get.delete<AddFundController>();
                                  Get.put(AddFundController());
                                  _.send_amount = _.sendCtrl.text +
                                      " ${_.senderInitialSelectedCurrency}";
                                  _.senderCurrency =
                                      _.senderInitialSelectedCurrency;
                                  _.transfer_fee = _.transferFeeInLocal +
                                      " ${_.senderInitialSelectedCurrency}";
                                  _.send_total = (double.parse(_.sendVal) -
                                              double.parse(
                                                  _.transferFeeInLocal))
                                          .toString() +
                                      " ${_.senderInitialSelectedCurrency}";
                                  _.receiver_amount = _.amountWillConvert
                                          .toString() +
                                      " ${_.receiverInitialSelectedCurrency}";
                                  _.serviceName = _.service_name;

                                  await _.transferPaymentStore(fields: {
                                    "recipient_id": _.recipientId.toString(),
                                    "send_currency_id":
                                        _.senderInitialSelectedId,
                                    "receive_currency_id":
                                        _.receiverInitialSelectedId,
                                    if (isWaizUser == false)
                                      "service_id": _.service_id,
                                    "send_amount": _.sendVal,
                                    "fees": _.transferFeeInLocal,
                                    "rate": _.getConvertedRate.toString(),
                                    "payable_amount":
                                        "${double.parse(_.sendVal) - double.parse(_.transferFeeInLocal)}",
                                    "sender_currency":
                                        _.senderInitialSelectedCurrency,
                                    "receiver_currency":
                                        _.receiverInitialSelectedCurrency,
                                    "recipient_get_amount": _.amountWillConvert,
                                    if (isWaizUser == true)
                                      "r_user_id": _.r_user_id.toString(),
                                  });
                                },
                          text: storedLanguage['Confirm  & Continue'] ??
                              "Confirm & Continue",
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
