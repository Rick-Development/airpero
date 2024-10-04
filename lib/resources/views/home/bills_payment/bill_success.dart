import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/resources/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../app/http/controllers/giftcards/giftcard_controller.dart';
import '../../../utils/button.dart';
import '../../home.dart';

class BillSuccess extends StatelessWidget {
  final String? content;
  final String? buttonText;
  final Widget? next;
  final Widget? secondaryLocation;

  // GetX controller instance
  final GiftCardController giftCardController = Get.put(GiftCardController());

  BillSuccess({
    super.key,
    this.content,
    this.buttonText,
    this.next,
    this.secondaryLocation,

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
                    'Successful!!!',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const Gap(10),

                  const Gap(30),

                  // Transaction details
                  // _transactionDetails(context),
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
