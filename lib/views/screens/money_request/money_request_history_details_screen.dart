import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/profile_controller.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/money_request_list_controller.dart';
import '../../../data/models/money_request_history_model.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class MoneyRequestHistoryDetailsScreen extends StatelessWidget {
  final Datum? data;
  const MoneyRequestHistoryDetailsScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<MoneyRequestListController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Transaction Details'] ?? "Transaction Details",
        ),
        body: Padding(
          padding: Dimensions.kDefaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VSpace(50.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppColors.darkCardColor
                      : AppColors.whiteColor,
                  borderRadius: Dimensions.kBorderRadius,
                  border: Border.all(
                      color: Get.isDarkMode
                          ? AppColors.black70
                          : AppColors.black20,
                      width: .2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.h,
                              padding: EdgeInsets.all(8.h),
                              decoration: BoxDecoration(
                                color: data?.status.toString() == "0"
                                    ? AppColors.pendingColor.withOpacity(.2)
                                    : data?.status.toString() == "1"
                                        ? AppColors.increamentColor
                                            .withOpacity(.2)
                                        : AppColors.increamentColor
                                            .withOpacity(.2),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                data?.status.toString() == "0"
                                    ? '$rootImageDir/pending.png'
                                    : data?.status.toString() == "1"
                                        ? '$rootImageDir/approved.png'
                                        : '$rootImageDir/rejected.png',
                                color: data?.status.toString() == "0"
                                    ? AppColors.pendingColor
                                    : data?.status.toString() == "1"
                                        ? AppColors.increamentColor
                                        : AppColors.redColor,
                                fit: BoxFit.fill,
                              ),
                            ),
                            HSpace(10.w),
                            Text(
                                data?.status.toString() == "0"
                                    ? "Pending"
                                    : data?.status.toString() == "1"
                                        ? "Success"
                                        : "Rejected",
                                style: t.bodyMedium?.copyWith(
                                  color: data?.status.toString() == "0"
                                      ? AppColors.pendingColor
                                      : data?.status.toString() == "1"
                                          ? AppColors.increamentColor
                                          : AppColors.redColor,
                                )),
                          ],
                        ),
                        Text("#${data?.trxId}", style: t.bodyMedium),
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
                    VSpace(15.h),
                    Text(
                        storedLanguage['Basic Information'] ??
                            "Basic Information",
                        style: context.t.bodyMedium),
                    VSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(storedLanguage['Net Amount'] ?? "Net Amount",
                            style: context.t.displayMedium?.copyWith(
                                color: AppThemes.getParagraphColor())),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Text("${data?.amount} ${data?.currency}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodyMedium),
                        )),
                      ],
                    ),
                    VSpace(10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            storedLanguage['Transaction Date'] ??
                                "Transaction Date",
                            style: context.t.displayMedium?.copyWith(
                                color: AppThemes.getParagraphColor())),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "${DateFormat('dd MMM yyyy').format(DateTime.parse(data!.createdAt.toString()))}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodyMedium),
                        )),
                      ],
                    ),
                    VSpace(25.h),
                    Text(
                        data?.requesterId.toString() ==
                                ProfileController.to.userId
                            ? storedLanguage['Recipient Information'] ??
                                "Recipient Information"
                            : storedLanguage['Requester Information'] ??
                                "Requester Information",
                        style: context.t.bodyMedium),
                    VSpace(20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(storedLanguage['Full Name'] ?? "Full Name",
                            style: context.t.displayMedium?.copyWith(
                                color: AppThemes.getParagraphColor())),
                        Expanded(
                            child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              data?.requesterId.toString() !=
                                      ProfileController.to.userId
                                  ? "${data?.reqUser?.firstname} ${data?.reqUser?.lastname}"
                                  : "${data?.rcpUser?.firstname} ${data?.rcpUser?.lastname}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodyMedium),
                        )),
                      ],
                    ),
                    VSpace(10.h),
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
                              data?.requesterId.toString() !=
                                      ProfileController.to.userId
                                  ? "${data?.reqUser?.email}"
                                  : "${data?.rcpUser!.email}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodyMedium),
                        )),
                      ],
                    ),
                    if (data?.status.toString() == "0" &&
                        (data?.requesterId.toString() !=
                            ProfileController.to.userId))
                      VSpace(30.h),
                    if (data?.status.toString() == "0" &&
                        (data?.requesterId.toString() !=
                            ProfileController.to.userId))
                      Row(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: AppButton(
                                isLoading:
                                    _.isActioning && _.isTappedFromApprove
                                        ? true
                                        : false,
                                buttonWidth: 90.h,
                                buttonHeight: 40.h,
                                borderRadius: BorderRadius.circular(20.r),
                                style: t.bodyMedium?.copyWith(
                                    color: Get.isDarkMode
                                        ? AppColors.blackColor
                                        : AppColors.whiteColor),
                                onTap: _.isActioning && _.isTappedFromApprove
                                    ? null
                                    : () async {
                                        _.isTappedFromApprove = true;
                                        _.update();
                                        await _.moneyRequestAction(
                                            context: context,
                                            fields: {
                                              "trx_id": "${data?.trxId}",
                                              "action": "approve"
                                            });
                                      },
                                text: "Approve"),
                          ),
                          HSpace(20.w),
                          Material(
                            color: Colors.transparent,
                            child: AppButton(
                                isLoading: _.isActioning &&
                                        _.isTappedFromApprove == false
                                    ? true
                                    : false,
                                buttonWidth: 90.h,
                                buttonHeight: 40.h,
                                style: t.bodyMedium
                                    ?.copyWith(color: AppColors.whiteColor),
                                borderRadius: BorderRadius.circular(20.r),
                                bgColor: AppColors.redColor,
                                onTap: _.isActioning &&
                                        _.isTappedFromApprove == false
                                    ? null
                                    : () async {
                                        _.isTappedFromApprove = false;
                                        _.update();
                                        await _.moneyRequestAction(
                                            context: context,
                                            fields: {
                                              "trx_id": "${data?.trxId}",
                                              "action": "reject"
                                            });
                                      },
                                text: "Reject"),
                          ),
                        ],
                      ),
                    if (data?.status.toString() != "0") VSpace(30.h),
                    if (data?.status.toString() != "0")
                      Container(
                        height: 45.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 15.w),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: 15.w,
                                color: data?.status.toString() == "2"
                                    ? AppColors.redColor
                                    : AppColors.increamentColor),
                            right: BorderSide(
                                color: data?.status.toString() == "2"
                                    ? AppColors.redColor
                                    : AppColors.increamentColor),
                            bottom: BorderSide(
                                color: data?.status.toString() == "2"
                                    ? AppColors.redColor
                                    : AppColors.increamentColor),
                            top: BorderSide(
                                color: data?.status.toString() == "2"
                                    ? AppColors.redColor
                                    : AppColors.increamentColor),
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data?.status.toString() == "2"
                                ? "Money Request Rejected"
                                : "Money Request has been Approved",
                            style: t.bodyMedium?.copyWith(
                                color: data?.status.toString() == "2"
                                    ? AppColors.redColor
                                    : AppColors.increamentColor),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
