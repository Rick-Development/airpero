import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiz/controllers/money_transfer_controller.dart';
import 'package:waiz/views/screens/money_transfer/money_transfer_screen4.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/transfer_history_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/search_dialog.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class MoneyTransferHistoryScreen extends StatelessWidget {
  const MoneyTransferHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<TransferHistoryController>(
        builder: (transferHistoryCtrl) {
      return Scaffold(
        appBar: buildAppbar(storedLanguage, context, transferHistoryCtrl),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: AppColors.mainColor,
          onRefresh: () async {
            transferHistoryCtrl.resetDataAfterSearching(
                isFromOnRefreshIndicator: true);
            await transferHistoryCtrl.getTransferHistory(
                page: 1, name: '', start_date: '', end_date: '');
          },
          child: SingleChildScrollView(
            controller: transferHistoryCtrl.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(20.h),
                  transferHistoryCtrl.isLoading
                      ? buildTransactionLoader(
                          itemCount: 20, isReverseColor: true)
                      : transferHistoryCtrl.transferHistoryList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transferHistoryCtrl
                                  .transferHistoryList.length,
                              itemBuilder: (context, i) {
                                var data =
                                    transferHistoryCtrl.transferHistoryList[i];
                                return InkWell(
                                  borderRadius: Dimensions.kBorderRadius,
                                  onTap: () {
                                    if (data.status
                                        .toString()
                                        .contains("Initiate")) {
                                      // if the recipient is already deleted or not
                                      // status true = will process, status false = won't process
                                      if (data.recipient_status == true) {
                                        Get.put(MoneyTransferController())
                                                .transferStore_trxId =
                                            data.trx_id.toString();
                                        Get.find<MoneyTransferController>()
                                            .getTransferPay(
                                                uuid: data.uuid.toString());
                                        Get.to(() => MoneyTransferScreen4(
                                            recipientName: data.recipient!.name
                                                .split(" ")[0]));
                                      } else {
                                        Helpers.showSnackBar(
                                            msg:
                                                "Invalid Transaction. You removed this recipient.");
                                      }
                                    } else {
                                      Get.find<MoneyTransferController>()
                                          .getTransferDetails(
                                              uuid: data.uuid.toString());
                                      Get.toNamed(RoutesName
                                          .moneyTransferDetailsScreen);
                                    }
                                  },
                                  child: Ink(
                                    width: double.maxFinite,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 44.h,
                                          height: 44.h,
                                          padding: EdgeInsets.all(10.h),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: data.status
                                                    .toString()
                                                    .contains("Initiate")
                                                ? AppColors.pendingColor
                                                    .withOpacity(.1)
                                                : data.status
                                                        .toString()
                                                        .contains("Completed")
                                                    ? AppColors.greenColor
                                                        .withOpacity(.1)
                                                    : data.status
                                                            .toString()
                                                            .contains(
                                                                "Under Review")
                                                        ? Colors.blue
                                                            .withOpacity(.1)
                                                        : AppColors.redColor
                                                            .withOpacity(.1),
                                          ),
                                          child: Image.asset(
                                            data.status
                                                    .toString()
                                                    .contains("Initiate")
                                                ? "$rootImageDir/initiated.png"
                                                : data.status
                                                        .toString()
                                                        .contains("Completed")
                                                    ? "$rootImageDir/approved.png"
                                                    : data.status
                                                            .toString()
                                                            .contains(
                                                                "Under Review")
                                                        ? "$rootImageDir/review.png"
                                                        : "$rootImageDir/rejected.png",
                                            color: data.status
                                                    .toString()
                                                    .contains("Initiate")
                                                ? AppColors.pendingColor
                                                : data.status
                                                        .toString()
                                                        .contains("Completed")
                                                    ? AppColors.greenColor
                                                    : data.status
                                                            .toString()
                                                            .contains(
                                                                "Under Review")
                                                        ? Colors.blue
                                                        : AppColors.redColor,
                                          ),
                                        ),
                                        HSpace(8.w),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 22,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          data.recipient == null
                                                              ? ""
                                                              : data.recipient!
                                                                  .name
                                                                  .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyMedium,
                                                        ),
                                                        VSpace(3.h),
                                                        Text(
                                                          data.createdAt
                                                              .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
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
                                                  Expanded(
                                                    flex: 18,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          data.sendAmount
                                                                  .toString() +
                                                              " ${data.senderCurrency}",
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          style: t.bodyMedium,
                                                        ),
                                                        VSpace(3.h),
                                                        Text(
                                                          data.recipientGetAmount
                                                                  .toString() +
                                                              " ${data.receiverCurrency}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
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
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 12.h),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Get.isDarkMode
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
                  if (transferHistoryCtrl.isLoadMore == true)
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
      TransferHistoryController transferCtrl) {
    return CustomAppBar(
      title:
          storedLanguage['Money Transfer History'] ?? "Money Transfer History",
      actions: [
        InkResponse(
          onTap: () {
            searchDialog(
                isRemarkField: false,
                context: context,
                transaction: transferCtrl.nameEditingCtrlr,
                transactionHintext: "Name, Email",
                startDate: transferCtrl.startDateTimeEditingCtrlr,
                endDate: transferCtrl.endDateTimeEditingCtrlr,
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
                      transferCtrl.startDateTimeEditingCtrlr.text =
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
                      transferCtrl.endDateTimeEditingCtrlr.text =
                          DateFormat('yyyy-MM-dd').format(value);
                    }
                  });
                },
                onSearchPressed: () async {
                  transferCtrl.resetDataAfterSearching();

                  Get.back();
                  await transferCtrl
                      .getTransferHistory(
                    page: 1,
                    name: transferCtrl.nameEditingCtrlr.text,
                    start_date: transferCtrl.startDateTimeEditingCtrlr.text,
                    end_date: transferCtrl.endDateTimeEditingCtrlr.text,
                  )
                      .then((value) {
                    transferCtrl.startDateTimeEditingCtrlr.clear();
                    transferCtrl.endDateTimeEditingCtrlr.clear();
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
