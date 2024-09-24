import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/mediaquery_extension.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import 'money_transfer_screen4.dart';

class MoneyTransferDetailsScreen extends StatelessWidget {
  const MoneyTransferDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyTransferController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          title: storedLanguage['Money Transfer Details'] ??
              "Money Transfer Details",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: _.isTransferPayLoading
                ? SizedBox(
                    height: Dimensions.screenHeight,
                    width: Dimensions.screenWidth,
                    child: Helpers.appLoader(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VSpace(30.h),
                      if (_.transferDetails != null &&
                          _.transferDetails!.status.toString() == "Rejected")
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                                color: AppColors.redColor.withOpacity(.1),
                                border: Border.all(
                                    color: AppColors.redColor, width: .4),
                                borderRadius: BorderRadius.circular(6.r)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "You Have Rejected for this Transfer Request",
                                  style: context.t.bodySmall?.copyWith(
                                    color: AppColors.redColor,
                                  ),
                                ),
                                InkResponse(
                                  onTap: () {
                                    showDialog<void>(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return GetBuilder<CardController>(
                                            builder: (profileCtrl) {
                                          return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 60.h,
                                                  horizontal: 30.w),
                                              child: Material(
                                                  // Wrap with Material
                                                  elevation: 0,
                                                  type:
                                                      MaterialType.transparency,
                                                  child: Center(
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                        Container(
                                                          width: context
                                                              .mQuery.width,
                                                          padding: Dimensions
                                                              .kDefaultPadding,
                                                          decoration: BoxDecoration(
                                                              color: AppThemes
                                                                  .getDarkBgColor(),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          32.r)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              VSpace(20.h),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                   storedLanguage['Rejected reason'] ??   "Rejected reason",
                                                                      style: t
                                                                          .displayMedium),
                                                                  InkResponse(
                                                                    onTap: () {
                                                                      Get.back();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets
                                                                          .all(7
                                                                              .h),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: AppThemes
                                                                            .getFillColor(),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        size: 14
                                                                            .h,
                                                                        color: Get.isDarkMode
                                                                            ? AppColors.whiteColor
                                                                            : AppColors.blackColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              VSpace(30.h),
                                                              Text(
                                                                  _.transferDetails!
                                                                          .rejectReason ??
                                                                      "",
                                                                  style: t
                                                                      .displayMedium),
                                                              VSpace(24.h),
                                                              if (_.transferDetails !=
                                                                      null &&
                                                                  _.transferDetails!
                                                                          .resubmitted ==
                                                                      true)
                                                                GetBuilder<
                                                                        CardController>(
                                                                    builder:
                                                                        (cardCtrl) {
                                                                  return Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child: AppButton(
                                                                        isLoading: cardCtrl.isBlocking ? true : false,
                                                                        onTap: cardCtrl.isBlocking
                                                                            ? null
                                                                            : () async {
                                                                                Get.back();
                                                                                Get.find<MoneyTransferController>().getTransferPay(uuid: _.transferDetails!.uuid.toString());
                                                                                Get.to(() => MoneyTransferScreen4(recipientName: _.transferDetails!.recipientDetails == null ? "" : _.transferDetails!.recipientDetails?.name.split(" ")[0]));
                                                                              },
                                                                        text: storedLanguage['Resubmit Now'] ?? 'Resubmit Now'),
                                                                  );
                                                                }),
                                                              VSpace(20.h),
                                                            ],
                                                          ),
                                                        )
                                                      ]))));
                                        });
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.info,
                                    size: 22.h,
                                    color: AppColors.redColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.darkCardColor
                              : AppColors.whiteColor,
                          borderRadius: Dimensions.kBorderRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44.h,
                              height: 44.h,
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _.transferDetails!.status
                                        .toString()
                                        .contains("Initiate")
                                    ? AppColors.pendingColor.withOpacity(.1)
                                    : _.transferDetails!.status
                                            .toString()
                                            .contains("Completed")
                                        ? AppColors.greenColor.withOpacity(.1)
                                        : _.transferDetails!.status
                                                .toString()
                                                .contains("Under Review")
                                            ? Colors.blue.withOpacity(.1)
                                            : AppColors.redColor
                                                .withOpacity(.1),
                              ),
                              child: Image.asset(
                                _.transferDetails!.status
                                        .toString()
                                        .contains("Initiate")
                                    ? "$rootImageDir/initiated.png"
                                    : _.transferDetails!.status
                                            .toString()
                                            .contains("Completed")
                                        ? "$rootImageDir/approved.png"
                                        : _.transferDetails!.status
                                                .toString()
                                                .contains("Under Review")
                                            ? "$rootImageDir/review.png"
                                            : "$rootImageDir/rejected.png",
                                color: _.transferDetails!.status
                                        .toString()
                                        .contains("Initiate")
                                    ? AppColors.pendingColor
                                    : _.transferDetails!.status
                                            .toString()
                                            .contains("Completed")
                                        ? AppColors.greenColor
                                        : _.transferDetails!.status
                                                .toString()
                                                .contains("Under Review")
                                            ? Colors.blue
                                            : AppColors.redColor,
                              ),
                            ),
                            HSpace(15.w),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      _.transferDetails == null
                                          ? ""
                                          : _.transferDetails!.recipientDetails!
                                              .name
                                              .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.bodyMedium),
                                  VSpace(3.h),
                                  Text(
                                    "Sent",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodySmall?.copyWith(
                                      color: AppThemes.getParagraphColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _.transferDetails == null
                                        ? ""
                                        : double.parse(_.transferDetails!
                                                    .receiverAmount
                                                    .toString())
                                                .toStringAsFixed(2) +
                                            " ${_.transferDetails?.receiverCurrency?.code}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyMedium,
                                  ),
                                  Text(
                                    _.transferDetails == null
                                        ? ""
                                        : _.transferDetails!.sendAmount
                                                .toString() +
                                            " ${_.transferDetails?.senderCurrency?.code}",
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    style: t.bodySmall?.copyWith(
                                        color: _.transferDetails != null
                                            ? _.transferDetails!.status
                                                    .toString()
                                                    .contains("Completed")
                                                ? AppColors.greenColor
                                                : AppThemes.getParagraphColor()
                                            : AppThemes.getParagraphColor()),
                                  ),
                                  VSpace(3.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            Text(
                                storedLanguage['Transfer details'] ??
                                    "Transfer details",
                                style: context.t.bodyMedium),
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
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.sendAmount} ${_.transferDetails?.senderCurrency?.code}",
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
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.transferFee} ${_.transferDetails?.senderCurrency?.code}",
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
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.sendTotal} ${_.transferDetails?.senderCurrency?.code}",
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
                                    storedLanguage['Exchange Rate'] ??
                                        "Exchange Rate",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      _.transferDetails == null
                                          ? ""
                                          : "1 ${_.transferDetails?.senderCurrency?.code} = ${_.transferDetails?.exchangeRate} ${_.transferDetails?.receiverCurrency?.code}",
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
                                      _.transferDetails == null
                                          ? ""
                                          : "${double.parse(_.transferDetails!.receiverAmount.toString()).toStringAsFixed(2)} ${_.transferDetails?.receiverCurrency?.code}",
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
                                    storedLanguage['Transaction ID'] ??
                                        "Transaction ID",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: SelectableText(
                                      _.transferDetails == null
                                          ? ""
                                          : "#${_.transferDetails?.trxId}",
                                      maxLines: 1,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                                    storedLanguage['Recipient details'] ??
                                        "Recipient details",
                                    style: context.t.bodyMedium),
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
                                  child: Text(
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.recipientDetails?.name}",
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
                                  child: Text(
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.recipientDetails?.email}",
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
                                Text(storedLanguage['Send to'] ?? "Send to",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.recipientDetails?.sendTo}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium),
                                )),
                              ],
                            ),
                            VSpace(24.h),
                            ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _.bankInfoList.length,
                                itemBuilder: (context, i) {
                                  var data = _.bankInfoList[i];
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data.key,
                                              style: context.t.displayMedium
                                                  ?.copyWith(
                                                      color: AppThemes
                                                          .getParagraphColor())),
                                          Expanded(
                                              child: Container(
                                            alignment: Alignment.centerRight,
                                            child: Text(data.value,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.bodyMedium),
                                          )),
                                        ],
                                      ),
                                      VSpace(24.h),
                                    ],
                                  );
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Transfer Status'] ??
                                        "Transfer Status",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor())),
                                Expanded(
                                    child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      _.transferDetails == null
                                          ? ""
                                          : "${_.transferDetails?.status}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.t.bodyMedium?.copyWith(
                                        color: _.transferDetails != null
                                            ? _.transferDetails!.status
                                                    .toString()
                                                    .contains("Completed")
                                                ? AppColors.greenColor
                                                : _.transferDetails!.status
                                                        .toString()
                                                        .contains(
                                                            "Under Review")
                                                    ? Colors.blue
                                                    : AppColors.redColor
                                            : AppColors.mainColor,
                                      )),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      VSpace(20.h),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
