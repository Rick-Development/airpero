import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/controllers/money_request_controller.dart';
import 'package:waiz/controllers/recipients_controller.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/screens/money_request/money_request_screen.dart';
import 'package:waiz/views/widgets/mediaquery_extension.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/bindings/controller_index.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class RecipientsDetailsScreen extends StatelessWidget {
  final String? id;
  final String? uuid;
  final String? email;
  final String? currency;
  final String? img;
  final bool? isWaizUser;
  final String? faviCon;
  const RecipientsDetailsScreen({
    super.key,
    this.id = "",
    this.uuid = "",
    this.email,
    this.currency,
    this.img,
    this.isWaizUser = false,
    this.faviCon,
  });

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<RecipientDetailsController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Recipient Details'] ?? "Recipient Details",
        ),
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          color: AppColors.mainColor,
          onRefresh: () async {
            await _.getRecipientDetails(uuid: uuid ?? "");
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: _.isLoading
                  ? SizedBox(
                      width: context.mQuery.width,
                      height: context.mQuery.height,
                      child: Helpers.appLoader(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        VSpace(50.h),
                        Center(
                          child: Column(
                            children: <Widget>[
                              isWaizUser == true
                                  ? Container(
                                      height: 58.h,
                                      width: 58.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                "$img"),
                                            fit: BoxFit.cover),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            bottom: -3.h,
                                            right: -3.w,
                                            child: Container(
                                              height: 20.h,
                                              width: 20.h,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                            "$faviCon"),
                                                    fit: BoxFit.cover),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.centerRight,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          height: 58.h,
                                          width: 58.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.greyColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            "${_.recipientDetailsList[0].name[0].toString().toUpperCase()}",
                                            style: context.t.bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.whiteColor),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            height: 20.h,
                                            width: 20.h,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      "${_.recipientDetailsList[0].countryImage}"),
                                                  fit: BoxFit.cover),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              VSpace(16.h),
                              Text("${_.recipientDetailsList[0].name}",
                                  style: context.t.titleSmall),
                              VSpace(4.h),
                              Text(
                                  storedLanguage['Bpay account'] ??
                                      "Bpay account",
                                  style: context.t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor())),
                              VSpace(24.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    borderRadius:
                                        BorderRadius.circular(16.r) / 2,
                                    onTap: () {
                                      MoneyTransferController.to
                                          .resetMoneyTransferData();
                                      MoneyTransferController.to
                                          .getTransferCurrencies();
                                      Get.toNamed(
                                          RoutesName.moneyTransferScreen1);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              isWaizUser == true ? 10.w : 20.w,
                                          vertical: 10.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: Get.isDarkMode ? .5 : 1,
                                            color: AppThemes
                                                .getSliderInactiveColor()),
                                        borderRadius:
                                            BorderRadius.circular(16.r) / 2,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 30.h,
                                            width: 30.h,
                                            padding: EdgeInsets.all(9.h),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              "$rootImageDir/arrow_top.png",
                                              color: AppColors.blackColor,
                                            ),
                                          ),
                                          HSpace(
                                              isWaizUser == true ? 8.w : 16.w),
                                          Text("Send",
                                              style: context.t.displayMedium
                                                  ?.copyWith(fontSize: 20.sp)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  HSpace(20.w),
                                  if (isWaizUser == true)
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.circular(16.r) / 2,
                                      onTap: () {
                                        MoneyRequestController.to
                                            .getMoneyRequestWallet(
                                                uuid:
                                                    "e7b2ccdc-a8a6-318c-af78-d6f7ccc6c54f");
                                        Get.to(() => MoneyRequestScreen(
                                              userName: _
                                                  .recipientDetailsList[0].name
                                                  .toString(),
                                            ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 10.h),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: Get.isDarkMode ? .5 : 1,
                                              color: AppThemes
                                                  .getSliderInactiveColor()),
                                          borderRadius:
                                              BorderRadius.circular(16.r) / 2,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Transform.rotate(
                                              angle: pi,
                                              child: Container(
                                                height: 30.h,
                                                width: 30.h,
                                                padding: EdgeInsets.all(9.h),
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                  "$rootImageDir/arrow_top.png",
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                            ),
                                            HSpace(isWaizUser == true
                                                ? 8.w
                                                : 16.w),
                                            Text("Request",
                                                style: context.t.displayMedium
                                                    ?.copyWith(
                                                        fontSize: 20.sp)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (isWaizUser == true) HSpace(20.w),
                                  InkWell(
                                    borderRadius:
                                        BorderRadius.circular(16.r) / 2,
                                    onTap: () {
                                      showDialog<void>(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return GetBuilder<
                                                  RecipientDetailsController>(
                                              builder: (profileCtrl) {
                                            return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 60.h,
                                                    horizontal: 30.w),
                                                child: Material(
                                                    // Wrap with Material
                                                    elevation: 0,
                                                    type: MaterialType
                                                        .transparency,
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
                                                                        storedLanguage['Confirm Deletion'] ??
                                                                            "Confirm Deletion",
                                                                        style: context
                                                                            .t
                                                                            .displayMedium),
                                                                    InkResponse(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            EdgeInsets.all(7.h),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppThemes.getFillColor(),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              14.h,
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
                                                                    storedLanguage[
                                                                            'Are you sure you want to delete this recipient?'] ??
                                                                        "Are you sure you want to delete this recipient?",
                                                                    style: context
                                                                        .t
                                                                        .displayMedium),
                                                                VSpace(24.h),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    SizedBox(
                                                                        width: 90
                                                                            .w,
                                                                        height: 35
                                                                            .h,
                                                                        child: AppButton(
                                                                            text:
                                                                                "Close",
                                                                            style:
                                                                                context.t.displayMedium,
                                                                            onTap: () => Get.back())),
                                                                    GetBuilder<
                                                                            RecipientDetailsController>(
                                                                        builder:
                                                                            (recipientCtrl) {
                                                                      return Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            SizedBox(
                                                                          width: _.isDeleting
                                                                              ? 100.w
                                                                              : 90.w,
                                                                          height:
                                                                              35.h,
                                                                          child:
                                                                              AppButton(
                                                                            isLoading: _.isChangingName
                                                                                ? true
                                                                                : false,
                                                                            style:
                                                                                context.t.displayMedium?.copyWith(color: AppColors.whiteColor),
                                                                            bgColor:
                                                                                AppColors.redColor,
                                                                            onTap: _.isDeleting
                                                                                ? null
                                                                                : () async {
                                                                                    await _.deleteRecipient(id: id.toString());
                                                                                  },
                                                                            text: _.isDeleting
                                                                                ? "Deleting..."
                                                                                : 'Delete',
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                                  ],
                                                                ),
                                                                VSpace(20.h),
                                                              ],
                                                            ),
                                                          )
                                                        ]))));
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              isWaizUser == true ? 10.w : 18.w,
                                          vertical: 10.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: Get.isDarkMode ? .5 : 1,
                                            color: AppThemes
                                                .getSliderInactiveColor()),
                                        borderRadius:
                                            BorderRadius.circular(16.r) / 2,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 30.h,
                                            width: 30.h,
                                            padding: EdgeInsets.all(8.h),
                                            decoration: BoxDecoration(
                                              color: AppThemes
                                                  .getSliderInactiveColor(),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                              "$rootImageDir/trash.png",
                                              color:
                                                  AppThemes.getIconBlackColor(),
                                            ),
                                          ),
                                          HSpace(
                                              isWaizUser == true ? 8.w : 16.w),
                                          Text(storedLanguage['Delete'] ?? "Delete",
                                              style: context.t.bodyMedium
                                                  ?.copyWith(fontSize: 20.sp)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        VSpace(34.h),
                        Center(
                          child: Text(
                            storedLanguage['Account Details'] ??
                                "Account Details",
                            style: context.t.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 20.sp),
                          ),
                        ),
                        VSpace(5.h),
                        Divider(
                            color: Get.isDarkMode
                                ? AppColors.black80
                                : AppColors.black20),
                        VSpace(15.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    storedLanguage['Nickname'] ?? "Nickname",
                                    style: context.t.displayMedium?.copyWith(
                                        color: AppThemes.getParagraphColor()),
                                  ),
                                  Text(
                                    "${_.recipientDetailsList[0].name}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                buildChangeNicknameDialog(
                                    context, storedLanguage, _);
                              },
                              child: Container(
                                width: 76.w,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: AppThemes.getSliderInactiveColor(),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        VSpace(20.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              storedLanguage['Email'] ?? "Email",
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor()),
                            ),
                            Text(
                              "$email",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodyMedium,
                            ),
                          ],
                        ),
                        VSpace(20.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              storedLanguage['Type'] ?? "Type",
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor()),
                            ),
                            Text(
                              "${_.recipientDetailsList[0].type}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.t.bodyMedium,
                            ),
                          ],
                        ),
                        if (isWaizUser != true) ...[
                          VSpace(20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                storedLanguage['Currency'] ?? "Currency",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor()),
                              ),
                              Text(
                                "$currency",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.t.bodyMedium,
                              ),
                            ],
                          ),
                          VSpace(20.h),
                          if (_.bankInfo.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _.bankInfo
                                  .map((e) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${e.info.fieldName}",
                                            style: context.t.displayMedium
                                                ?.copyWith(
                                                    color: AppThemes
                                                        .getParagraphColor()),
                                          ),
                                          Text(
                                            "${e.info.value}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.t.bodyMedium,
                                          ),
                                          VSpace(20.h),
                                        ],
                                      ))
                                  .toList(),
                            ),
                          Text(
                            storedLanguage['Service Name'] ?? "Service Name",
                            style: context.t.displayMedium?.copyWith(
                                color: AppThemes.getParagraphColor()),
                          ),
                          Text(
                            "${_.recipientDetailsList[0].serviceName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.t.bodyMedium,
                          ),
                          VSpace(20.h),
                          Text(
                            storedLanguage['Bank Name'] ?? "Bank Name",
                            style: context.t.displayMedium?.copyWith(
                                color: AppThemes.getParagraphColor()),
                          ),
                          Text(
                            "${_.recipientDetailsList[0].bankName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.t.bodyMedium,
                          ),
                        ],
                        VSpace(30.h),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> buildChangeNicknameDialog(
      BuildContext context, storedLanguage, RecipientDetailsController _) {
    return showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<RecipientDetailsController>(builder: (profileCtrl) {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 30.w),
              child: Material(
                  // Wrap with Material
                  elevation: 0,
                  type: MaterialType.transparency,
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Container(
                          width: context.mQuery.width,
                          padding: Dimensions.kDefaultPadding,
                          decoration: BoxDecoration(
                              color: AppThemes.getDarkBgColor(),
                              borderRadius: BorderRadius.circular(32.r)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VSpace(20.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      storedLanguage[
                                              'Edit Recipient Nickname'] ??
                                          "Edit Recipient Nickname",
                                      style: context.t.displayMedium),
                                  InkResponse(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(7.h),
                                      decoration: BoxDecoration(
                                        color: AppThemes.getFillColor(),
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
                              VSpace(30.h),
                              Text(storedLanguage['Name'] ?? "Name",
                                  style: context.t.displayMedium),
                              VSpace(10.h),
                              CustomTextField(
                                isOnlyBorderColor: true,
                                height: 50.h,
                                hintext: storedLanguage['Enter name'] ??
                                    "Enter name",
                                controller: _.nameEditingController,
                                contentPadding: EdgeInsets.only(left: 20.w),
                              ),
                              VSpace(24.h),
                              GetBuilder<RecipientDetailsController>(
                                  builder: (profileCtrl) {
                                return Material(
                                  color: Colors.transparent,
                                  child: AppButton(
                                    isLoading: _.isChangingName ? true : false,
                                    onTap: _.isChangingName
                                        ? null
                                        : () async {
                                            if (_.nameEditingController.text
                                                .isEmpty) {
                                              Helpers.showSnackBar(
                                                  msg:
                                                      "Email field is required");
                                            } else {
                                              await _
                                                  .changeRecipientName(
                                                      id: id ?? "",
                                                      name: _
                                                          .nameEditingController
                                                          .text)
                                                  .then((value) {
                                                _.getRecipientDetails(
                                                    uuid: uuid ?? "",
                                                    isFromNameUpdate: true);
                                              });
                                            }
                                          },
                                    text: storedLanguage['Update Name'] ??
                                        'Update Name',
                                  ),
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
  }
}
