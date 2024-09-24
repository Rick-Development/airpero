import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiz/views/widgets/search_dialog.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/fund_history_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class FundHistoryScreen extends StatelessWidget {
  const FundHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<FundHistoryController>(builder: (fundHistoryCtrl) {
      return Scaffold(
        appBar: buildAppbar(storedLanguage, context, fundHistoryCtrl),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: AppColors.mainColor,
          onRefresh: () async {
            fundHistoryCtrl.resetDataAfterSearching(
                isFromOnRefreshIndicator: true);
            await fundHistoryCtrl.geFundHistoryList(
                page: 1, transaction_id: '', gateway: '');
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: fundHistoryCtrl.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(20.h),
                  fundHistoryCtrl.isLoading
                      ? buildTransactionLoader(
                          itemCount: 20, isReverseColor: true)
                      : fundHistoryCtrl.fundHistoryList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: fundHistoryCtrl.fundHistoryList.length,
                              itemBuilder: (context, i) {
                                var data = fundHistoryCtrl.fundHistoryList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      appDialog(
                                          context: context,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkResponse(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(7.h),
                                                  decoration: BoxDecoration(
                                                    color: AppThemes
                                                        .getFillColor(),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 14.h,
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 40.h,
                                                width: 40.h,
                                                padding: EdgeInsets.all(8.h),
                                                decoration: BoxDecoration(
                                                  color: data.status
                                                              .toString() ==
                                                          "Requested"
                                                      ? AppColors.pendingColor
                                                          .withOpacity(.2)
                                                      : data.status
                                                                  .toString() ==
                                                              "Success"
                                                          ? AppColors.greenColor
                                                              .withOpacity(.2)
                                                          : AppColors.greenColor
                                                              .withOpacity(.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  data.status.toString() ==
                                                          "Requested"
                                                      ? '$rootImageDir/pending.png'
                                                      : data.status
                                                                  .toString() ==
                                                              "Success"
                                                          ? '$rootImageDir/approved.png'
                                                          : '$rootImageDir/rejected.png',
                                                  color: data.status
                                                              .toString() ==
                                                          "Requested"
                                                      ? AppColors.pendingColor
                                                      : data.status
                                                                  .toString() ==
                                                              "Success"
                                                          ? AppColors.greenColor
                                                          : AppColors.redColor,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Status'] ??
                                                    "Status",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.status ?? '',
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              InkWell(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  Clipboard.setData(
                                                      new ClipboardData(
                                                          text:
                                                              "${data.transactionId ?? ''}"));

                                                  Helpers.showSnackBar(
                                                      msg:
                                                          "Copied Successfully",
                                                      title: 'Success',
                                                      bgColor:
                                                          AppColors.greenColor);
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        storedLanguage[
                                                                'Transaction ID'] ??
                                                            "Transaction ID",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      Text(
                                                        data.transactionId ??
                                                            '',
                                                        style: t.bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Amount'] ??
                                                    "Amount",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.amount.toString() +
                                                    " ${data.paymentMethodCurrency}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Charge'] ??
                                                    "Charge",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.charge.toString() +
                                                    " ${data.paymentMethodCurrency}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Gateway'] ??
                                                    "Gateway",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.gateway ?? '',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage[
                                                        'Date and Time'] ??
                                                    "Date and Time",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.createdAt.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                            ],
                                          ));
                                    },
                                    child: Ink(
                                      width: double.maxFinite,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 48.h,
                                            height: 48.h,
                                            padding: data.status
                                                    .toString()
                                                    .contains("Success")
                                                ? EdgeInsets.zero
                                                : EdgeInsets.all(10.h),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: data.status
                                                      .toString()
                                                      .contains("Pending")
                                                  ? AppColors.pendingColor
                                                      .withOpacity(.1)
                                                  : data.status
                                                          .toString()
                                                          .contains("Success")
                                                      ? Colors.transparent
                                                      : data.status
                                                              .toString()
                                                              .contains(
                                                                  "Requested")
                                                          ? AppColors
                                                              .pendingColor
                                                              .withOpacity(.1)
                                                          : AppColors.redColor
                                                              .withOpacity(.1),
                                            ),
                                            child: Image.asset(
                                              data.status
                                                      .toString()
                                                      .contains("Pending")
                                                  ? "$rootImageDir/pending.png"
                                                  : data.status
                                                          .toString()
                                                          .contains("Success")
                                                      ? "$rootImageDir/approved2.png"
                                                      : data.status
                                                              .toString()
                                                              .contains(
                                                                  "Requested")
                                                          ? "$rootImageDir/pending.png"
                                                          : "$rootImageDir/rejected.png",
                                              color: data.status
                                                      .toString()
                                                      .contains("Pending")
                                                  ? AppColors.pendingColor
                                                  : data.status
                                                          .toString()
                                                          .contains("Success")
                                                      ? null
                                                      : AppColors.redColor,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            data.transactionId
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: t.bodyMedium,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                                "${data.amount} ${data.paymentMethodCurrency}",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: t
                                                                    .bodyMedium),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    VSpace(5.h),
                                                    Text(
                                                      "${data.gateway}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: t.displayMedium
                                                          ?.copyWith(
                                                        color: AppThemes
                                                            .getParagraphColor(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 15.h),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .black70
                                                                : AppColors
                                                                    .black20,
                                                            width: .2)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                  if (fundHistoryCtrl.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  CustomAppBar buildAppbar(storedLanguage, BuildContext context,
      FundHistoryController fundHistoryCtrl) {
    return CustomAppBar(
      title: storedLanguage['Fund Histroy'] ?? "Fund Histroy",
      actions: [
        IconButton(
            onPressed: () {
              searchDialog(
                  isDateTimeField: false,
                  context: context,
                  transaction: fundHistoryCtrl.transactionIdEditingCtrlr,
                  remark: fundHistoryCtrl.gatewayEditingCtrlr,
                  remarkHint: "Gateway",
                  onSearchPressed: () async {
                    fundHistoryCtrl.resetDataAfterSearching();

                    Get.back();

                    await fundHistoryCtrl
                        .geFundHistoryList(
                          page: 1,
                          transaction_id:
                              fundHistoryCtrl.transactionIdEditingCtrlr.text,
                          gateway: fundHistoryCtrl.gatewayEditingCtrlr.text,
                        )
                        .then((value) {});
                  });
            },
            icon: Container(
              width: 34.h,
              height: 34.h,
              padding: EdgeInsets.all(10.5.h),
              decoration: BoxDecoration(
                color:
                    Get.isDarkMode ? AppColors.darkBgColor : AppColors.black5,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.mainColor, width: .2),
              ),
              child: Image.asset(
                "$rootImageDir/filter_3.png",
                height: 32.h,
                width: 32.h,
                color: Get.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
                fit: BoxFit.fitHeight,
              ),
            )),
        HSpace(20.w),
      ],
    );
  }
}
