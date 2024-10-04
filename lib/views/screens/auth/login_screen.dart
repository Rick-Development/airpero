import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import 'package:waiz/views/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../controllers/auth_controller.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_button.dart';
import '../../widgets/spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    AuthController controller = Get.find<AuthController>();
    TextTheme t = Theme.of(context).textTheme;
    //--------------REMEMBER ME----------------
    if (HiveHelp.read(Keys.userName) != null &&
        HiveHelp.read(Keys.userPass) != null &&
        HiveHelp.read(Keys.isRemember) != null) {
      if (HiveHelp.read(Keys.isRemember) == true) {
        controller.userNameEditingController.text =
            HiveHelp.read(Keys.userName);
        controller.signInPassEditingController.text =
            HiveHelp.read(Keys.userPass);
        controller.userNameVal = HiveHelp.read(Keys.userName);
        controller.singInPassVal = HiveHelp.read(Keys.userPass);
      }
    }
    if (HiveHelp.read(Keys.isRemember) != null) {
      controller.isRemember = HiveHelp.read(Keys.isRemember);
    }
    return GetBuilder<AuthController>(builder: (_) {
      return Scaffold(
          body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  "$rootImageDir/shape.png",
                  height: 153.h,
                  fit: BoxFit.cover,
                  color: AppColors.mainColor.withOpacity(.1),
                )),
            Padding(
              padding: Dimensions.kDefaultPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VSpace(159.h),
                    Text(storedLanguage['Log In'] ?? "Log In",
                        style: t.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 30.sp,
                        )),
                    VSpace(12.h),
                    Text(
                        storedLanguage['Hello there, log in to continue!'] ??
                            "Hello there, log in to continue!",
                        style: t.displayMedium
                            ?.copyWith(color: AppThemes.getParagraphColor())),
                    VSpace(100.h),
                    CustomTextField(
                      hintext: storedLanguage['Username or Email'] ??
                          "Username or Email",
                      isPrefixIcon: true,
                      prefixIcon: 'person',
                      controller: controller.userNameEditingController,
                      onChanged: (v) {
                        controller.userNameVal = v;
                        controller.update();
                      },
                    ),
                    VSpace(32.h),
                    CustomTextField(
                      hintext: storedLanguage['Password'] ?? "Password",
                      isPrefixIcon: true,
                      isSuffixIcon: true,
                      obsCureText: controller.isNewPassShow ? true : false,
                      prefixIcon: 'lock',
                      suffixIcon: controller.isNewPassShow ? 'hide' : 'show',
                      controller: controller.signInPassEditingController,
                      onChanged: (v) {
                        controller.singInPassVal = v;
                        controller.update();
                      },
                      onSuffixPressed: () {
                        controller.isNewPassShow = !controller.isNewPassShow;
                        controller.update();
                      },
                    ),
                    VSpace(24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: .82,
                              child: Checkbox(
                                  checkColor: Get.isDarkMode
                                      ? AppColors.blackColor
                                      : AppColors.whiteColor,
                                  activeColor: Get.isDarkMode
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                  visualDensity: const VisualDensity(
                                    horizontal:
                                        -4.0, // Adjust the horizontal padding
                                    vertical:
                                        -4.0, // Adjust the vertical padding
                                  ),
                                  side: BorderSide(
                                    color: AppThemes.getHintColor(),
                                  ),
                                  value: controller.isRemember,
                                  onChanged: (v) {
                                    controller.isRemember = v!;
                                    HiveHelp.write(Keys.isRemember, v);
                                    controller.update();
                                  }),
                            ),
                            HSpace(5.w),
                            Text(
                              storedLanguage['Remember me'] ?? "Remember me",
                              style: t.bodySmall?.copyWith(
                                fontSize: 16.sp,
                                color: Get.isDarkMode
                                    ? AppColors.whiteColor
                                    : AppColors.black30,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(RoutesName.forgotPassScreen);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              child: Text(
                                storedLanguage['Forgot Your Password?'] ??
                                    "Forgot Your Password?",
                                style: t.displayMedium?.copyWith(
                                  fontSize: 18.sp,
                                ),
                              )),
                        )
                      ],
                    ),
                    VSpace(48.h),
                    Material(
                      color: Colors.transparent,
                      child: AppButton(
                        text: storedLanguage['Log In'] ?? "Log In",
                        style: t.bodyLarge?.copyWith(
                            fontSize: 20.sp,
                            color: controller.userNameVal.isEmpty ||
                                    controller.singInPassVal.isEmpty
                                ? AppColors.whiteColor
                                : Get.isDarkMode
                                    ? AppColors.blackColor
                                    : AppColors.whiteColor),
                        isLoading: controller.isLoading ? true : false,
                        bgColor: !controller.userNameVal.isEmpty ||
                                !controller.singInPassVal.isEmpty
                            ? AppThemes.getInactiveColor()
                            : Get.isDarkMode
                                ? AppColors.mainColor
                                : AppColors.blackColor,
                        onTap: !controller.userNameVal.isEmpty ||
                                !controller.singInPassVal.isEmpty
                            ? null
                            : controller.isLoading
                                ? null
                                : () async {
                                    Helpers.hideKeyboard();
                                    await controller.login();
                                  },
                      ),
                    ),
                    VSpace(118.h),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        storedLanguage['Don\'t have an account?'] ??
                            "Don’t have an account?",
                        style: t.displayMedium?.copyWith(
                          color: AppThemes.getHintColor(),
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(RoutesName.signUpScreen);
                        },
                        child: Text(
                          storedLanguage['Create account'] ?? "Create account",
                          style: t.bodyMedium?.copyWith(
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
    });
  }
}
