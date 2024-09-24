import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
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

class TransactionScreen extends StatelessWidget {
  final bool? isFromHomePage;
  final bool? isFromWallet;
  const TransactionScreen(
      {super.key, this.isFromHomePage = false, this.isFromWallet = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<TransactionController>(builder: (transactionCtrl) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (isFromWallet == true) {
            transactionCtrl.resetDataAfterSearching(
                isFromOnRefreshIndicator: true);
            transactionCtrl.getTransactionList(
                page: 1, transaction_id: "", start_date: "", end_date: "");
            Get.back();
          } else {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: buildAppbar(storedLanguage, context, transactionCtrl,
              isFromHomePage, isFromWallet!),
          body: RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: () async {
              transactionCtrl.resetDataAfterSearching(
                  isFromOnRefreshIndicator: true);
              await transactionCtrl.getTransactionList(
                  isFromWallet: isFromWallet,
                  uuid: WalletController.to.walletUUID,
                  page: 1,
                  transaction_id: '',
                  start_date: '',
                  end_date: '');
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: transactionCtrl.scrollController,
              child: Padding(
                padding: Dimensions.kDefaultPadding,
                child: Column(
                  children: [
                    VSpace(20.h),
                    transactionCtrl.isLoading
                        ? buildTransactionLoader(
                            itemCount: 20, isReverseColor: true)
                        : transactionCtrl.transactionList.isEmpty
                            ? Helpers.notFound()
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    transactionCtrl.transactionList.length,
                                itemBuilder: (context, i) {
                                  var data = transactionCtrl.transactionList[i];
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
                                              Image.asset(
                                                "$rootImageDir/done.png",
                                                height: 48.h,
                                                width: 48.h,
                                              ),
                                              VSpace(12.h),
                                              InkWell(
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .removeCurrentSnackBar();
                                                  Clipboard.setData(
                                                      new ClipboardData(
                                                          text:
                                                              "${data.trxId ?? ''}"));

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
                                                        data.trxId ?? '',
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
                                                data.amount.toString(),
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
                                                    "  ${isFromWallet == true ? data.currency : HiveHelp.read(Keys.baseCurrency)}",
                                                style: t.bodySmall,
                                              ),
                                              VSpace(12.h),
                                              Text(
                                                storedLanguage['Remark'] ??
                                                    "Remark",
                                                style: t.bodyMedium?.copyWith(
                                                    color: Get.isDarkMode
                                                        ? AppColors.whiteColor
                                                        : AppColors.blackColor
                                                            .withOpacity(.5)),
                                              ),
                                              Text(
                                                data.remarks ?? '',
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
                                            width: 40.h,
                                            height: 40.h,
                                            child: Image.asset(
                                              data.trx_type.toString() == "+"
                                                  ? "$rootImageDir/increment.png"
                                                  : "$rootImageDir/decrement.png",
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 10,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data.remarks
                                                                .toString()
                                                                .capitalize
                                                                .toString(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: t.bodyMedium,
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
                                                      flex: 7,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "${data.trx_type} " +
                                                              data.amount
                                                                  .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyMedium,
                                                        ),
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
                    if (transactionCtrl.isLoadMore == true)
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
  }

  CustomAppBar buildAppbar(
      storedLanguage,
      BuildContext context,
      TransactionController transactionCtrl,
      isFromHomePage,
      bool isFromWallet) {
    return CustomAppBar(
      title: isFromWallet == true
          ? storedLanguage['Wallet Transaction History'] ??
              "Wallet Transaction History"
          : storedLanguage['Transaction'] ?? "Transaction",
      leading: isFromHomePage == true
          ? IconButton(
              onPressed: () {
                Get.back();
                if (isFromWallet == true) {
                  transactionCtrl.resetDataAfterSearching(
                      isFromOnRefreshIndicator: true);
                  transactionCtrl.getTransactionList(
                      page: 1,
                      transaction_id: "",
                      start_date: "",
                      end_date: "");
                }
              },
              icon: Image.asset(
                "$rootImageDir/back.png",
                height: 22.h,
                width: 22.h,
                color: Get.isDarkMode
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
                fit: BoxFit.fitHeight,
              ))
          : const SizedBox(),
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: false,
                context: context,
                transaction: transactionCtrl.transactionIdEditingCtrlr,
                startDate: transactionCtrl.startDateTimeEditingCtrlr,
                endDate: transactionCtrl.endDateTimeEditingCtrlr,
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
                      transactionCtrl.startDateTimeEditingCtrlr.text =
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
                      transactionCtrl.endDateTimeEditingCtrlr.text =
                          DateFormat('yyyy-MM-dd').format(value);
                    }
                  });
                },
                onSearchPressed: () async {
                  transactionCtrl.resetDataAfterSearching();

                  Get.back();
                  await transactionCtrl
                      .getTransactionList(
                    page: 1,
                    transaction_id:
                        transactionCtrl.transactionIdEditingCtrlr.text,
                    start_date: transactionCtrl.startDateTimeEditingCtrlr.text,
                    end_date: transactionCtrl.endDateTimeEditingCtrlr.text,
                  )
                      .then((value) {
                    transactionCtrl.startDateTimeEditingCtrlr.clear();
                    transactionCtrl.endDateTimeEditingCtrlr.clear();
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
