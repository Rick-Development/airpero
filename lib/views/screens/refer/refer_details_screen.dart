import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/mediaquery_extension.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../data/models/refer_list_model.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class ReferDetailsScreen extends StatelessWidget {
  final ReferUser? data;
  const ReferDetailsScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ReferController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Referral User Details'] ??
              'Referral User Details',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Dimensions.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VSpace(40.h),
                Container(
                  height: 415.h,
                  width: context.mQuery.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                        width: .2),
                    borderRadius: Dimensions.kBorderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Full Name'] ?? "Full Name",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  "${data?.firstname} ${data?.lastname}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        height: .2,
                        width: context.mQuery.width,
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Email'] ?? "Email",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("${data?.email}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        height: .2,
                        width: context.mQuery.width,
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Phone'] ?? "Phone",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("${data?.phone}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        height: .2,
                        width: context.mQuery.width,
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Country Name'] ?? "Country Name",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("${data?.country}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        height: .2,
                        width: context.mQuery.width,
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Address One']?? "Address One",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("${data?.addressOne}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        height: .2,
                        width: context.mQuery.width,
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Address Two'] ?? "Address Two",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("${data?.addressTwo}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                      Container(
                        height: .2,
                        width: context.mQuery.width,
                        color: Get.isDarkMode
                            ? AppColors.black50
                            : AppColors.black30,
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Row(
                          children: [
                            Text(storedLanguage['Join Date'] ?? "Join Date",
                                style: context.t.displayMedium?.copyWith(
                                    color: AppThemes.getParagraphColor())),
                            HSpace(20.w),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  "${DateFormat('dd MMM yyyy').format(DateTime.parse(data!.join_date.toString()))}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
