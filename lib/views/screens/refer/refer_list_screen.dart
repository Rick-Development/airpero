import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import 'refer_details_screen.dart';

class ReferListScreen extends StatelessWidget {
  const ReferListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<ReferController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: storedLanguage['Refferal Users'] ?? 'Refferal Users',
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.getRefer(page: 1);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VSpace(40.h),
                  _.isLoading
                      ? Helpers.appLoader()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _.referList.length,
                          itemBuilder: (context, i) {
                            var data = _.referList[i];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(6.r),
                                onTap: () {
                                  Get.to(() => ReferDetailsScreen(data: data));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(data.image
                                                .toString()
                                                .contains('default')
                                            ? 12.h
                                            : 3.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.textFieldHintColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: data.image
                                                .toString()
                                                .contains('default')
                                            ? Text(
                                                "${data.firstname.toString().substring(0, 1).toUpperCase()}${data.lastname.toString().substring(0, 1).toUpperCase()}",
                                                style: context
                                                    .t.bodySmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .blackColor,
                                                        fontWeight:
                                                            FontWeight.bold))
                                            : ClipOval(
                                                child: CachedNetworkImage(
                                                imageUrl: "${data.image}",
                                                height: 35.h,
                                                width: 35.h,
                                                fit: BoxFit.cover,
                                              )),
                                      ),
                                      HSpace(20.w),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${data.firstname} ${data.lastname}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          context.t.bodyMedium),
                                                  VSpace(5.h),
                                                  Text("${data.email}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          context.t.bodySmall),
                                                ],
                                              )),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 16.h,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 12.h),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Get.isDarkMode
                                                          ? AppColors.black70
                                                          : AppColors.black20,
                                                      width: .2)),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                  if (_.isLoadMore == true)
                    Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                        child: Helpers.appLoader()),
                  VSpace(20.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
