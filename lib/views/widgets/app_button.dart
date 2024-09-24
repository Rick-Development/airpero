import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../utils/services/helpers.dart';

class AppButton extends StatelessWidget {
  final void Function()? onTap;
  final String? text;
  final TextStyle? style;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? maxWidth;
  final double? maxHeight;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final bool? isLoading;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;

  const AppButton({
    super.key,
    this.onTap,
    this.text,
    this.style,
    this.buttonWidth,
    this.buttonHeight,
    this.maxWidth,
    this.maxHeight,
    this.bgColor,
    this.isLoading = false,
    this.borderRadius,
    this.padding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? Dimensions.kBorderRadius,
      child: Container(
        constraints: BoxConstraints(
          minWidth: buttonWidth ?? double.maxFinite,
          minHeight: buttonHeight ?? Dimensions.buttonHeight,
          maxWidth: maxWidth ?? double.maxFinite,
          maxHeight: maxHeight ?? Dimensions.buttonHeight,
        ),
        child: Ink(
          width: buttonWidth ?? double.maxFinite,
          height: buttonHeight ?? Dimensions.buttonHeight,
          padding: padding,
          decoration: BoxDecoration(
            border: border,
            color: bgColor == null
                ? Get.isDarkMode == true
                    ? AppColors.mainColor
                    : AppColors.blackColor
                : this.bgColor,
            borderRadius: borderRadius ?? Dimensions.kBorderRadius,
          ),
          child: Center(
            child: isLoading == true
                ? Helpers.appLoader(color: AppColors.whiteColor)
                : Text(
                    text ?? "Continue",
                    style: style ??
                        t.bodyLarge?.copyWith(
                            fontSize: 20.sp,
                            color: Get.isDarkMode
                                ? AppColors.blackColor
                                : AppColors.whiteColor),
                  ),
          ),
        ),
      ),
    );
  }
}
