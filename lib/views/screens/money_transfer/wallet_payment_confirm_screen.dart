import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/wallet_controller.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/money_transfer_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_textfield.dart';

class WalletPaymentConfirmScreen extends StatelessWidget {
  const WalletPaymentConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyTransferController>(builder: (_) {
      return Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
        appBar: CustomAppBar(
          bgColor:
              Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
          title:storedLanguage['Confirm'] ?? "Confirm",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              children: [
                VSpace(30.h),
                Text(
                storedLanguage['Enter your OTP'] ??  "Enter your OTP",
                  style: context.t.bodyMedium?.copyWith(fontSize: 20.sp),
                ),
                VSpace(40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 64.h,
                      width: 50.w,
                      padding: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: AppTextField(
                          obscureText: true,
                          autofocus: true,
                          style: context.t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                          controller: _.pin1,
                          onChanged: (v) {
                            if (v.length == 1) {
                              FocusManager.instance.primaryFocus?.nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.zero,
                          textAlign: TextAlign.center,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                        ),
                      ),
                    ),
                    HSpace(20.w),
                    Container(
                      height: 64.h,
                      width: 50.w,
                      padding: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: AppTextField(
                          obscureText: true,
                          style: context.t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                          controller: _.pin2,
                          onChanged: (v) {
                            if (v.length == 1) {
                              FocusManager.instance.primaryFocus?.nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.zero,
                          textAlign: TextAlign.center,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                        ),
                      ),
                    ),
                    HSpace(20.w),
                    Container(
                      height: 64.h,
                      width: 50.w,
                      padding: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: AppTextField(
                          obscureText: true,
                          style: context.t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                          controller: _.pin3,
                          onChanged: (v) {
                            if (v.length == 1) {
                              FocusManager.instance.primaryFocus?.nextFocus();
                            }
                          },
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.zero,
                          textAlign: TextAlign.center,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                        ),
                      ),
                    ),
                    HSpace(20.w),
                    Container(
                      height: 64.h,
                      width: 50.w,
                      padding: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkCardColor
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: AppTextField(
                          obscureText: true,
                          style: context.t.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                          controller: _.pin4,
                          onChanged: (v) {
                            if (v.length == 1) {
                              Helpers.hideKeyboard();
                            }
                          },
                          keyboardType: TextInputType.number,
                          contentPadding: EdgeInsets.zero,
                          textAlign: TextAlign.center,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                VSpace(100.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t receive OTP?",
                      style: context.t.displayMedium
                          ?.copyWith(color: AppThemes.getParagraphColor()),
                    ),
                    _.isStartTimer
                        ? HSpace(10.w)
                        : TextButton(
                            onPressed: () async {
                              _.startTimer();
                              await _.getTransferOtp(option: _.selectedOption);
                            },
                            child: Text(
                              "Resend OTP",
                              style: context.t.bodyMedium,
                            ),
                          ),
                    _.isStartTimer == false
                        ? const SizedBox()
                        : Text("${_.counter}s", style: context.t.displayMedium),
                  ],
                ),
                VSpace(40.h),
                AppButton(
                  isLoading: _.isLoading || WalletController.to.isLoading
                      ? true
                      : false,
                  onTap: _.isLoading || WalletController.to.isLoading
                      ? null
                      : () async {
                          if (_.pin1.text.isEmpty ||
                              _.pin2.text.isEmpty ||
                              _.pin3.text.isEmpty ||
                              _.pin4.text.isEmpty) {
                            Helpers.showSnackBar(
                                msg: "OTP fields are required");
                          } else {
                            await _.transferOtp(fields: {
                              "otp":
                                  "${_.pin1.text}${_.pin2.text}${_.pin3.text}${_.pin4.text}"
                            });
                          }
                        },
                  text: storedLanguage['Confirm'] ?? "Confirm",
                ),
                VSpace(30.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
