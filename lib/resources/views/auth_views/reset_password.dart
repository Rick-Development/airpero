import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';
import 'create_pin.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

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
                  'Reset password',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
            const Gap(35),
            Text(
              'Kindly enter your new password below.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: AppColors.textGreyColor),
              // overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
            const Gap(30),
            const CustomTextfield(
              label: 'Enter New Password',
              hintText: 'Enter password',
              obscureText: true,
            ),
            const Gap(30),
            const CustomTextfield(
              label: 'Confirm New Password',
              hintText: 'Confirm password',
              obscureText: true,
            ),
            const Gap(30),
            primaryButton(context, color: AppColors.primaryColor, title: 'Reset Password', onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatePinView()),
              );
            }),
            const Gap(42)
          ],
        ),
      ),
    );
  }
}
