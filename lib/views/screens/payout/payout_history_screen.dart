import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiz/controllers/payout_controller.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/payout_history_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class PayoutHistoryScreen extends StatelessWidget {
  final bool? isFromPayoutPage;
  const PayoutHistoryScreen({super.key, this.isFromPayoutPage = false});

  @override
  Widget build(BuildContext context) {
    Get.put(PayoutController());
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<PayoutHistoryController>(builder: (payoutHistoryCtrl) {
      return GetBuilder<PayoutController>(builder: (payoutCtrl) {
        return PopScope(
          canPop: false,
          onPopInvoked: (onDid) {
            if (onDid) {
              return;
            }
            if (isFromPayoutPage == true) {
              Get.offAllNamed(RoutesName.bottomNavBar);
            } else {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: buildAppbar(storedLanguage, context, payoutHistoryCtrl),
            body: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              color: AppColors.mainColor,
              onRefresh: () async {
                payoutHistoryCtrl.resetDataAfterSearching(
                    isFromOnRefreshIndicator: true);
                await payoutHistoryCtrl.getPayoutHistoryList(
                    page: 1, transaction_id: '', start_date: '', end_date: '');
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: payoutHistoryCtrl.scrollController,
                child: Padding(
                  padding: Dimensions.kDefaultPadding,
                  child: Column(
                    children: [
                      VSpace(20.h),
                      payoutHistoryCtrl.isLoading
                          ? buildTransactionLoader(
                              itemCount: 20, isReverseColor: true)
                          : payoutHistoryCtrl.payoutHistoryList.isEmpty
                              ? Helpers.notFound()
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: payoutHistoryCtrl
                                      .payoutHistoryList.length,
                                  itemBuilder: (context, i) {
                                    var data =
                                        payoutHistoryCtrl.payoutHistoryList[i];
                                    return InkWell(
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
                                                    padding:
                                                        EdgeInsets.all(7.h),
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
                                                          : AppColors
                                                              .blackColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
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
                                                  style: t.bodyMedium?.copyWith(
                                                      color: data.status ==
                                                              "Generated"
                                                          ? AppColors
                                                              .secondaryColor
                                                          : data.status ==
                                                                  "Canceled"
                                                              ? AppColors
                                                                  .redColor
                                                              : data.status ==
                                                                      "Pending"
                                                                  ? AppColors
                                                                      .pendingColor
                                                                  : AppColors
                                                                      .greenColor),
                                                ),
                                                VSpace(12.h),
                                                InkWell(
                                                  onTap: () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .removeCurrentSnackBar();
                                                    Clipboard.setData(
                                                        new ClipboardData(
                                                            text:
                                                                "${data.transactionId ?? ''}"));

                                                    Helpers.showSnackBar(
                                                        msg:
                                                            "Copied Successfully",
                                                        title: 'Success',
                                                        bgColor: AppColors
                                                            .greenColor);
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
                                                      " ${data.payoutCurrencyCode}",
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: t.bodySmall,
                                                ),
                                                VSpace(12.h),
                                              ],
                                            ));
                                      },
                                      child: Ink(
                                        width: double.maxFinite,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 44.h,
                                              height: 44.h,
                                              padding: EdgeInsets.all(12.h),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: data.status ==
                                                        "Generated"
                                                    ? AppColors.secondaryColor
                                                        .withOpacity(.1)
                                                    : data.status == "Canceled"
                                                        ? AppColors.redColor
                                                            .withOpacity(.1)
                                                        : data.status ==
                                                                "Pending"
                                                            ? AppColors
                                                                .pendingColor
                                                                .withOpacity(.1)
                                                            : AppColors
                                                                .greenColor
                                                                .withOpacity(
                                                                    .1),
                                              ),
                                              child: Image.asset(
                                                data.status == "Generated"
                                                    ? "$rootImageDir/review.png"
                                                    : data.status == "Canceled"
                                                        ? "$rootImageDir/rejected.png"
                                                        : data.status ==
                                                                "Pending"
                                                            ? "$rootImageDir/pending.png"
                                                            : "$rootImageDir/approved.png",
                                                color: data.status ==
                                                        "Generated"
                                                    ? AppColors.secondaryColor
                                                    : data.status == "Canceled"
                                                        ? AppColors.redColor
                                                        : data.status ==
                                                                "Pending"
                                                            ? AppColors
                                                                .pendingColor
                                                            : AppColors
                                                                .greenColor,
                                              ),
                                            ),
                                            HSpace(12.w),
                                            Expanded(
                                              flex: 10,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              data.transactionId
                                                                  .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              style:
                                                                  t.bodyMedium,
                                                            ),
                                                            VSpace(3.h),
                                                            Text(
                                                              data.createdAt
                                                                  .toString(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: t.bodySmall
                                                                  ?.copyWith(
                                                                color: AppThemes
                                                                    .getBlack50Color(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      HSpace(3.w),
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            if (data.status ==
                                                                "Pending")
                                                              VSpace(10.h),
                                                            if (data.status ==
                                                                "Pending")
                                                              InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.r),
                                                                onTap: payoutCtrl
                                                                        .isPayoutSubmitting
                                                                    ? null
                                                                    : () async {
                                                                        payoutCtrl
                                                                            .selectedPayoutConfirmIndex = i;
                                                                        payoutCtrl
                                                                            .update();
                                                                        await payoutCtrl.payoutConfirm(
                                                                            trxId:
                                                                                data.transactionId.toString());
                                                                        await payoutCtrl
                                                                            .filterData();
                                                                        if (payoutCtrl.gatewayName ==
                                                                            "Flutterwave") {
                                                                          Get.toNamed(
                                                                              RoutesName.flutterWaveWithdrawScreen);
                                                                        } else {
                                                                          Get.toNamed(
                                                                              RoutesName.payoutPreviewScreen);
                                                                        }
                                                                      },
                                                                child: Ink(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          5.h,
                                                                      horizontal:
                                                                          9.w),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Get
                                                                            .isDarkMode
                                                                        ? AppColors
                                                                            .darkCardColor
                                                                        : AppColors
                                                                            .sliderInActiveColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.r),
                                                                  ),
                                                                  child: payoutCtrl
                                                                              .isPayoutSubmitting &&
                                                                          payoutCtrl.selectedPayoutConfirmIndex ==
                                                                              i
                                                                      ? SizedBox(
                                                                          height:
                                                                              20.h,
                                                                          width:
                                                                              20.h,
                                                                          child:
                                                                              CircularProgressIndicator(color: AppColors.whiteColor),
                                                                        )
                                                                      : Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text(
                                                                              "Confirm",
                                                                              style: t.bodySmall?.copyWith(
                                                                                fontSize: 14.sp,
                                                                                color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
                                                                              ),
                                                                            ),
                                                                            HSpace(5.w),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 3.h),
                                                                              child: Image.asset(
                                                                                "$rootImageDir/confirm_arrow.png",
                                                                                color: AppThemes.getIconBlackColor(),
                                                                                height: 12.h,
                                                                                width: 12.h,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                ),
                                                              ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                  "${data.amount} ${data.payoutCurrencyCode}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: t
                                                                      .bodyMedium),
                                                            ),
                                                          ],
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
                                    );
                                  }),
                      if (payoutHistoryCtrl.isLoadMore == true)
                        Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                            child: Helpers.appLoader()),
                      VSpace(20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  CustomAppBar buildAppbar(storedLanguage, BuildContext context,
      PayoutHistoryController payoutCtrl) {
    return CustomAppBar(
      title: storedLanguage['Payout Histroy'] ?? "Payout Histroy",
      leading: IconButton(
          onPressed: () {
            if (isFromPayoutPage == true) {
              Get.offAllNamed(RoutesName.bottomNavBar);
            } else {
              Navigator.pop(context);
            }
          },
          icon: Image.asset(
            "$rootImageDir/back.png",
            height: 22.h,
            width: 22.h,
            color: Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
            fit: BoxFit.fitHeight,
          )),
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: false,
                context: context,
                transaction: payoutCtrl.transactionIdEditingCtrlr,
                startDate: payoutCtrl.startDateTimeEditingCtrlr,
                endDate: payoutCtrl.endDateTimeEditingCtrlr,
                onStartDatePressed: () async {
                  /// SHOW DATE PICKER
                  await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    surface: AppColors.bgColor,
                                    onPrimary: AppColors.whiteColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors
                                          .mainColor, // button text color
                                    ),
                                  ),
                                ),
                                child: child!);
                          },
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025))
                      .then((value) {
                    if (value != null) {
                      print(value.toUtc());
                      payoutCtrl.startDateTimeEditingCtrlr.text =
                          DateFormat('yyyy-MM-dd').format(value);
                    }
                  });
                },
                onEndDatePressed: () async {
                  /// SHOW DATE PICKER
                  await showDatePicker(
                          context: context,
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    surface: AppColors.bgColor,
                                    onPrimary: AppColors.whiteColor,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors
                                          .mainColor, // button text color
                                    ),
                                  ),
                                ),
                                child: child!);
                          },
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025))
                      .then((value) {
                    if (value != null) {
                      print(value.toUtc());
                      payoutCtrl.endDateTimeEditingCtrlr.text =
                          DateFormat('yyyy-MM-dd').format(value);
                    }
                  });
                },
                onSearchPressed: () async {
                  payoutCtrl.resetDataAfterSearching();

                  Get.back();
                  await payoutCtrl
                      .getPayoutHistoryList(
                    page: 1,
                    transaction_id: payoutCtrl.transactionIdEditingCtrlr.text,
                    start_date: payoutCtrl.startDateTimeEditingCtrlr.text,
                    end_date: payoutCtrl.endDateTimeEditingCtrlr.text,
                  )
                      .then((value) {
                    payoutCtrl.startDateTimeEditingCtrlr.clear();
                    payoutCtrl.endDateTimeEditingCtrlr.clear();
                  });
                });
          },
          child: Container(
            width: 34.h,
            height: 34.h,
            padding: EdgeInsets.all(10.5.h),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? AppColors.darkBgColor : AppColors.black5,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.mainColor, width: .2),
            ),
            child: Image.asset(
              "$rootImageDir/filter_3.png",
              height: 32.h,
              width: 32.h,
              color:
                  Get.isDarkMode ? AppColors.whiteColor : AppColors.blackColor,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        HSpace(20.w),
      ],
    );
  }
}
