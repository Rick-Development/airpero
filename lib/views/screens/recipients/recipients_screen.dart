import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/app_controller.dart';
import 'package:waiz/controllers/money_request_controller.dart';
import 'package:waiz/controllers/money_request_list_controller.dart';
import 'package:waiz/controllers/recipients_controller.dart';
import 'package:waiz/controllers/recipients_list_controller.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/mediaquery_extension.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/card_controller.dart';
import '../../../controllers/money_transfer_controller.dart';
import '../../../routes/page_index.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_textfield.dart';
import 'dart:math';

class RecipientsScreen extends StatelessWidget {
  final bool? isFromMoneyTransferPage;
  final String? countryName;
  const RecipientsScreen(
      {super.key, this.isFromMoneyTransferPage = false, this.countryName = ""});

  @override
  Widget build(BuildContext context) {
    Get.delete<CardController>();
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appCtrl) {
      var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
      return GetBuilder<RecipientListController>(builder: (_) {
        return Scaffold(
          appBar: CustomAppBar(
            title: isFromMoneyTransferPage == true
                ? storedLanguage['Send Money To Recipient'] ??
                    "Send Money To Recipient"
                : storedLanguage['Recipients'] ?? "Recipients",
            leading: isFromMoneyTransferPage == true
                ? IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Image.asset(
                      "$rootImageDir/back.png",
                      height: 22.h,
                      width: 22.h,
                      color: AppThemes.getIconBlackColor(),
                      fit: BoxFit.fitHeight,
                    ))
                : const SizedBox(),
          ),
          body: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(30.h),
                if (isFromMoneyTransferPage == true) ...[
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
                            style: t.displayMedium?.copyWith(
                                color: AppThemes.getParagraphColor())),
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
                        buildWidget(
                            constraints,
                            Get.isDarkMode
                                ? AppColors.black60
                                : AppColors.sliderInActiveColor,
                            isOnlyCircleColor: true,
                            circleColor: AppColors.mainColor),
                        buildWidget(
                            constraints,
                            Get.isDarkMode
                                ? AppColors.black60
                                : AppColors.sliderInActiveColor),
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
                ],
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                          hintext: "Name, email, country or @waiztag",
                          hintStyle: t.bodySmall?.copyWith(
                            color: AppColors.textFieldHintColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                          ),
                          controller: _.searchEditingCtrlr,
                          isOnlyBorderColor: true,
                          isSuffixIcon: true,
                          isSuffixBgColor: true,
                          suffixIcon: "search",
                          suffixIconColor: AppColors.blackColor,
                          onSuffixPressed: () {
                            Helpers.hideKeyboard();
                            if (_.searchEditingCtrlr.text.isNotEmpty) {
                              _.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              _.getRecipientList(
                                isFromUserTable:
                                    _.searchEditingCtrlr.text.contains("@")
                                        ? true
                                        : false,
                                page: 1,
                                search: _.searchEditingCtrlr.text.toString(),
                              );
                            } else {
                              _.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              _.getRecipientList(
                                page: 1,
                                search: "",
                              );
                            }
                          },
                          onFieldSubmitted: (v) {
                            Helpers.hideKeyboard();
                            if (_.searchEditingCtrlr.text.isNotEmpty) {
                              _.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              _.getRecipientList(
                                isFromUserTable:
                                    _.searchEditingCtrlr.text.contains("@")
                                        ? true
                                        : false,
                                page: 1,
                                search: _.searchEditingCtrlr.text.toString(),
                              );
                            } else {
                              _.resetDataAfterSearching(
                                  isFromOnRefreshIndicator: true);
                              _.getRecipientList(
                                page: 1,
                                search: "",
                              );
                            }
                          }),
                    ),
                    HSpace(8.w),
                    InkWell(
                      borderRadius: Dimensions.kBorderRadius,
                      onTap: () {
                        buildCreateRecipientDialog(context, storedLanguage);
                      },
                      child: Ink(
                        width: Dimensions.textFieldHeight,
                        height: Dimensions.textFieldHeight,
                        decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? AppColors.darkCardColor
                              : AppColors.sliderInActiveColor,
                          borderRadius: Dimensions.kBorderRadius,
                          border: Border.all(
                              color: AppThemes.borderColor(),
                              width: Dimensions.appThinBorder),
                        ),
                        child: Icon(Icons.add, size: 24.h),
                      ),
                    ),
                  ],
                ),
                VSpace(20.h),
                Row(
                  children: [
                    AppButton(
                      buttonWidth: 50.w,
                      buttonHeight: 48.h,
                      bgColor: _.type == "all"
                          ? Get.isDarkMode
                              ? AppColors.mainColor
                              : AppColors.blackColor
                          : Colors.transparent,
                      border:
                          Border.all(color: AppThemes.getSliderInactiveColor()),
                      style: t.bodyMedium?.copyWith(
                          color: _.type == "all"
                              ? Get.isDarkMode
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor
                              : Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor),
                      onTap: () {
                        _.type = "all";
                        _.update();
                      },
                      text: "All",
                    ),
                    HSpace(20.w),
                    AppButton(
                      buttonWidth: 110.w,
                      buttonHeight: 48.h,
                      bgColor: _.type == "my-self"
                          ? Get.isDarkMode
                              ? AppColors.mainColor
                              : AppColors.blackColor
                          : Colors.transparent,
                      border:
                          Border.all(color: AppThemes.getSliderInactiveColor()),
                      style: t.bodyMedium?.copyWith(
                          color: _.type == "my-self"
                              ? Get.isDarkMode
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor
                              : Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor),
                      onTap: () {
                        _.type = "my-self";
                        _.filteredList = _.recipientList
                            .where((e) => e.type == "my-self")
                            .toList();
                        _.update();
                      },
                      text: "My Account",
                    ),
                    HSpace(20.w),
                    AppButton(
                      buttonWidth: 80.w,
                      buttonHeight: 48.h,
                      bgColor: _.type == "others"
                          ? Get.isDarkMode
                              ? AppColors.mainColor
                              : AppColors.blackColor
                          : Colors.transparent,
                      border:
                          Border.all(color: AppThemes.getSliderInactiveColor()),
                      style: t.bodyMedium?.copyWith(
                          color: _.type == "others"
                              ? Get.isDarkMode
                                  ? AppColors.blackColor
                                  : AppColors.whiteColor
                              : Get.isDarkMode
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor),
                      onTap: () {
                        _.type = "others";
                        _.filteredList = _.recipientList
                            .where((e) => e.type == "others")
                            .toList();
                        _.update();
                      },
                      text: "Others",
                    ),
                  ],
                ),
                _.isLoading
                    ? Padding(
                        padding: EdgeInsets.only(top: 30.h),
                        child: buildTransactionLoader(
                            isReverseColor: true, itemCount: 6))
                    : Expanded(
                        child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        color: AppColors.mainColor,
                        onRefresh: () async {
                          _.searchEditingCtrlr.clear();
                          _.resetDataAfterSearching(
                              isFromOnRefreshIndicator: true);
                          await _.getRecipientList(
                            page: 1,
                            search: '',
                          );
                        },
                        child: _.recipientList2.isNotEmpty && _.type == "all"
                            ? ListView.builder(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                padding: EdgeInsets.only(top: 22.h),
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _.scrollController,
                                itemCount: _.recipientList2.length,
                                itemBuilder: (context, i) {
                                  if (_.recipientList2.isEmpty) {
                                    return Helpers.notFound();
                                  }
                                  var data = _.recipientList2[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    child: InkWell(
                                      borderRadius: Dimensions.kBorderRadius,
                                      onTap: () async {
                                        await MoneyRequestListController.to
                                            .recipientstore(fields: {
                                          "r_user_id": data.id.toString()
                                        });
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          border: Border.all(
                                            color: AppThemes
                                                .getSliderInactiveColor(),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.centerRight,
                                              clipBehavior: Clip.none,
                                              children: [
                                                data.image != null
                                                    ? Container(
                                                        height: 38.h,
                                                        width: 38.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  "${data.image}"),
                                                              fit:
                                                                  BoxFit.cover),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 38.h,
                                                        width: 38.h,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _.pickRandomColor(
                                                              data,
                                                              isFromRecipientList2:
                                                                  true),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Text(
                                                          "${data.firstname[0].toString().toUpperCase()}",
                                                          style: context
                                                              .t.bodyLarge
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .whiteColor),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            HSpace(15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${data.firstname}" +
                                                          " ${data.lastname}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          context.t.bodyMedium),
                                                  Text("${data.email}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: context.t.bodySmall
                                                          ?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .textFieldHintColor
                                                                  : AppColors
                                                                      .textFieldHintColor)),
                                                ],
                                              ),
                                            ),
                                            GetBuilder<
                                                    RecipientDetailsController>(
                                                builder: (_) {
                                              return Get.find<RecipientDetailsController>()
                                                              .tappedIndex ==
                                                          i &&
                                                      _.isLoading
                                                  ? SizedBox(
                                                      height: 25.h,
                                                      width: 25.h,
                                                      child:
                                                          Helpers.appLoader(),
                                                    )
                                                  : Transform.rotate(
                                                      angle: pi,
                                                      child: Image.asset(
                                                        "$rootImageDir/back.png",
                                                        height: 20.h,
                                                        width: 20.h,
                                                        color: Get.isDarkMode
                                                            ? AppColors.black30
                                                            : AppColors
                                                                .blackColor,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })
                            : ListView.builder(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                padding: EdgeInsets.only(top: 22.h),
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _.scrollController,
                                itemCount: _.recipientList.isEmpty
                                    ? 1
                                    : _.type == "my-self" || _.type == "others"
                                        ? _.filteredList.length
                                        : _.recipientList.length,
                                itemBuilder: (context, i) {
                                  if (_.recipientList.isEmpty) {
                                    return Helpers.notFound();
                                  }
                                  var data =
                                      _.type == "my-self" || _.type == "others"
                                          ? _.filteredList[i]
                                          : _.recipientList[i];
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 20.h),
                                    child: InkWell(
                                      borderRadius: Dimensions.kBorderRadius,
                                      onTap: () async {
                                        if (isFromMoneyTransferPage == false) {
                                          Get.find<RecipientDetailsController>()
                                              .tappedIndex = i;
                                          await Get.find<
                                                  RecipientDetailsController>()
                                              .getRecipientDetails(
                                                  uuid: data.uuid.toString());
                                          Get.find<RecipientDetailsController>()
                                              .update();

                                          MoneyRequestController
                                                  .to.recipientId =
                                              data.rUserId.toString();
                                          if (Get.find<
                                                      RecipientDetailsController>()
                                                  .isValidRecipient ==
                                              true)
                                            Get.to(() =>
                                                RecipientsDetailsScreen(
                                                  id: data.id.toString(),
                                                  uuid: data.uuid.toString(),
                                                  email: data.email.toString(),
                                                  currency: data.currencyCode
                                                          .toString() +
                                                      " - " +
                                                      data.currencyName
                                                          .toString(),
                                                  img: data.rUserId == null
                                                      ? ""
                                                      : data.rUserImage
                                                          .toString(),
                                                  isWaizUser:
                                                      data.rUserId != null
                                                          ? true
                                                          : false,
                                                  faviCon:
                                                      data.favicon.toString(),
                                                ));
                                        } else {
                                          // if the user is from moneyTransfer page
                                          // because moneyTransferController is deleted and no datas are existing
                                          MoneyTransferController.to.sendVal =
                                              _.sendVal;
                                          MoneyTransferController
                                              .to.sendCtrl.text = _.sendVal;

                                          MoneyTransferController
                                                  .to.senderInitialSelectedId =
                                              _.senderInitialSelectedId;
                                          MoneyTransferController.to
                                                  .receiverInitialSelectedId =
                                              _.receiverInitialSelectedId;
                                          MoneyTransferController.to
                                                  .senderInitialSelectedCurrency =
                                              _.senderInitialSelectedCurrency;
                                          MoneyTransferController.to
                                                  .senderInitialSelectedRate =
                                              _.senderInitialSelectedRate;
                                          MoneyTransferController.to
                                                  .receiverInitialSelectedRate =
                                              _.receiverInitialSelectedRate;

                                          MoneyTransferController
                                              .to.transferFee = _.transferFee;
                                          MoneyTransferController.to.minAmount =
                                              _.minAmount;
                                          MoneyTransferController.to.maxAmount =
                                              _.maxAmount;
                                          MoneyTransferController
                                                  .to.minTransferFees =
                                              _.minTransferFees;
                                          MoneyTransferController
                                                  .to.maxTransferFees =
                                              _.maxTransferFees;
                                          MoneyTransferController.to.currency =
                                              _.currency;
                                          await MoneyTransferController.to
                                              .calculateSenderAmount();
                                          MoneyTransferController.to.r_user_id =
                                              data.rUserId;
                                          //=============================
                                          MoneyTransferController.to
                                              .getTransferReview(
                                                  uuid: data.uuid);
                                          Get.to(() => MoneyTransferScreen3(
                                              isWaizUser: data.rUserId != null
                                                  ? true
                                                  : false));
                                        }
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              Dimensions.kBorderRadius,
                                          border: Border.all(
                                            color: AppThemes
                                                .getSliderInactiveColor(),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.centerRight,
                                              clipBehavior: Clip.none,
                                              children: [
                                                data.rUserId != null
                                                    ? Container(
                                                        height: 38.h,
                                                        width: 38.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  "${data.rUserImage}"),
                                                              fit:
                                                                  BoxFit.cover),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 38.h,
                                                        width: 38.h,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              _.pickRandomColor(
                                                                  data),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Text(
                                                          "${data.name[0].toString().toUpperCase()}",
                                                          style: context
                                                              .t.bodyLarge
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: AppColors
                                                                      .whiteColor),
                                                        ),
                                                      ),
                                                Positioned(
                                                  bottom: -3.h,
                                                  right: -3.w,
                                                  child: Container(
                                                    height: 15.h,
                                                    width: 15.h,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              "${data.rUserId != null ? data.favicon : data.countryImage}"),
                                                          fit: BoxFit.cover),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            HSpace(15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${data.name}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          context.t.bodyMedium),
                                                  Text("${data.email}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: context.t.bodySmall
                                                          ?.copyWith(
                                                              color: Get
                                                                      .isDarkMode
                                                                  ? AppColors
                                                                      .textFieldHintColor
                                                                  : AppColors
                                                                      .textFieldHintColor)),
                                                ],
                                              ),
                                            ),
                                            GetBuilder<
                                                    RecipientDetailsController>(
                                                builder: (_) {
                                              return Get.find<RecipientDetailsController>()
                                                              .tappedIndex ==
                                                          i &&
                                                      _.isLoading
                                                  ? SizedBox(
                                                      height: 25.h,
                                                      width: 25.h,
                                                      child:
                                                          Helpers.appLoader(),
                                                    )
                                                  : Transform.rotate(
                                                      angle: pi,
                                                      child: Image.asset(
                                                        "$rootImageDir/back.png",
                                                        height: 20.h,
                                                        width: 20.h,
                                                        color: Get.isDarkMode
                                                            ? AppColors.black30
                                                            : AppColors
                                                                .blackColor,
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                      )),
                if (_.isLoadMore == true)
                  Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      child: Helpers.appLoader()),
                VSpace(20.h),
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

Future<void> buildCreateRecipientDialog(BuildContext context, storedLanguage) {
  return showDialog<void>(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h, horizontal: 20.w),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  storedLanguage['Create Recipient'] ??
                                      "Create Recipient",
                                  style: context.t.bodyMedium),
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
                          VSpace(10.h),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(() => AddRecipientsScreen(type: "0"));
                              },
                              borderRadius: Dimensions.kBorderRadius,
                              child: Ink(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30.h,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppThemes.getFillColor(),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  "${HiveHelp.read(Keys.userProfile)}"),
                                              fit: BoxFit.cover)),
                                    ),
                                    HSpace(20.w),
                                    Text(storedLanguage['My Self'] ?? "My Self",
                                        style: context.t.bodyMedium),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(() => AddRecipientsScreen(type: "1"));
                              },
                              borderRadius: Dimensions.kBorderRadius,
                              child: Ink(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.h, horizontal: 24.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30.h,
                                      height: 30.h,
                                      child: Icon(Icons.person),
                                    ),
                                    HSpace(20.w),
                                    Text(
                                        storedLanguage['Someone Else'] ??
                                            "Someone Else",
                                        style: context.t.bodyMedium),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          VSpace(10.h),
                        ],
                      ),
                    ),
                  ]))));
    },
  );
}
