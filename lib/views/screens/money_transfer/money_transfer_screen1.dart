import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/screens/recipients/recipients_screen.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class MoneyTransferScreen1 extends StatelessWidget {
  const MoneyTransferScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    Get.put(MoneyTransferController(), permanent: true);
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyTransferController>(builder: (_) {
      return GestureDetector(
        onTap: () {
          _.isTappedOnQuestionMark1 = false;
          _.isTappedOnQuestionMark2 = false;
          _.update();
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: storedLanguage['Money Transfer'] ?? "Money Transfer",
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await _.getTransferCurrencies(isFromRefreshIndicator: true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                          LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Text(
                                        storedLanguage['Amount'] ?? "Amount",
                                        style: t.bodyMedium)),
                                Text(storedLanguage['Recipient'] ?? "Recipient",
                                    style: t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.black20
                                            : AppColors.black80)),
                                Text(storedLanguage['Review'] ?? "Review",
                                    style: t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.black20
                                            : AppColors.black80)),
                                Text(storedLanguage['Pay'] ?? "Pay",
                                    style: t.displayMedium?.copyWith(
                                        color: Get.isDarkMode
                                            ? AppColors.black20
                                            : AppColors.black80)),
                              ],
                            );
                          }),
                          VSpace(10.h),
                          LayoutBuilder(builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Row(
                              children: [
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  storedLanguage['Send Your Money Here!'] ??
                                      "Send Your Money Here!",
                                  style: t.bodyLarge),
                              VSpace(8.h),
                              Text(
                                  storedLanguage[
                                          'Fast and reliable international money transfer app.'] ??
                                      "Fast and reliable international money transfer app.",
                                  style: t.displayMedium?.copyWith(
                                      color: AppThemes.getParagraphColor())),
                              VSpace(24.h),
                              Row(
                                children: [
                                  Text(
                                      storedLanguage['You will Send'] ??
                                          "You will Send",
                                      style: t.bodyMedium
                                          ?.copyWith(fontSize: 20.sp)),
                                  HSpace(8.w),
                                  Tooltip(
                                    preferBelow: false,
                                    message:
                                        "Enter the amount & choose the currency you'd like to transfer.",
                                    child: InkResponse(
                                      onTap: () {
                                        _.isTappedOnQuestionMark1 = true;
                                        _.isTappedOnQuestionMark2 = false;
                                        _.update();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2.h),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                AppThemes.getIconBlackColor(),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.question_mark,
                                            size: 14.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              VSpace(8.h),
                              Container(
                                height: 66.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppThemes.getDarkBgColor(),
                                  border: Border.all(
                                      color: _.isTappedOnQuestionMark1
                                          ? AppColors.greenColor
                                          : AppThemes.getSliderInactiveColor(),
                                      width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Amount is required';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: _.onChanged,
                                          controller: _.sendCtrl,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*$'),
                                            ),
                                          ],
                                          style: t.displayMedium,
                                          decoration: InputDecoration(
                                            fillColor:
                                                AppThemes.getDarkBgColor(),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.w),
                                            hintText: "0.00",
                                            hintStyle: t.bodyLarge?.copyWith(
                                                color: AppColors
                                                    .textFieldHintColor),
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Material(
                                                  child: Container(
                                                      color: AppThemes
                                                          .getDarkCardColor(),
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height *
                                                          0.6, // Half of the screen height
                                                      child: const Send()),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 45.h,
                                            width: 90.w,
                                            decoration: BoxDecoration(
                                                border: Border(
                                              left: BorderSide(
                                                color: AppThemes
                                                    .getSliderInactiveColor(),
                                              ),
                                            )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl: _
                                                        .senderInitialSelectedCountryImage,
                                                    height: 30.h,
                                                    width: 30.h,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Text(
                                                  "${_.senderInitialSelectedCurrency}",
                                                  style: t.displayMedium,
                                                ),
                                                HSpace(10.w),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: Get.isDarkMode
                                                      ? AppColors.black50
                                                      : AppColors.black30,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (double.parse(_.sendCtrl.text.isEmpty
                                      ? "0.00"
                                      : _.sendCtrl.text) <
                                  _.sendAmountInSelectedCurr)
                                Text(
                                  "Amount must be at least ${_.sendAmountInSelectedCurr} ${_.senderCurrency}",
                                  style: t.bodySmall
                                      ?.copyWith(color: AppColors.redColor),
                                ),
                              VSpace(20.h),
                              Row(children: [
                                Image.asset(
                                  "$rootImageDir/transfer1.png",
                                  height: 16.h,
                                  width: 16.h,
                                  color: AppThemes.getParagraphColor(),
                                ),
                                HSpace(8.w),
                                Text(
                                  "Transfer fee: ${_.transferFee} ${_.currency}",
                                  style: context.t.bodySmall?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                )
                              ]),
                              VSpace(14.h),
                              Row(children: [
                                Image.asset(
                                  "$rootImageDir/transfer1.png",
                                  height: 16.h,
                                  width: 16.h,
                                  color: AppThemes.getParagraphColor(),
                                ),
                                HSpace(8.w),
                                Text(
                                  "Transfer fee in local: ${_.transferFeeInLocal} ${_.senderInitialSelectedCurrency}",
                                  style: context.t.bodySmall?.copyWith(
                                      color: AppThemes.getParagraphColor()),
                                )
                              ]),
                              VSpace(14.h),
                              Row(children: [
                                Image.asset(
                                  "$rootImageDir/convert.png",
                                  height: 17.h,
                                  width: 17.h,
                                  color: AppThemes.getParagraphColor(),
                                ),
                                HSpace(8.w),
                                Expanded(
                                  child: Text(
                                    "Total amount we will convert: ${_.amountWillConvert} ${_.receiverInitialSelectedCurrency}",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.t.bodySmall?.copyWith(
                                        color: AppThemes.getParagraphColor()),
                                  ),
                                )
                              ]),
                              VSpace(32.h),
                              Row(
                                children: [
                                  Text(
                                      storedLanguage['Recipients will Get'] ??
                                          "Recipients will Get",
                                      style: t.bodyMedium
                                          ?.copyWith(fontSize: 20.sp)),
                                  HSpace(8.w),
                                  Tooltip(
                                    preferBelow: false,
                                    message:
                                        "Enter the amount & choose the recipient currency you'd like to transfer.",
                                    child: InkResponse(
                                      onTap: () {
                                        _.isTappedOnQuestionMark2 = true;
                                        _.isTappedOnQuestionMark1 = false;
                                        _.update();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(2.h),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color:
                                                AppThemes.getIconBlackColor(),
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.question_mark,
                                            size: 14.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              VSpace(8.h),
                              Container(
                                height: 66.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppThemes.getDarkBgColor(),
                                  border: Border.all(
                                      color: _.isTappedOnQuestionMark2
                                          ? AppColors.greenColor
                                          : AppThemes.getSliderInactiveColor(),
                                      width: 1),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Amount is required';
                                            } else {
                                              return null;
                                            }
                                          },
                                          onChanged: (value) {
                                            if (value
                                                .toString()
                                                .startsWith(".")) {
                                              return;
                                            }
                                            _.receiveVal = value;
                                            _.reverseCalculateReceiverAmount();
                                            _.update();
                                          },
                                          controller: _.receiveCtrl,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d*\.?\d*$'),
                                            ),
                                          ],
                                          style: t.displayMedium,
                                          decoration: InputDecoration(
                                            fillColor:
                                                AppThemes.getDarkBgColor(),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 16.w),
                                            hintText: "0.00",
                                            hintStyle: t.bodyLarge?.copyWith(
                                                color: AppColors
                                                    .textFieldHintColor),
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Material(
                                                  child: Container(
                                                      color: AppThemes
                                                          .getDarkCardColor(),
                                                      height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height *
                                                          0.6, // Half of the screen height
                                                      child: const Receive()),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 45.h,
                                            width: 90.w,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    left: BorderSide(
                                                        color: AppThemes
                                                            .getSliderInactiveColor()))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipOval(
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${_.receiverInitialSelectedCountryImage}",
                                                    height: 30.h,
                                                    width: 30.h,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Text(
                                                  "${_.receiverInitialSelectedCurrency}",
                                                  style: t.displayMedium,
                                                ),
                                                HSpace(10.w),
                                                Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: Get.isDarkMode
                                                      ? AppColors.black50
                                                      : AppColors.black30,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VSpace(50.h),
                              Material(
                                color: Colors.transparent,
                                child: AppButton(
                                    text: storedLanguage['Continue'] ??
                                        "Continue",
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              padding:
                                                  Dimensions.kDefaultPadding,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              decoration: BoxDecoration(
                                                color: AppThemes
                                                    .getDarkCardColor(),
                                                borderRadius:
                                                    Dimensions.kBorderRadius *
                                                        2,
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ListView(
                                                children: [
                                                  VSpace(32.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Where would you send\nthe money?",
                                                        style: t.titleSmall
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: Ink(
                                                            height: 26.h,
                                                            width: 26.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.h),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .darkBgColor
                                                                    : AppColors
                                                                        .sliderInActiveColor),
                                                            child: Icon(
                                                              Icons.close,
                                                              size: 15.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  VSpace(20.h),
                                                  buildTile(t,
                                                      icon: "new_recipient",
                                                      title: "New Recipient",
                                                      description:
                                                          "Give money to individuals whose contacts you do not now.",
                                                      onTap: () async {
                                                    if (_.sendCtrl.text
                                                        .isEmpty) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Send amount is required");
                                                    } else if (double.parse(
                                                            _.sendCtrl.text) <
                                                        _.sendAmountInSelectedCurr) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Amount must be at least ${_.sendAmountInSelectedCurr} ${_.senderCurrency}");
                                                    } else {
                                                      Get.back();

                                                      // firstly delete this controller otherwise  scrollController is used multiple scrollview
                                                      // error will show and others and my account list gets empty when use pull to refresh
                                                      Get.delete<
                                                          MoneyTransferController>();
                                                      RecipientListController.to
                                                              .isFromMoneyTransferPage =
                                                          true;
                                                      RecipientListController.to
                                                          .resetDataAfterSearching();
                                                      RecipientListController.to
                                                          .getRecipientList(
                                                              page: 1,
                                                              search: "");
                                                      RecipientListController
                                                          .to.type = "all";
                                                      RecipientListController
                                                              .to.filteredList =
                                                          await RecipientListController
                                                              .to.recipientList
                                                              .where((e) =>
                                                                  e.type ==
                                                                  "all")
                                                              .toList();
                                                      RecipientListController.to
                                                          .update();
                                                      _.isFromMoneyTransferPage =
                                                          true;
                                                      Get.to(() => RecipientsScreen(
                                                          countryName:
                                                              _.countryName,
                                                          isFromMoneyTransferPage:
                                                              true));
                                                      buildCreateRecipientDialog(
                                                          context,
                                                          storedLanguage);
                                                    }
                                                  }),
                                                  VSpace(20.h),
                                                  buildTile(t,
                                                      icon: "contact",
                                                      title: "Contact",
                                                      description:
                                                          "Money should be sent to one of my\ncontact lists.",
                                                      onTap: () async {
                                                    if (_.sendCtrl.text
                                                        .isEmpty) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Send amount is required");
                                                    } else if (double.parse(
                                                            _.sendCtrl.text) <
                                                        _.sendAmountInSelectedCurr) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Amount must be at least ${_.sendAmountInSelectedCurr} ${_.senderCurrency}");
                                                    } else {
                                                      Get.back();
                                                      // firstly delete this controller otherwise  scrollController is used multiple scrollview
                                                      // error will show and others and my account list gets empty when use pull to refresh
                                                      Get.delete<
                                                          MoneyTransferController>();
                                                      RecipientListController.to
                                                              .isFromMoneyTransferPage =
                                                          true;
                                                      RecipientListController.to
                                                          .resetDataAfterSearching();
                                                      RecipientListController.to
                                                          .getRecipientList(
                                                              page: 1,
                                                              search: "");
                                                      RecipientListController
                                                          .to.type = "others";
                                                      RecipientListController
                                                              .to.filteredList =
                                                          await RecipientListController
                                                              .to.recipientList
                                                              .where((e) =>
                                                                  e.type ==
                                                                  "others")
                                                              .toList();
                                                      RecipientListController.to
                                                          .update();
                                                      _.isFromMoneyTransferPage =
                                                          true;
                                                      Get.to(() => RecipientsScreen(
                                                          countryName:
                                                              _.countryName,
                                                          isFromMoneyTransferPage:
                                                              true));
                                                    }
                                                  }),
                                                  VSpace(20.h),
                                                  buildTile(t,
                                                      icon: "my_self",
                                                      title: "My Self",
                                                      description:
                                                          "Pay the remaining amount to a\nnearby bank.",
                                                      onTap: () async {
                                                    if (_.sendCtrl.text
                                                        .isEmpty) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Send amount is required");
                                                    } else if (double.parse(
                                                            _.sendCtrl.text) <
                                                        _.sendAmountInSelectedCurr) {
                                                      Helpers.showSnackBar(
                                                          msg:
                                                              "Amount must be at least ${_.sendAmountInSelectedCurr} ${_.senderCurrency}");
                                                    } else {
                                                      Get.back();
                                                      Get.delete<
                                                          MoneyTransferController>();
                                                      RecipientListController.to
                                                              .isFromMoneyTransferPage =
                                                          true;
                                                      RecipientListController.to
                                                          .resetDataAfterSearching();
                                                      RecipientListController.to
                                                          .getRecipientList(
                                                              page: 1,
                                                              search: "");

                                                      RecipientListController
                                                          .to.type = "my-self";
                                                      RecipientListController
                                                              .to.filteredList =
                                                          await RecipientListController
                                                              .to.recipientList
                                                              .where((e) =>
                                                                  e.type ==
                                                                  "my-self")
                                                              .toList();
                                                      RecipientListController.to
                                                          .update();
                                                      _.isFromMoneyTransferPage =
                                                          true;

                                                      Get.to(() => RecipientsScreen(
                                                          countryName:
                                                              _.countryName,
                                                          isFromMoneyTransferPage:
                                                              true));
                                                    }
                                                  }),
                                                ],
                                              ));
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildTile(TextTheme t,
      {required String icon,
      required String title,
      required String description,
      void Function()? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: Dimensions.kBorderRadius,
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            borderRadius: Dimensions.kBorderRadius,
            border: Border.all(color: AppThemes.getSliderInactiveColor()),
          ),
          child: Row(
            children: [
              Container(
                width: 44.h,
                height: 44.h,
                padding: EdgeInsets.all(13.h),
                decoration: BoxDecoration(
                  color: AppThemes.getSliderInactiveColor(),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "$rootImageDir/$icon.png",
                  fit: BoxFit.cover,
                  color: AppThemes.getIconBlackColor(),
                ),
              ),
              HSpace(12.w),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: t.bodyMedium?.copyWith(fontSize: 20.sp)),
                  Text(description,
                      style: t.bodySmall?.copyWith(
                        color: AppThemes.getParagraphColor(),
                        fontSize: 18.sp,
                      )),
                ],
              )),
            ],
          ),
        ),
      ),
    );
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

class Send extends StatelessWidget {
  const Send({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 18,
            right: 16,
            top: 16,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                storedLanguage['You will send'] ?? "You will send",
                style: context.t.bodyLarge?.copyWith(fontSize: 18.sp),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Get.back();
                  },
                  child: Ink(
                    height: 26.h,
                    width: 26.h,
                    padding: EdgeInsets.all(3.h),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : AppColors.sliderInActiveColor),
                    child: Icon(
                      Icons.close,
                      size: 15.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        VSpace(30.h),
        GetBuilder<MoneyTransferController>(builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _.senderCurrencyList.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = _.senderCurrencyList[i];
                  return GestureDetector(
                    onTap: () async {
                      _.senderInitialSelectedId = data.id.toString();
                      _.senderInitialSelectedCountryImage = data.countryImage;
                      _.senderInitialSelectedCurrency = data.currencyCode;
                      _.senderCurrency = data.currencyCode;
                      _.senderInitialSelectedRate = data.rate.toString();
                      await _.calculateSenderAmount();

                      RecipientListController.to.senderInitialSelectedId =
                          data.id.toString();
                      RecipientListController.to.senderInitialSelectedCurrency =
                          data.currencyCode;
                      RecipientListController.to.senderInitialSelectedRate =
                          data.rate.toString();
                      Get.back();
                      _.update();
                    },
                    child: Container(
                      color: AppThemes.getDarkCardColor(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: data.countryImage,
                                    height: 40.h,
                                    width: 40.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data.currencyCode}",
                                      style: context.t.displayMedium,
                                    ),
                                    Text(
                                      "${data.currency_name}",
                                      style: context.t.displayMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          i == _.senderCurrencyList.length
                              ? SizedBox()
                              : Divider(
                                  color: Get.isDarkMode
                                      ? AppColors.black50
                                      : AppColors.sliderInActiveColor,
                                  thickness: .3,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }
}

class Receive extends StatelessWidget {
  const Receive({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 18,
            right: 16,
            top: 16,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                storedLanguage['Recipient Will Get'] ?? "Recipient Will Get",
                style: context.t.bodyLarge?.copyWith(fontSize: 18.sp),
              ),
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Get.back();
                  },
                  child: Ink(
                    height: 26.h,
                    width: 26.h,
                    padding: EdgeInsets.all(3.h),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : AppColors.sliderInActiveColor),
                    child: Icon(
                      Icons.close,
                      size: 15.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        VSpace(30.h),
        GetBuilder<MoneyTransferController>(builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _.receiverCurrencyList.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  var data = _.receiverCurrencyList[i];
                  return GestureDetector(
                    onTap: () async {
                      _.receiverInitialSelectedId = data.id.toString();
                      _.receiverInitialSelectedCountryImage = data.countryImage;
                      _.receiverInitialSelectedCurrency = data.currencyCode;
                      _.receiverInitialSelectedRate = data.rate.toString();
                      _.countryName = data.countryName.toString();
                      RecipientListController.to.selectedCountry =
                          data.countryName.toString();
                      await _.calculateSenderAmount();
                      RecipientListController.to.receiverInitialSelectedId =
                          data.id.toString();
                      RecipientListController.to
                          .receiverInitialSelectedCurrency = data.currencyCode;
                      RecipientListController.to.receiverInitialSelectedRate =
                          data.rate.toString();
                      Get.back();
                      _.update();
                    },
                    child: Container(
                      color: AppThemes.getDarkCardColor(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: data.countryImage,
                                    height: 40.h,
                                    width: 40.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data.currencyCode}",
                                      style: context.t.displayMedium,
                                    ),
                                    Text("${data.currency_name}",
                                        style: context.t.displayMedium),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          i == _.senderCurrencyList.length
                              ? SizedBox()
                              : Divider(
                                  color: Get.isDarkMode
                                      ? AppColors.black50
                                      : AppColors.sliderInActiveColor,
                                  thickness: .3,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
        SizedBox(height: 24.h),
      ],
    );
  }
}
