import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/resources/views/virtual_dollar_card/virtual_dollar_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';
import '../auth_views/otp_verification.dart';
import '../success_view.dart';
import 'card_details_view.dart';

class KycVerification extends StatelessWidget {
  const KycVerification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(MediaQuery.of(context).padding.top + 24),
            InkWell(
              splashColor: Colors.transparent,
              onTap: Navigator.of(context).pop,
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const Gap(24),
                  Text(
                    'KYC Verification ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(57),
            SvgPicture.asset('assets/svgs/kyc.svg'),
            const Gap(13),
            Text(
              'KYC Verification',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
              textAlign: TextAlign.center,
            ),
            const Gap(22),
            Text(
              'Verify your identity! Upload a\ngovernment-issued ID (Passport, driver’s license, national ID card) to complete KYC verification, secure your account and unlock full platform features.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.textGreyColor2,
                  ),
              textAlign: TextAlign.center,
            ),
            const Gap(48),
            const CustomTextfield(
              label: 'Document Type',
              hintText: 'BVN',
            ),
            const Gap(24),
            const CustomTextfield(
              label: 'BVN Number',
              hintText: 'Enter BVN number',
            ),
            const Spacer(),
            primaryButton(context, title: 'Proceed', onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => const OTPVerificationView(
                  next: SuccessView(
                    content: 'Your payment has been successful',
                    buttonText: 'View Card',
                    next: VirtualDollarCard(),
                  ),
                ),
              ));
            }),
            const Gap(38),
          ],
        ),
      ),
    );
  }
}
