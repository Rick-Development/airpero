import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/routes/routes_name.dart';
import 'package:waiz/themes/themes.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../../config/app_colors.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final bool? isFromWalletExchangePage;
  final String? exchangeAmount;
  final String? receiveAmount;
  const PaymentSuccessScreen(
      {Key? key,
      this.isFromWalletExchangePage = false,
      this.exchangeAmount,
      this.receiveAmount})
      : super(key: key);

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late ConfettiController _centerController;

  @override
  void initState() {
    super.initState();
    _centerController =
        ConfettiController(duration: const Duration(seconds: 40));
    _centerController.play();
  }

  @override
  void dispose() {
    _centerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Get.offAllNamed(RoutesName.bottomNavBar);
      },
      child: Scaffold(
        backgroundColor:
            Get.isDarkMode ? AppColors.darkBgColor : AppColors.fillColorColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Center(
                child: Image.asset(
                  "$rootImageDir/success_top.png",
                  width: 295.w,
                  height: 127.h,
                  fit: BoxFit.fitHeight,
                  color: AppColors.mainColor.withOpacity(.3),
                ),
              ),
              VSpace(10.h),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    "$rootImageDir/success_bottom.png",
                    width: double.maxFinite,
                    height: 127.h,
                    fit: BoxFit.fitHeight,
                    color: AppColors.mainColor.withOpacity(.3),
                  ),
                  Positioned(
                    top: 40.h,
                    child: Image.asset(
                      "$rootImageDir/success_middle.png",
                      width: 96.h,
                      height: 96.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _centerController,
                      blastDirection: pi / 2,
                      maxBlastForce: 5,
                      minBlastForce: 1,
                      emissionFrequency: 0.03,
                      numberOfParticles: 10,
                      gravity: 0,
                    ),
                  ),
                ],
              ),
              VSpace(30.h),
              Text(
                  widget.isFromWalletExchangePage == true
                      ? "Exchange Success"
                      : storedLanguage['Transfer Success'] ?? "Transfer Success",
                  style: context.t.bodyMedium?.copyWith(fontSize: 32.sp)),
              VSpace(40.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Container(
                  width: double.maxFinite,
                  height: 68.h,
                  decoration: BoxDecoration(
                    color: AppThemes.getDarkCardColor(),
                    borderRadius: Dimensions.kBorderRadius,
                    border: Border.all(
                      color: AppColors.mainColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.isFromWalletExchangePage == true
                          ? "${widget.receiveAmount}"
                          : "${MoneyTransferController.to.amountInSelectedCurr} ${AddFundController.to.isPaymentTypeIsWallet ? AddFundController.to.selectedCurrency.toString().split(" ").first : AddFundController.to.selectedCurrency}",
                      style: context.t.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 32.sp),
                    ),
                  ),
                ),
              ),
              VSpace(40.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: Container(
                    width: double.maxFinite,
                    height: 150.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    decoration: BoxDecoration(
                      color: AppThemes.getDarkCardColor(),
                      borderRadius: Dimensions.kBorderRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.isFromWalletExchangePage == true
                                  ? "Exchange Amount"
                                  : "Transfer Amount",
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor()),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  widget.isFromWalletExchangePage == true
                                      ? "${widget.exchangeAmount}"
                                      : "${MoneyTransferController.to.amountInSelectedCurr} ${AddFundController.to.isPaymentTypeIsWallet ? AddFundController.to.selectedCurrency.toString().split(" ").first : AddFundController.to.selectedCurrency}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                        Container(
                          width: double.maxFinite,
                          height: .5,
                          color: AppThemes.getSliderInactiveColor(),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.isFromWalletExchangePage == true
                                  ? "Receive Wallet Amount"
                                  : "Gateway",
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor()),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  widget.isFromWalletExchangePage == true
                                      ? "${widget.receiveAmount}"
                                      : "${AddFundController.to.gatewayName}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                        Container(
                          width: double.maxFinite,
                          height: .5,
                          color: AppThemes.getSliderInactiveColor(),
                        ),
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: context.t.displayMedium?.copyWith(
                                  color: AppThemes.getParagraphColor()),
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  "${DateFormat('MMM d, yyyy').format(DateTime.now())}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: context.t.bodyMedium),
                            )),
                          ],
                        ),
                      ],
                    )),
              ),
              VSpace(40.h),
              Padding(
                padding: Dimensions.kDefaultPadding,
                child: AppButton(
                  onTap: () {
                    Get.offAllNamed(RoutesName.bottomNavBar);
                  },
                  text: storedLanguage['Return Home'] ?? "Return Home",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
