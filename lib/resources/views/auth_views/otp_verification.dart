import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

import '../../utils/app_colors.dart';
import '../../utils/button.dart';


class OTPVerificationView extends StatelessWidget {
  final Widget next;
  const OTPVerificationView({
    super.key,
    required this.next,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Gap(MediaQuery.of(context).padding.top + 24),
            Row(
              children: [
                InkWell(
                  onTap: Navigator.of(context).pop,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.iconGreyColor,
                  ),
                ),
                const Gap(20),
                Text(
                  'Email verification',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: const Color(0xFF11183C),
                      ),
                ),
              ],
            ),
            const Gap(20),
            Text(
              'Please enter the code',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                    color: const Color(0xFF11183C),
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(7),
            Text(
              'We sent email to tomashuk.dima.1992@gmail.com',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(30),
            SvgPicture.asset('assets/svgs/mail.svg'),
            const Gap(24),
            Pinput(
              length: 6,
              onCompleted: (val) {},
            ),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t get a mail? ',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: const Color(0xFF11183C),
                      ),
                ),
                Text(
                  'Send again',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.primaryColor,
                      ),
                ),
              ],
            ),
            const Spacer(),
            primaryButton(
              context,
              color: AppColors.primaryColor,
              title: 'Confirm',
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => next,
                ));
              },
            ),
            const Gap(42)
          ],
        ),
      ),
    );
  }
}
