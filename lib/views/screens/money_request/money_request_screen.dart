import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/custom_appbar.dart';
import 'package:waiz/views/widgets/mediaquery_extension.dart';
import 'package:waiz/views/widgets/spacing.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../controllers/money_request_controller.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/app_custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';

class MoneyRequestScreen extends StatelessWidget {
  final String? userName;
  const MoneyRequestScreen({super.key, this.userName = ""});

  @override
  Widget build(BuildContext context) {
    TextTheme t = Theme.of(context).textTheme;
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    WalletController.to.textEditingController1.clear();
    WalletController.to.textEditingController2.clear();
    return GetBuilder<WalletController>(builder: (walletCtrl) {
      return GetBuilder<MoneyRequestController>(builder: (_) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "Request Money From $userName",
            fontSize: 21.sp,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: Dimensions.kDefaultPadding,
              child: _.isLoading
                  ? SizedBox(
                      width: double.maxFinite,
                      height: context.mQuery.height,
                      child: Helpers.appLoader(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VSpace(30.h),
                        Text(storedLanguage['Select Recipient Currency'] ?? "Select Recipient Currency",
                            style: t.displayMedium),
                        VSpace(15.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                                color: Get.isDarkMode
                                    ? AppColors.black60
                                    : AppColors.black20,
                                width: .4),
                          ),
                          child: Row(
                            children: [
                              HSpace(10.w),
                              _.selectedWalletCurrCountryImage.isEmpty
                                  ? SizedBox()
                                  : ClipOval(
                                      child: CachedNetworkImage(
                                      imageUrl: _.selectedWalletCurrCountryImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: 20.h,
                                      width: 20.h,
                                    )),
                              Flexible(
                                child: AppCustomDropDown(
                                  height: 50.h,
                                  width: double.infinity,
                                  items: _.walletList
                                      .map((e) =>
                                          e.currencyCode +
                                          " - " +
                                          e.currency!.name.toString())
                                      .toList(),
                                  selectedValue: _.selectedWalletCurr,
                                  onChanged: _.onCurrencyChanged,
                                  hint: storedLanguage['Select currency'] ??
                                      "Select currency",
                                  selectedStyle: context.t.bodyMedium,
                                  bgColor: AppThemes.getDarkCardColor(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        VSpace(24.h),
                        Text(storedLanguage['Amount'] ?? "Amount", style: t.displayMedium),
                        VSpace(15.h),
                        CustomTextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            isOnlyBorderColor: true,
                            height: 55.h,
                            hintext: "",
                            controller: _.amountCtrl),
                        VSpace(50.h),
                        AppButton(
                          text: storedLanguage['Confirm'] ?? "Confirm",
                          bgColor: MoneyTransferController.to.isGettingRate
                              ? AppColors.sliderInActiveColor
                              : Get.isDarkMode
                                  ? AppColors.mainColor
                                  : AppColors.blackColor,
                          isLoading: _.isRequestingMoney ? true : false,
                          onTap: _.isRequestingMoney
                              ? null
                              : () async {
                                  if (_.selectedWalletCurr == null ||
                                      _.selectedWalletCurr.toString().isEmpty) {
                                    Helpers.showSnackBar(
                                        msg:
                                            "Please select recipeint currency.");
                                  } else if (_.amountCtrl.text.isEmpty) {
                                    Helpers.showSnackBar(
                                        msg: "Amount field is required.");
                                  } else {
                                    await _.moneyRequest(fields: {
                                      "wallet": _.walletId,
                                      "recipient_id": _.recipientId,
                                      "amount": _.amountCtrl.text.toString(),
                                    });
                                  }
                                },
                        ),
                      ],
                    ),
            ),
          ),
        );
      });
    });
  }
}
