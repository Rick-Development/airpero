import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/refer_controller.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import 'refer_details_screen.dart';

class ReferScreen extends StatelessWidget {
  const ReferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ReferController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : Color(0xffF3F4F6),
        appBar: CustomAppBar(
          title: storedLanguage['Refer & Earn Money'] ?? 'Refer & Earn Money',
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getRefer(page: 1, isLoadMoreRunning: true);
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
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(15.h),
                          margin: EdgeInsets.only(top: 30.h),
                          decoration: BoxDecoration(
                            color: AppThemes.getDarkCardColor(),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _.referStatus == true
                                            ? "INVITE AND GET \$${_.earnAmount}"
                                            : "INVITE YOUR FRIENDS TO JOIN US",
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                        style: context.t.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold)),
                                    VSpace(10.h),
                                    Text(storedLanguage['Share your link'] ?? "Share your link",
                                        style: context.t.bodyMedium),
                                    VSpace(5.h),
                                    Container(
                                      constraints: BoxConstraints(
                                        minHeight: 40.h,
                                        maxHeight: 88.h,
                                      ),
                                      width: double.maxFinite,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: Get.isDarkMode
                                            ? AppColors.darkBgColor
                                            : Color(0xffF3F4F6),
                                        border: Border.all(
                                            color: Get.isDarkMode
                                                ? AppColors.black50
                                                : AppColors.black30,
                                            width: .2),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${_.url}",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: context.t.bodySmall
                                                  ?.copyWith(
                                                      color: Get.isDarkMode
                                                          ? AppColors.whiteColor
                                                          : AppColors
                                                              .blackColor),
                                            ),
                                          ),
                                          InkResponse(
                                            onTap: () {
                                              Clipboard.setData(
                                                  new ClipboardData(
                                                      text: "${_.url}"));

                                              Helpers.showToast(
                                                  msg: "Copied Successfully",
                                                  gravity: ToastGravity.CENTER,
                                                  bgColor: AppColors.whiteColor,
                                                  textColor:
                                                      AppColors.blackColor);
                                            },
                                            child: Image.asset(
                                              "$rootImageDir/copy.png",
                                              color: Get.isDarkMode
                                                  ? AppColors.whiteColor
                                                  : AppColors.blackColor,
                                              height: 20.h,
                                              width: 20.h,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              HSpace(30.w),
                              Transform.rotate(
                                angle: .2,
                                child: Image.asset(
                                  "$rootImageDir/envelope.png",
                                  height: 90.h,
                                  width: 90.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_.referStatus == true) ...[
                          VSpace(30.h),
                          Container(
                            height: 200.h,
                            width: double.maxFinite,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColor
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storedLanguage['They Get'] ?? "They Get",
                                  style: context.t.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                VSpace(12.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.done_rounded,
                                          size: 16.h,
                                          color: AppColors.whiteColor),
                                    ),
                                    HSpace(10.w),
                                    Expanded(
                                      child: Text(
                                        "A fee-free transfer up to \$${_.freeTransfer} when they sign up through you",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.displayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VSpace(20.h),
                          Container(
                            height: 200.h,
                            width: double.maxFinite,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? AppColors.darkCardColor
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storedLanguage['You Get'] ?? "You Get",
                                  style: context.t.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                VSpace(12.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.done_rounded,
                                          size: 16.h,
                                          color: AppColors.whiteColor),
                                    ),
                                    HSpace(10.w),
                                    Expanded(
                                      child: Text(
                                        "Instant \$${_.earnAmount}  when they deposit any amount first time",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.displayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                VSpace(15.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(4.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.greenColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.done_rounded,
                                          size: 16.h,
                                          color: AppColors.whiteColor),
                                    ),
                                    HSpace(10.w),
                                    Expanded(
                                      child: Text(
                                        "A fee-free transfer up to \$${_.freeTransfer}  when they sign up through you",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: context.t.displayMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                        VSpace(40.h),
                        Container(
                          padding: EdgeInsets.all(20.h),
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? AppColors.darkCardColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_.referList.length} invited friends",
                                    style: context.t.bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 40.h,
                                    child: TextButton(
                                        onPressed: () {
                                          if (_.referList.isNotEmpty) {
                                            Get.toNamed(
                                                RoutesName.referListScreen);
                                          } else {
                                            Helpers.showSnackBar(
                                                msg: "No data found");
                                          }
                                        },
                                        child: Text(
                                          storedLanguage['See more'] ??
                                              "See more",
                                          style: context.t.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: .2,
                                color: Get.isDarkMode
                                    ? AppColors.black30
                                    : AppColors.black20,
                              ),
                              VSpace(15.h),
                              _.referList.isEmpty
                                  ? Center(
                                      child: Text(
                                        "No data found",
                                        style: context.t.bodyLarge,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 3,
                                      itemBuilder: (context, i) {
                                        int clampedIndex =
                                            i.clamp(0, _.referList.length);
                                        var data = _.referList[clampedIndex];
                                        return Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 15.h),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(() => ReferDetailsScreen(
                                                  data: data));
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10.h),
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .textFieldHintColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                      "${data.firstname.toString().substring(0, 1).toUpperCase()}${data.lastname.toString().substring(0, 1).toUpperCase()}",
                                                      style: context.t.bodySmall
                                                          ?.copyWith(
                                                              color: AppColors
                                                                  .blackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                                HSpace(20.w),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "${data.firstname} ${data.lastname}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: context
                                                            .t.bodyMedium),
                                                    VSpace(5.h),
                                                    Text("${data.email}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: context
                                                            .t.bodySmall),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}
