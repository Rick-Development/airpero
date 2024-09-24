import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class CardTransactionScreen extends StatelessWidget {
  const CardTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<CardTransactionController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title:storedLanguage['Card Transaction'] ?? "Card Transaction",
        ),
        body: RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () async {
            _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
            await _.cardTransaction(
              page: 1.toString(),
              id: _.id,
            );
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _.scrollController,
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: Column(
                children: [
                  VSpace(20.h),
                  _.isLoading
                      ? buildTransactionLoader(
                          isReverseColor: true, itemCount: 20)
                      : _.virtualCartTransactionList.isEmpty
                          ? Helpers.notFound()
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _.virtualCartTransactionList.length,
                              itemBuilder: (context, i) {
                                var data = _.virtualCartTransactionList[i];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Ink(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 14.h),
                                    decoration: BoxDecoration(
                                      color: AppThemes.getFillColor(),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                          color: AppThemes.borderColor(),
                                          width: Dimensions.appThinBorder),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40.h,
                                          height: 40.h,
                                          padding: EdgeInsets.all(10.h),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                            color: AppColors.greenColor
                                                .withOpacity(.1),
                                          ),
                                          child: Image.asset(
                                            "$rootImageDir/approved.png",
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                        HSpace(12.w),
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data.providerName.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                style: context.t.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        HSpace(3.w),
                                        Flexible(
                                          flex: 7,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                "${data.amount} " +
                                                    data.currency.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: context.t.bodyMedium),
                                          ),
                                        ),
                                      ],
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
