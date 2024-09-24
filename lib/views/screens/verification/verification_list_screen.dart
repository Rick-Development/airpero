import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/spacing.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import 'identity_verification_screen.dart';

class VerificationListScreen extends StatelessWidget {
  const VerificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<VerificationController>(builder: (verifyCtrl) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Identity Verification'] ??
              'Identity Verification',
          leading: verifyCtrl.isFromCheckStatus == true
              ? SizedBox()
              : IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Image.asset(
                    "$rootImageDir/back.png",
                    height: 22.h,
                    width: 22.h,
                    color: AppThemes.getIconBlackColor(),
                    fit: BoxFit.fitHeight,
                  )),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await verifyCtrl.getVerificationList();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(40.h),
                  verifyCtrl.isLoading
                      ? Helpers.appLoader()
                      : verifyCtrl.categoryNameList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: verifyCtrl.categoryNameList.length,
                              itemBuilder: (context, i) {
                                var data = verifyCtrl.categoryNameList[i];
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: Dimensions.kBorderRadius,
                                  ),
                                  onTap: verifyCtrl.isGettingSingleVerification
                                      ? null
                                      : () async {
                                          verifyCtrl.selectedVerficationIndex =
                                              i;
                                          verifyCtrl.update();
                                          await verifyCtrl
                                              .getSingleVerification(
                                                  id: data.id.toString());
                                          await verifyCtrl.filterData();
                                          Get.to(() =>
                                              IdentityVerificationScreen(
                                                  id: data.id.toString(),
                                                  verificationType:
                                                      data.categoryName));
                                        },
                                  leading: Container(
                                      height: 36.h,
                                      width: 36.h,
                                      padding: EdgeInsets.all(8.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                        color: AppThemes.getFillColor(),
                                      ),
                                      child: Image.asset(
                                        "$rootImageDir/tick-mark.png",
                                      )),
                                  title: Text(data.categoryName,
                                      style: t.displayMedium),
                                  trailing: Container(
                                    height: 36.h,
                                    width: 36.h,
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: AppThemes.getFillColor(),
                                    ),
                                    child: verifyCtrl
                                                .isGettingSingleVerification &&
                                            verifyCtrl
                                                    .selectedVerficationIndex ==
                                                i
                                        ? CircularProgressIndicator(
                                            color: Get.isDarkMode
                                                ? AppColors.mainColor
                                                : AppColors.blackColor)
                                        : Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16.h,
                                            color: AppThemes.getGreyColor(),
                                          ),
                                  ),
                                );
                              }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
