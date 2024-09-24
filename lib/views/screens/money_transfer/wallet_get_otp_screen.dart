import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/money_transfer_controller.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class WalletGetOtpScreen extends StatelessWidget {
  const WalletGetOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MoneyTransferController.to.maskPhone();
    MoneyTransferController.to.maskEmail();
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyTransferController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
          title:storedLanguage['Get OTP'] ?? "Get OTP",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              children: [
                VSpace(30.h),
                buildTile(
                  onTap: () {
                    _.selectedOption = "sms";
                    _.update();
                  },
                  selectedBgColor: _.selectedOption == "sms"
                      ? Get.isDarkMode
                          ? AppColors.mainColor
                          : AppColors.blackColor
                      : Colors.transparent,
                  selectedDoneColor: _.selectedOption == "sms"
                      ? Get.isDarkMode
                          ? AppColors.blackColor
                          : AppColors.whiteColor
                      : Colors.transparent,
                  selectedBorderColor: _.selectedOption != "sms"
                      ? Get.isDarkMode
                          ? AppColors.greyColor
                          : AppColors.greyColor
                      : Colors.transparent,
                  context: context,
                  img: "$rootImageDir/sms.png",
                  title:storedLanguage['SMS Verify'] ?? "SMS Verify",
                  description:
                      "We will send an OTP to this number ${_.userPhoneNumber}.",
                ),
                buildTile(
                  onTap: () {
                    _.selectedOption = "email";
                    _.update();
                  },
                  selectedBgColor: _.selectedOption == "email"
                      ? Get.isDarkMode
                          ? AppColors.mainColor
                          : AppColors.blackColor
                      : Colors.transparent,
                  selectedDoneColor: _.selectedOption == "email"
                      ? Get.isDarkMode
                          ? AppColors.blackColor
                          : AppColors.whiteColor
                      : Colors.transparent,
                  selectedBorderColor: _.selectedOption != "email"
                      ? Get.isDarkMode
                          ? AppColors.greyColor
                          : AppColors.greyColor
                      : Colors.transparent,
                  padding: EdgeInsets.all(13.h),
                  context: context,
                  img: "$rootImageDir/email_otp.png",
                  title:storedLanguage['Email Verify'] ?? "Email Verify",
                  description:
                      "We will send an OTP to this email ${_.userEmail}",
                ),
                buildTile(
                  onTap: () {
                    _.selectedOption = "both";
                    _.update();
                  },
                  selectedBgColor: _.selectedOption == "both"
                      ? Get.isDarkMode
                          ? AppColors.mainColor
                          : AppColors.blackColor
                      : Colors.transparent,
                  selectedDoneColor: _.selectedOption == "both"
                      ? Get.isDarkMode
                          ? AppColors.blackColor
                          : AppColors.whiteColor
                      : Colors.transparent,
                  selectedBorderColor: _.selectedOption != "both"
                      ? Get.isDarkMode
                          ? AppColors.greyColor
                          : AppColors.greyColor
                      : Colors.transparent,
                  padding: EdgeInsets.all(14.h),
                  context: context,
                  img: "$rootImageDir/both.png",
                  title:storedLanguage['Both Email & SMS'] ?? "Both Email & SMS",
                  description: "We sent an OTP code to your email & sms both.",
                ),
                buildTile(
                  onTap: () {
                    _.selectedOption = "whatsapp";
                    _.update();
                  },
                  selectedBgColor: _.selectedOption == "whatsapp"
                      ? Get.isDarkMode
                          ? AppColors.mainColor
                          : AppColors.blackColor
                      : Colors.transparent,
                  selectedDoneColor: _.selectedOption == "whatsapp"
                      ? Get.isDarkMode
                          ? AppColors.blackColor
                          : AppColors.whiteColor
                      : Colors.transparent,
                  selectedBorderColor: _.selectedOption != "whatsapp"
                      ? Get.isDarkMode
                          ? AppColors.greyColor
                          : AppColors.greyColor
                      : Colors.transparent,
                  context: context,
                  img: "$rootImageDir/whatsapp.png",
                  title:storedLanguage['Whatsapp Verify'] ?? "Whatsapp Verify",
                  description: "We sent an OTP code to your whatsapp number.",
                ),
                VSpace(40.h),
                AppButton(
                  isLoading: _.isSendingOTP ? true : false,
                  onTap: _.isSendingOTP
                      ? null
                      : () async {
                          if (_.selectedOption.isEmpty) {
                            Helpers.showSnackBar(
                                msg: "Please select a verify option first.");
                          } else {
                            await _.getTransferOtp(option: _.selectedOption);
                          }
                        },
                  text: storedLanguage['Send OTP'] ?? "Send OTP",
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildTile(
      {void Function()? onTap,
      required BuildContext context,
      required String img,
      required String title,
      required String description,
      Color? selectedBorderColor,
      Color? selectedBgColor,
      Color? selectedDoneColor,
      EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: InkWell(
        borderRadius: Dimensions.kBorderRadius,
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppThemes.getDarkCardColor(),
            borderRadius: Dimensions.kBorderRadius,
          ),
          child: Row(
            children: [
              Container(
                height: 50.h,
                width: 50.h,
                padding: padding ?? EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : AppColors.sliderInActiveColor.withOpacity(.5),
                  borderRadius: Dimensions.kBorderRadius,
                ),
                child: Image.asset(
                  img,
                  fit: BoxFit.cover,
                ),
              ),
              HSpace(12.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: context.t.bodyMedium?.copyWith(
                            fontSize: 20.sp, fontWeight: FontWeight.w600)),
                    VSpace(3.h),
                    Text(description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.t.bodySmall
                            ?.copyWith(color: AppThemes.getParagraphColor())),
                  ],
                ),
              ),
              HSpace(12.w),
              Container(
                height: 18.h,
                width: 18.h,
                decoration: BoxDecoration(
                  color: selectedBgColor ?? Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedBorderColor ?? AppColors.greyColor,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.done,
                    size: 12.h,
                    color: selectedDoneColor ?? Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
