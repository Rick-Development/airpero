import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/views/screens/money_request/money_request_history_details_screen.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../routes/routes_name.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import '../home/home_screen.dart';

class MoneyRequestHistoryScreen extends StatelessWidget {
  final bool? isFromMoneyRequestPage;
  const MoneyRequestHistoryScreen(
      {super.key, this.isFromMoneyRequestPage = false});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<MoneyRequestListController>(builder: (_) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          if (isFromMoneyRequestPage == true) {
            Get.offAllNamed(RoutesName.bottomNavBar);
          } else {
            Get.back();
          }
        },
        child: Scaffold(
          appBar: buildAppbar(storedLanguage, context, isFromMoneyRequestPage),
          body: RefreshIndicator(
            color: AppColors.mainColor,
            onRefresh: () async {
              _.resetDataAfterSearching(isFromOnRefreshIndicator: true);
              await _.getMoneyRequestHistory(
                page: 1,
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
                            itemCount: 20, isReverseColor: true)
                        : _.moneyRequestList.isEmpty
                            ? Helpers.notFound()
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: _.moneyRequestList.length,
                                itemBuilder: (context, i) {
                                  var data = _.moneyRequestList[i];
                                  return InkWell(
                                    borderRadius: Dimensions.kBorderRadius,
                                    onTap: () {
                                      if (data.rcpUser == null ||
                                          data.reqUser == null) {
                                        Helpers.showSnackBar(
                                            msg: "Requested user is not found");
                                      } else {
                                        Get.to(() =>
                                            MoneyRequestHistoryDetailsScreen(
                                                data: data));
                                      }
                                    },
                                    child: Ink(
                                      width: double.maxFinite,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40.h,
                                            height: 40.h,
                                            child: Image.asset(
                                              data.requesterId.toString() !=
                                                      ProfileController
                                                          .to.userId
                                                  ? "$rootImageDir/increment.png"
                                                  : "$rootImageDir/decrement.png",
                                            ),
                                          ),
                                          HSpace(12.w),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 10,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            data.requesterId.toString() ==
                                                                    ProfileController
                                                                        .to
                                                                        .userId
                                                                ? data.rcpUser ==
                                                                        null
                                                                    ? "Request sent to"
                                                                    : "Request sent to" +
                                                                        " " +
                                                                        data.rcpUser!
                                                                            .firstname +
                                                                        " " +
                                                                        data.rcpUser!
                                                                            .lastname
                                                                : data.reqUser ==
                                                                        null
                                                                    ? "Received request from"
                                                                    : "Received request from" +
                                                                        " " +
                                                                        data.reqUser!
                                                                            .firstname +
                                                                        " " +
                                                                        data.reqUser!
                                                                            .lastname,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            style: t.bodyMedium,
                                                          ),
                                                          VSpace(3.h),
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMM yyyy')
                                                                .format(DateTime
                                                                    .parse(data
                                                                        .createdAt
                                                                        .toString())),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: t.bodySmall
                                                                ?.copyWith(
                                                              color: AppThemes
                                                                  .getBlack50Color(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    HSpace(3.w),
                                                    Flexible(
                                                      flex: 7,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          data.amount
                                                                  .toString() +
                                                              " " +
                                                              data.currency
                                                                  .toString(),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: t.bodyMedium,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      top: 15.h),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .black70
                                                                : AppColors
                                                                    .black20,
                                                            width: .2)),
                                                  ),
                                                ),
                                              ],
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
        ),
      );
    });
  }

  CustomAppBar buildAppbar(
    storedLanguage,
    BuildContext context,
    isFromMoneyRequestPage,
  ) {
    return CustomAppBar(
      title: storedLanguage['Money Request List'] ?? "Money Request List",
      onBackPressed: () {
        if (isFromMoneyRequestPage == true) {
          Get.offAllNamed(RoutesName.bottomNavBar);
        } else {
          Get.back();
        }
      },
    );
  }
}
