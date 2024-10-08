import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/resources/views/home/bills_payment/bills_payment.dart';
import 'package:waiz/routes/routes_name.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import 'package:waiz/views/widgets/usable_bootom_sheet.dart';
import '../../../../config/app_colors.dart';
import '../../../config/dimensions.dart';
import '../../../config/styles.dart';
import '../../../resources/widgets/usable_dashboard_slider.dart';
import '../../../themes/themes.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/appDialog.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/spacing.dart';
import '../transaction/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(WalletController());
    Get.put(TransactionController());
    Get.delete<CardController>();
    TextTheme t = Theme.of(context).textTheme;
    return GetBuilder<AppController>(builder: (appCtrl) {
      var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
      return GetBuilder<AuthController>(builder: (_) {
        return GetBuilder<TransactionController>(builder: (transactionCtrl) {
          return GetBuilder<ProfileController>(builder: (profileCtrl) {
            return GetBuilder<WalletController>(builder: (walletCtrl) {
              return Scaffold(
                  backgroundColor: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : AppColors.fillColorColor,
                  key: scaffoldKey,
                  appBar: buildAppBar(t, profileCtrl),
                  body: RefreshIndicator(
                    color: AppColors.mainColor,
                    onRefresh: () async {
                      Get.put(ProfileController()).getProfile();
                      walletCtrl.getWallets();
                      transactionCtrl.resetDataAfterSearching();
                      transactionCtrl.getTransactionList(
                          page: 1,
                          transaction_id: "",
                          start_date: "",
                          end_date: "");
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: Dimensions.kDefaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VSpace(15.h),
                            Text(storedLanguage['Accounts'] ?? 'Your Balances',
                                style: t.bodyLarge?.copyWith(fontSize: 20.sp)),
                            VSpace(20.h),
                            walletCtrl.isLoading
                                ? buildAccountsLoader()
                                : walletCtrl.walletList.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 90.h, top: 30.h),
                                          child: Text(
                                            storedLanguage[
                                                    'No virtual cards available.'] ??
                                                "No virtual cards available.",
                                            style: context.t.bodyLarge,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 200.h,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                walletCtrl.walletList.length +
                                                    1,
                                            itemBuilder: (context, i) {
                                              if (i <
                                                  walletCtrl
                                                      .walletList.length) {
                                                var data =
                                                    walletCtrl.walletList[i];
                                                return Container(
                                                  height: 200
                                                      .h, // height: 200.h // jeta ke p[0]
                                                  width: 250.w,
                                                  margin: EdgeInsets.only(
                                                      right: 20.w),
                                                  padding: EdgeInsets.only(
                                                      top: 10.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius: Dimensions
                                                            .kBorderRadius *
                                                        1.5,
                                                    image: DecorationImage(
                                                      image: AssetImage(Get
                                                              .isDarkMode
                                                          ? "$rootImageDir/card_design_dark.png"
                                                          : "$rootImageDir/card_design.png"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 31.h,
                                                            width: 3.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .mainColor,
                                                              borderRadius: BorderRadius
                                                                  .horizontal(
                                                                      right: Radius
                                                                          .circular(
                                                                              4.r)),
                                                            ),
                                                          ),
                                                          HSpace(10.w),

                                                          Container(
                                                            height: 30.h,
                                                            width: 30.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: data.walletDefault
                                                                              .toString() ==
                                                                          "1"
                                                                      ? AppColors
                                                                          .increamentColor
                                                                      : AppColors
                                                                          .whiteColor,
                                                                  width: 2.h),
                                                              image:
                                                                  DecorationImage(
                                                                image: CachedNetworkImageProvider(
                                                                    walletCtrl
                                                                        .countryImageList[
                                                                            i]
                                                                        .toString()),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          PopupMenuButton(
                                                            onSelected:
                                                                (value) {},
                                                            itemBuilder:
                                                                (BuildContext
                                                                    bc) {
                                                              return [
                                                                PopupMenuItem(
                                                                    onTap: () {
                                                                      UsableBootomSheet();
                                                                      walletCtrl.walletUUID = data
                                                                          .uuid
                                                                          .toString();
                                                                      transactionCtrl.resetDataAfterSearching(
                                                                          isFromOnRefreshIndicator:
                                                                              true);
                                                                      Get.to(() => TransactionScreen(
                                                                          isFromWallet:
                                                                              true,
                                                                          isFromHomePage:
                                                                              true));
                                                                      TransactionController(
                                                                          isFromWallet:
                                                                              true);
                                                                      transactionCtrl.getTransactionList(
                                                                          isFromWallet:
                                                                              true,
                                                                          uuid: data
                                                                              .uuid
                                                                              .toString(),
                                                                          page:
                                                                              1,
                                                                          transaction_id:
                                                                              "",
                                                                          start_date:
                                                                              "",
                                                                          end_date:
                                                                              "");
                                                                    },
                                                                    height:
                                                                        40.h,
                                                                    child: Text(
                                                                      storedLanguage[
                                                                              'Transactions'] ??
                                                                          'Transactions',
                                                                      style: context
                                                                          .t
                                                                          .displayMedium,
                                                                    )),
                                                                PopupMenuItem(
                                                                    onTap:
                                                                        () async {
                                                                      await walletCtrl
                                                                          .getWalletExchData(
                                                                              data,
                                                                              i);
                                                                      Get.toNamed(
                                                                          RoutesName
                                                                              .walletExchangeScreen);
                                                                    },
                                                                    height:
                                                                        40.h,
                                                                    child: Text(
                                                                      storedLanguage[
                                                                              'Exchange Currency'] ??
                                                                          'Exchange Currency',
                                                                      style: context
                                                                          .t
                                                                          .displayMedium,
                                                                    )),
                                                                if (data.walletDefault
                                                                        .toString() !=
                                                                    "1")
                                                                  PopupMenuItem(
                                                                      onTap:
                                                                          () async {
                                                                        await walletCtrl.defaultWallet(
                                                                            id: data.id.toString());
                                                                      },
                                                                      height:
                                                                          40.h,
                                                                      child:
                                                                          Text(
                                                                        storedLanguage['Make Default'] ??
                                                                            'Make Default',
                                                                        style: context
                                                                            .t
                                                                            .displayMedium,
                                                                      )),
                                                              ];
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons.more_vert,
                                                                size: 24.h,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          HSpace(5.w),
                                                        ],
                                                      ),
                                                      VSpace(data.walletDefault
                                                                  .toString() ==
                                                              "1"
                                                          ? 9.h
                                                          : 12.h),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w),
                                                        child: Text(
                                                          storedLanguage[
                                                                  'Balance'] ??
                                                              "Balance",
                                                          style: t.displayMedium
                                                              ?.copyWith(
                                                            color: Color(
                                                                0xffB7B7B7),
                                                          ),
                                                        ),
                                                      ),
                                                      VSpace(5.h),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w),
                                                        child: Text(
                                                          "${double.parse(data.balance.toString()).toStringAsFixed(2)} ${data.currencyCode ?? "USD"}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: context
                                                              .t.bodyMedium
                                                              ?.copyWith(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .whiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w),
                                                        child: Text(
                                                          storedLanguage[
                                                                  'Account Currency'] ??
                                                              "Account Currency",
                                                          style: t.bodySmall
                                                              ?.copyWith(
                                                            fontSize: 14.sp,
                                                            color: Color(
                                                                0xffD1D1D1),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10.w),
                                                        child: Text(
                                                            walletCtrl
                                                                    .countryCurrencyList[
                                                                i],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: context
                                                                .t.bodySmall
                                                                ?.copyWith(
                                                              color: AppColors
                                                                  .whiteColor,
                                                            )),
                                                      ),
                                                      VSpace(15.h),
                                                    ],
                                                  ),
                                                );
                                              }

                                              return InkWell(
                                                onTap: () {
                                                  appDialog(
                                                      context: context,
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              storedLanguage[
                                                                      'Create New Wallet'] ??
                                                                  "Create New Wallet",
                                                              style:
                                                                  t.bodyMedium),
                                                          InkResponse(
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(7.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppThemes
                                                                    .getFillColor(),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 14.h,
                                                                color: Get
                                                                        .isDarkMode
                                                                    ? AppColors
                                                                        .whiteColor
                                                                    : AppColors
                                                                        .blackColor,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            storedLanguage[
                                                                    'Recipient Currency'] ??
                                                                "Recipient Currency",
                                                            style: context
                                                                .t.displayMedium
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        16.sp,
                                                                    color: Get
                                                                            .isDarkMode
                                                                        ? AppColors
                                                                            .whiteColor
                                                                        : AppColors
                                                                            .paragraphColor),
                                                          ),
                                                          VSpace(12.h),
                                                          GetBuilder<
                                                                  WalletController>(
                                                              builder: (_) {
                                                            return Container(
                                                                height: 48.h,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: AppThemes
                                                                      .getFillColor(),
                                                                  borderRadius:
                                                                      Dimensions
                                                                          .kBorderRadius,
                                                                  border: Border.all(
                                                                      color: AppThemes
                                                                          .borderColor(),
                                                                      width: Dimensions
                                                                          .appThinBorder),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          16.h,
                                                                      width:
                                                                          16.h,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              16.w),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image: DecorationImage(
                                                                            image:
                                                                                CachedNetworkImageProvider("${walletCtrl.selectedCountryFlug}"),
                                                                            fit: BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          AppCustomDropDown(
                                                                        paddingLeft:
                                                                            10.w,
                                                                        height:
                                                                            50.h,
                                                                        width: double
                                                                            .infinity,
                                                                        items: walletCtrl
                                                                            .currencyList
                                                                            .map((e) =>
                                                                                e.code +
                                                                                " - " +
                                                                                e.name)
                                                                            .toList(),
                                                                        selectedValue:
                                                                            walletCtrl.selectedCountryAndCurr,
                                                                        onChanged:
                                                                            (v) {
                                                                          var list = walletCtrl.currencyList.firstWhere((e) =>
                                                                              e.code + " - " + e.name ==
                                                                              v);
                                                                          walletCtrl.selectedCountryFlug = list
                                                                              .country!
                                                                              .image;
                                                                          walletCtrl.selectedCountryAndCurr =
                                                                              v;
                                                                          walletCtrl.selectedCountryCode =
                                                                              list.code;
                                                                          walletCtrl
                                                                              .update();
                                                                        },
                                                                        hint: storedLanguage['Select currency'] ??
                                                                            "Select currency",
                                                                        selectedStyle: context
                                                                            .t
                                                                            .bodySmall
                                                                            ?.copyWith(fontSize: 14.sp),
                                                                        bgColor:
                                                                            AppThemes.getDarkCardColor(),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ));
                                                          }),
                                                          VSpace(40.h),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                      "Close",
                                                                      style: t
                                                                          .bodyMedium
                                                                          ?.copyWith(
                                                                              color: AppColors.redColor))),
                                                              HSpace(30.w),
                                                              GetBuilder<
                                                                      WalletController>(
                                                                  builder: (_) {
                                                                return AppButton(
                                                                  buttonHeight:
                                                                      30.h,
                                                                  buttonWidth:
                                                                      _.isCreatingWallet
                                                                          ? 110
                                                                              .w
                                                                          : 90.w,
                                                                  style: t.bodyMedium?.copyWith(
                                                                      color: Get.isDarkMode
                                                                          ? AppColors
                                                                              .blackColor
                                                                          : AppColors
                                                                              .whiteColor),
                                                                  onTap:
                                                                      () async {
                                                                    await _.walletStore(
                                                                        currency_code: _
                                                                            .selectedCountryCode,
                                                                        context:
                                                                            context);
                                                                  },
                                                                  text: _.isCreatingWallet
                                                                      ? "Creating..."
                                                                      : "Create",
                                                                );
                                                              }),
                                                            ],
                                                          ),
                                                        ],
                                                      ));
                                                },
                                                child: Container(
                                                  width: 29.w,
                                                  height: 200.h,
                                                  decoration: BoxDecoration(
                                                      color: Get.isDarkMode
                                                          ? AppColors
                                                              .darkCardColor
                                                          : AppColors
                                                              .whiteColor),
                                                  child: DottedBorder(
                                                    color: Get.isDarkMode
                                                        ? AppColors.black60
                                                        : AppColors.black20,
                                                    strokeWidth: .5,
                                                    dashPattern: const <double>[
                                                      3,
                                                      2
                                                    ],
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Get.isDarkMode
                                                            ? AppColors.black60
                                                            : AppColors.black20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                            VSpace(33.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                essentialWidget(
                                  context,
                                  icon: Icons.phone_android, // Replace with relevant icon
                                  title: 'Airtime',
                                ),
                                essentialWidget(
                                  context,
                                  icon: Icons.data_usage, // Replace with a custom icon or asset
                                  title: 'Data',
                                ),
                                essentialWidget(
                                  context,
                                  icon: Icons.receipt, // Replace with a custom icon or asset for TV
                                  title: 'Pay Bills',
                                ),
                                essentialWidget(
                                  context,
                                  icon: Icons.sports_soccer, // Replace with a custom icon or asset for betting
                                  title: 'Betting',
                                ),
                              ],
                            ),
                            VSpace(33.h),
                            const UsableDashboardSlider(imagePaths: [
                              'assets/images/img_3.png',
                              'assets/images/dash_image.png',
                              'assets/images/img_2.png',
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    storedLanguage['Transactions'] ??
                                        'Transactions',
                                    style:
                                        t.bodyLarge?.copyWith(fontSize: 20.sp)),
                                InkWell(
                                  onTap: () {
                                    Get.to(() => TransactionScreen(
                                        isFromHomePage: true));
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Text(
                                        storedLanguage['See All'] ?? 'See All',
                                        style: t.displayMedium?.copyWith(
                                          color: AppThemes.getBlack50Color(),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            VSpace(17.h),
                            transactionCtrl.isLoading
                                ? buildTransactionLoader()
                                : transactionCtrl.transactionList.isEmpty
                                    ? Center(
                                        child: Container(
                                          height: 140.h,
                                          width: 140.h,
                                          margin: EdgeInsets.only(top: 50.h),
                                          child: Image.asset(
                                            Get.isDarkMode
                                                ? "$rootImageDir/not_found_dark.png"
                                                : "$rootImageDir/not_found.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: transactionCtrl
                                                    .transactionList.length >
                                                12
                                            ? 12
                                            : transactionCtrl
                                                .transactionList.length,
                                        itemBuilder: (context, i) {
                                          var clampedIndex = i.clamp(
                                              i,
                                              transactionCtrl
                                                  .transactionList.length);
                                          var data = transactionCtrl
                                              .transactionList[clampedIndex];
                                          return InkWell(
                                            borderRadius:
                                                Dimensions.kBorderRadius,
                                            onTap: () {
                                              appDialog(
                                                  context: context,
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkResponse(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  7.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppThemes
                                                                .getFillColor(),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons.close,
                                                            size: 14.h,
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.asset(
                                                        "$rootImageDir/done.png",
                                                        height: 48.h,
                                                        width: 48.h,
                                                      ),
                                                      VSpace(12.h),
                                                      InkWell(
                                                        onTap: () {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .removeCurrentSnackBar();
                                                          Clipboard.setData(
                                                              new ClipboardData(
                                                                  text:
                                                                      "${data.trxId ?? ''}"));

                                                          Helpers.showSnackBar(
                                                              msg:
                                                                  "Copied Successfully",
                                                              title: 'Success',
                                                              bgColor: AppColors
                                                                  .greenColor);
                                                        },
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                storedLanguage[
                                                                        'Transaction ID'] ??
                                                                    "Transaction ID",
                                                                style: t.bodyMedium?.copyWith(
                                                                    color: Get
                                                                            .isDarkMode
                                                                        ? AppColors
                                                                            .whiteColor
                                                                        : AppColors
                                                                            .blackColor
                                                                            .withOpacity(.5)),
                                                              ),
                                                              Text(
                                                                data.trxId ??
                                                                    '',
                                                                style:
                                                                    t.bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      VSpace(12.h),
                                                      Text(
                                                        storedLanguage[
                                                                'Amount'] ??
                                                            "Amount",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      Text(
                                                        data.amount.toString(),
                                                        style: t.bodySmall,
                                                      ),
                                                      VSpace(12.h),
                                                      Text(
                                                        storedLanguage[
                                                                'Charge'] ??
                                                            "Charge",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      Text(
                                                        data.charge.toString() +
                                                            "  ${HiveHelp.read(Keys.baseCurrency)}",
                                                        style: t.bodySmall,
                                                      ),
                                                      VSpace(12.h),
                                                      Text(
                                                        storedLanguage[
                                                                'Remark'] ??
                                                            "Remark",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      Text(
                                                        data.remarks ?? '',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodySmall,
                                                      ),
                                                      VSpace(12.h),
                                                      Text(
                                                        storedLanguage[
                                                                'Date and Time'] ??
                                                            "Date and Time",
                                                        style: t.bodyMedium?.copyWith(
                                                            color: Get
                                                                    .isDarkMode
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor
                                                                    .withOpacity(
                                                                        .5)),
                                                      ),
                                                      Text(
                                                        data.createdAt
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: t.bodySmall,
                                                      ),
                                                      VSpace(12.h),
                                                    ],
                                                  ));
                                            },
                                            child: Ink(
                                              width: double.maxFinite,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 14.h),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 40.h,
                                                    height: 40.h,
                                                    child: Image.asset(
                                                      data.trx_type
                                                                  .toString() ==
                                                              "+"
                                                          ? "$rootImageDir/increment.png"
                                                          : "$rootImageDir/decrement.png",
                                                    ),
                                                  ),
                                                  HSpace(12.w),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                      data.remarks
                                                                          .toString()
                                                                          .capitalize
                                                                          .toString(),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      style: t
                                                                          .bodyMedium),
                                                                  VSpace(3.h),
                                                                  Text(
                                                                    data.createdAt
                                                                        .toString(),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: t
                                                                        .bodySmall
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
                                                                  "${data.trx_type} " +
                                                                      data.amount
                                                                          .toString(),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: t
                                                                      .bodyMedium,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 12.h),
                                                          decoration:
                                                              BoxDecoration(
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  endDrawer: buildDrawer(context, storedLanguage));
            });
          });
        });
      });
    });
  }

  ///
  Widget buildAccountsLoader() {
    return SizedBox(
        height: 200.h,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, i) {
              return Container(
                height: 200.h,
                width: 250.w,
                margin: EdgeInsets.only(right: 20.h),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? AppColors.darkCardColor
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VSpace(10.h),
                    Row(
                      children: [
                        Container(
                          width: 32.h,
                          height: 32.h,
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.fillColorColor,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 5.w,
                          height: 25.h,
                          margin: EdgeInsets.only(right: 20.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.fillColorColor,
                          ),
                        ),
                      ],
                    ),
                    VSpace(25.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.w,
                          height: 15.h,
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.fillColorColor,
                          ),
                        ),
                        VSpace(6.w),
                        Container(
                          width: 150.w,
                          height: 25.h,
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.fillColorColor,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.w,
                          height: 15.h,
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.fillColorColor,
                          ),
                        ),
                        VSpace(6.w),
                        Container(
                          width: 170.w,
                          height: 25.h,
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.all(10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Get.isDarkMode
                                ? AppColors.darkBgColor
                                : AppColors.fillColorColor,
                          ),
                        ),
                      ],
                    ),
                    VSpace(15.h),
                  ],
                ),
              );
            }));
  }

  Widget buildDrawer(BuildContext context, storedLanguage) {
    Color darkenColor(Color color, [double amount = 0.1]) {
      assert(amount >= 0 && amount <= 1, 'Amount should be between 0 and 1');
      final hsl = HSLColor.fromColor(color);
      final hslDarkened =
          hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
      return hslDarkened.toColor();
    }

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(left: 45.w),
        child: Stack(
          children: [
            Image.asset(
              "$rootImageDir/drawer_bg_left.png",
              color: AppColors.mainColor,
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Image.asset(
                "$rootImageDir/drawer_bg_right.png",
                color: darkenColor(AppColors.mainColor, 0.05),
              ),
            ),
            ListView(
              children: [
                GetBuilder<ProfileController>(builder: (_) {
                  return SizedBox(
                    height: 180.h,
                    child: Column(
                      children: [
                        VSpace(50.h),
                        SizedBox(
                          height: 110.h,
                          width: 110.h,
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: -120.w,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 110.h,
                                      width: 110.h,
                                      padding: EdgeInsets.all(20.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Container(
                                        height: 80.h,
                                        width: 80.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.imageBgColor,
                                          image:
                                              _.isLoading || _.userPhoto == ''
                                                  ? DecorationImage(
                                                      image: AssetImage(
                                                        "$rootImageDir/avatar.webp",
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                              _.userPhoto),
                                                      fit: BoxFit.cover,
                                                    ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _.isLoading ? "" : _.userName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.t.bodyLarge?.copyWith(
                                              fontSize: 20.sp,
                                              color: AppColors.blackColor),
                                        ),
                                        VSpace(5.h),
                                        Text(
                                          _.isLoading ? "" : _.userEmail,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.t.displayMedium
                                              ?.copyWith(
                                                  fontSize: 16.sp,
                                                  color:
                                                      AppColors.paragraphColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {
                          Get.delete<AddFundController>();
                          // make it false because user is now from add fund page
                          Get.put(AddFundController())
                              .isUserIsFromMoneyTransferPage = false;
                          Get.toNamed(RoutesName.addFundScreen);
                        },
                        leading: Image.asset(
                          "$rootImageDir/add_fund.png",
                          height: 19.h,
                          width: 19.h,
                          fit: BoxFit.cover,
                        ),
                        title: Text(storedLanguage['Add Fund'] ?? "Add Fund",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RoutesName.fundHistoryScreen);
                        },
                        leading: Image.asset("$rootImageDir/fund_history.png",
                            height: 20.h,
                            width: 20.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            storedLanguage['Fund History'] ?? "Fund History",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RoutesName.payoutScreen);
                        },
                        leading: Image.asset("$rootImageDir/payout.png",
                            height: 20.h,
                            width: 20.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(storedLanguage['Payout'] ?? "Payout",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(()=> BillsPaymentView());
                        },
                        leading: Image.asset("$rootImageDir/convert.png",
                            height: 18.h,
                            width: 18.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            "Bill Payments",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(() => TransactionScreen(isFromHomePage: true));
                        },
                        leading: Image.asset(
                            "$rootImageDir/transaction_history.png",
                            height: 17.h,
                            width: 17.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            storedLanguage['Transaction'] ?? "Transaction",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.delete<AddFundController>();
                          // make it false because user is now from add fund page
                          Get.put(AddFundController())
                              .isUserIsFromMoneyTransferPage = true;
                          Get.toNamed(RoutesName.moneyTransferHistoryScreen);
                        },
                        leading: Image.asset(
                            "$rootImageDir/money_transfer_history.png",
                            height: 19.h,
                            width: 19.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            storedLanguage['Money Transfer History'] ??
                                "Money Transfer History",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RoutesName.moneyRequestHistoryScreen);
                        },
                        leading: Image.asset(
                            "$rootImageDir/money_request_icon.png",
                            height: 19.h,
                            width: 19.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            storedLanguage['Money Request History'] ??
                                "Money Request History",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RoutesName.referScreen);
                        },
                        leading: Image.asset("$rootImageDir/refer.png",
                            height: 17.h,
                            width: 17.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            storedLanguage['Refer & Earn'] ?? "Refer & Earn",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                      ListTile(
                        onTap: () {
                          Get.toNamed(RoutesName.supportTicketListScreen);
                        },
                        leading: Image.asset("$rootImageDir/support.png",
                            height: 17.h,
                            width: 17.h,
                            fit: BoxFit.cover,
                            color: AppColors.blackColor),
                        title: Text(
                            storedLanguage['Support Ticket'] ??
                                "Support Ticket",
                            style: context.t.displayMedium?.copyWith(
                                fontSize: 18.sp, color: AppColors.blackColor)),
                        trailing: Icon(Icons.arrow_forward_ios_rounded,
                            size: 14.h, color: AppColors.blackColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar buildAppBar(TextTheme t, ProfileController profileCtrl) {
    return CustomAppBar(
      toolberHeight: 100.h,
      prefferSized: 100.h,
      bgColor:
          Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
      isTitleMarginTop: true,
      titleWidget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("airpero".toUpperCase(),
              style: t.titleMedium?.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: Styles.secondaryFontFamily)),
        ],
      ),
      leading: Padding(
        padding: EdgeInsets.only(left: 7.w),
        child: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            },
            icon: Container(
              width: 34.h,
              height: 34.h,
              padding: EdgeInsets.all(8.5.h),
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? AppColors.darkCardColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: AppColors.mainColor,
                    width: Dimensions.appThinBorder),
              ),
              child: Image.asset(
                "$rootImageDir/menu.png",
                height: 32.h,
                width: 32.h,
                color: AppThemes.getIconBlackColor(),
                fit: BoxFit.fitHeight,
              ),
            )),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Get.put(PushNotificationController()).isNotiSeen();
                },
                icon: Container(
                  height: 33.h,
                  width: 33.h,
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? AppColors.darkCardColor
                        : AppColors.whiteColor,
                    border: Border.all(color: AppColors.mainColor, width: .02),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    "$rootImageDir/notification.png",
                    color: AppThemes.getIconBlackColor(),
                    fit: BoxFit.fitHeight,
                  ),
                )),
            Obx(() => Positioned(
                top: 15.h,
                right: 17.w,
                child: InkWell(
                  onTap: () {
                    Get.put(PushNotificationController()).isNotiSeen();
                  },
                  child: CircleAvatar(
                    radius:
                        Get.put(PushNotificationController()).isSeen.value ==
                                false
                            ? 5.r
                            : 0,
                    backgroundColor:
                        Get.put(PushNotificationController()).isSeen.value ==
                                false
                            ? AppColors.redColor
                            : Colors.transparent,
                  ),
                ))),
          ],
        ),
        HSpace(20.w),
      ],
    );
  }
}

Widget essentialWidget(BuildContext context,
    {required dynamic icon, required String title, VoidCallback? onTap}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        // width: 45,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       spreadRadius: 2,
        //       color: Colors.black.withOpacity(.2),
        //     ),
        //   ],
        //   borderRadius: BorderRadius.circular(8),
        // ),
        child: Column(
          children: [
            // SvgPicture.asset('assets/svgs/$svg.svg'),
            Icon(icon,

            ),
            const Gap(8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );



Widget buildTransactionLoader(
    {int? itemCount = 8, bool? isReverseColor = false}) {
  return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, i) {
        return Container(
          width: double.maxFinite,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isReverseColor == true
                ? AppThemes.getFillColor()
                : AppThemes.getDarkCardColor(),
            borderRadius: Dimensions.kBorderRadius,
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
                  borderRadius: BorderRadius.circular(12.r),
                  color: Get.isDarkMode
                      ? AppColors.darkBgColor
                      : isReverseColor == true
                          ? AppColors.whiteColor
                          : AppColors.fillColorColor,
                ),
              ),
              HSpace(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : isReverseColor == true
                                ? AppColors.whiteColor
                                : AppColors.fillColorColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    VSpace(5.h),
                    Container(
                      height: 10.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? AppColors.darkBgColor
                            : isReverseColor == true
                                ? AppColors.whiteColor
                                : AppColors.fillColorColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
