import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'app_colors.dart';

Widget primaryButton(
  BuildContext context, {
  required String title,
  Function()? onTap,
  Color? color,
  bool isOutlined = false,
  double? radius,
  double? width,

}) =>
    InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Container(
        width: width,
        height: 56,
        decoration: BoxDecoration(
          border: isOutlined
              ? Border.all(
                  color: color ?? AppColors.blackColor,
                )
              : null,
          color:
              isOutlined ? Colors.transparent : color ?? AppColors.blackColor,
          borderRadius: BorderRadius.circular(radius ?? 30),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color:
                    isOutlined ? color ?? AppColors.primaryColor : Colors.black,
              ),
        ),
      ),
    );

Widget secondaryButton(
  BuildContext context, {
  required String title,
  required String svg,
  Function()? onTap,
  Color? color,
}) =>
    InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
                  color: color ?? const Color(0xCCE5EBF0),
                )
              ,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svgs/$svg.svg'),
            const Gap(16),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
