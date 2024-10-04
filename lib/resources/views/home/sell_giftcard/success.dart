import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/resources/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../app/http/controllers/giftcards/giftcard_controller.dart';
import '../../../utils/button.dart';
import '../../home.dart';

class SellGiftcardSuccessView extends StatelessWidget {
  final String? content;
  final String? buttonText;
  final Widget? next;
  final Widget? secondaryLocation;

  // Transaction details
  final String email;
  final String phone_number;
  final int quantity;
  final Map<String, dynamic> checkoutDetails;
  final String? fullName;
  final String eurCurrency;
  final double eurAmount;
  final String ngnCurrency;
  final int sub_total;
  final int total;

  // GetX controller instance
  final GiftCardController giftCardController = Get.put(GiftCardController());

  SellGiftcardSuccessView({
    super.key,
    this.content,
    this.buttonText,
    this.next,
    this.secondaryLocation,
    required this.email,
    required this.phone_number,
    required this.quantity,
    required this.checkoutDetails,
    this.fullName,
    required this.eurCurrency,
    required this.eurAmount,
    required this.ngnCurrency,
    required this.sub_total,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close button
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: Navigator.of(context).pop,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svgs/cancel.svg'),
                  ],
                ),
              ),
            ),

            // Success message or loading indicator
            Obx(() {
              if (giftCardController.isBuying.value) {
                // Display loading indicator while buying is in progress
                return CircularProgressIndicator();
              }

              // Otherwise, display the success message and transaction details
              return Column(
                children: [
                  SvgPicture.asset('assets/svgs/success.svg'),
                  const Gap(23),
                  Text(
                    'Success!!!',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Gap(10),
                  // Text(
                  //   content ?? 'You successfully bought ${eurCurrency} 100 Itunes card',
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .labelLarge
                  //       ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                  //   textAlign: TextAlign.center,
                  // ),
                  const Gap(30),

                  // Transaction details
                  _transactionDetails(context),
                ],
              );
            }),

            // Button actions
            Column(
              children: [
                if (secondaryLocation != null) ...[
                  primaryButton(
                    context,
                    title: 'View Receipt',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => secondaryLocation!,
                        ),
                      );
                    },
                  ),
                  const Gap(21),
                ],
                primaryButton(
                  context,
                  color: AppColors.primaryColor,
                  title: buttonText ?? 'Go to Home',
                  onTap: () async {
                    Get.to(const Home());
                  },
                ),
                Gap(MediaQuery.of(context).padding.bottom + 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Transaction details widget (same as before)
  Widget _transactionDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rowWidget(context, title: 'Recipient:', value: email),
        _rowWidget(context, title: 'SMS:', value: phone_number),
        _rowWidget(context, title: 'Quantity:', value: '$quantity * ${checkoutDetails['productName']}'),
        _rowWidget(context, title: 'From:', value: fullName ?? 'Unknown'),
        _rowWidget(context, title: 'Unit price:', value: '$eurCurrency $eurAmount'),
        _rowWidget(context, title: 'Subtotal:', value: '$ngnCurrency $sub_total'),
        _rowWidget(context, title: 'Total fee:', value: '$ngnCurrency $total'),
      ],
    );
  }

  // Helper method for row details (same as before)
  Widget _rowWidget(BuildContext context, {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
