import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import 'package:waiz/utils/services/localstorage/keys.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';
import 'onbording_data.dart';

class OnbordingScreen extends StatefulWidget {
  const OnbordingScreen({super.key});

  @override
  State<OnbordingScreen> createState() => _OnbordingScreenState();
}

class _OnbordingScreenState extends State<OnbordingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: onBordingDataList.length,
                onPageChanged: (i) {
                  setState(() {
                    currentIndex = i;
                  });
                },
                itemBuilder: (context, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (i == 1)
                        Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Center(
                            child: Image.asset(
                              onBordingDataList[i].imagePath,
                              height: 340.h,
                              width: 340.h,
                              fit: currentIndex == 1
                                  ? BoxFit.fill
                                  : BoxFit.cover,
                            ),
                          ),
                        ),
                      if (i == 0)
                        Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  HSpace(24.w),
                                  Container(
                                    height: 380.h,
                                    width: 250.w,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 176.w,
                                          height: 230.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.mainColor,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(48.r),
                                              bottomRight: Radius.circular(8.r),
                                              topLeft: Radius.circular(8.r),
                                              topRight: Radius.circular(8.r),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: 110.h,
                                            left: 0,
                                            right: 0,
                                            child: Image.asset(
                                              "$rootImageDir/onboarding_circle.png",
                                              height: 292.h,
                                              width: 292.h,
                                              fit: BoxFit.cover,
                                            )),
                                        Positioned(
                                            top: 30.h,
                                            left: -35.w,
                                            right: 0,
                                            child: Image.asset(
                                              "$rootImageDir/onbording_1.png",
                                              height: 350.h,
                                              width: 282.h,
                                              fit: BoxFit.fitHeight,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Image.asset(
                                    "$rootImageDir/money_transfer_text.png",
                                    height: 360.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  HSpace(24.w),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (i == 2)
                        Column(
                          children: [
                            SizedBox(
                              width: 380.w,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: 340.h,
                                    height: 340.h,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.mainColor.withOpacity(.4),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Positioned(
                                    top: 70.h,
                                    left: 10.w,
                                    child: Container(
                                      width: 50.h,
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(28.r),
                                          bottomRight: Radius.circular(4.r),
                                          topLeft: Radius.circular(4.r),
                                          topRight: Radius.circular(4.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -100.h,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Image.asset(
                                      onBordingDataList[i].imagePath,
                                      height: 346.h,
                                      width: 380.w,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      VSpace(59.h),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Text(
                          onBordingDataList[i].title,
                          textAlign: TextAlign.center,
                          style: t.titleLarge?.copyWith(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      VSpace(12.h),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Text(
                          onBordingDataList[i].description,
                          textAlign: TextAlign.center,
                          style: t.displayMedium?.copyWith(
                            height: 1.5,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      VSpace(44.h),
                      Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: onBordingDataList.length,
                          axisDirection: Axis.horizontal,
                          effect: ExpandingDotsEffect(
                              dotColor: AppColors.black10,
                              dotHeight: 10.h,
                              dotWidth: 10.h,
                              activeDotColor: AppColors.mainColor),
                        ),
                      ),
                      VSpace(30.h),
                    ],
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            margin: EdgeInsets.only(bottom: 80.h),
            padding: Dimensions.kDefaultPadding,
            child: Row(
              mainAxisAlignment: (currentIndex == onBordingDataList.length - 1)
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                currentIndex == onBordingDataList.length - 1
                    ? const SizedBox(
                        height: 1,
                        width: 1,
                      )
                    : InkWell(
                        onTap: () {
                          controller.animateToPage(onBordingDataList.length,
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOutQuint);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Text(
                            storedLanguage['Skip'] ?? "Skip",
                            style: t.displayMedium?.copyWith(
                              color: AppColors.greyColor,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                (currentIndex == onBordingDataList.length - 1)
                    ? AppButton(
                        text: (currentIndex == onBordingDataList.length - 1)
                            ? storedLanguage['Get Started'] ?? "Get Started"
                            : storedLanguage['Next'] ?? "Next",
                        onTap: () {
                          (currentIndex == (onBordingDataList.length - 1))
                              ? Get.offAllNamed(RoutesName.loginScreen)
                              : controller.nextPage(
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOutQuint);
                          if ((currentIndex ==
                              (onBordingDataList.length - 1))) {
                            HiveHelp.write(Keys.isNewUser, false);
                          }
                        },
                        buttonWidth:
                            (currentIndex == onBordingDataList.length - 1)
                                ? 142.h
                                : 100.h,
                        buttonHeight:
                            (currentIndex == onBordingDataList.length - 1)
                                ? 42.h
                                : 36.h,
                        style: t.displayMedium?.copyWith(
                          color: Get.isDarkMode
                              ? AppColors.blackColor
                              : AppColors.whiteColor,
                          fontSize: 18.sp,
                        ),
                      )
                    : InkResponse(
                        onTap: () {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOutQuint);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "$rootImageDir/next_shape.png",
                              color: AppColors.mainColor,
                              width: 46.w,
                              height: 42.h,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              "$rootImageDir/double_arrow.png",
                              height: 28.h,
                              width: 28.h,
                            ),
                          ],
                        ),
                      ),
              ],
            )),
      ),
    );
  }
}
