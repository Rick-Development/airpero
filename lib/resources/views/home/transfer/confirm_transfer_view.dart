import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../success_view.dart';

class ConfirmTransferView extends StatelessWidget {
  const ConfirmTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                      'Top-up',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(49),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top-up',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                    Row(
                      children: [
                        Image.asset('assets/images/mastercard.png'),
                        const Gap(8),
                        Image.asset(
                          'assets/images/visa.png',
                          color: const Color(0xFF1434CB),
                        ),
                        const Gap(8),
                        Image.asset('assets/images/amex.png'),
                        const Gap(8),
                        Image.asset('assets/images/discover.png'),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(9),
              const CustomTextfield(label: 'Name on card', hintText: 'Mobbin'),
              const Gap(16),
              const CustomTextfield(
                  label: 'Card number', hintText: 'xxxx xxxx xxxx'),
              const Gap(16),
              const Row(
                children: [
                  Expanded(
                    child: CustomTextfield(
                      label: 'Expiration',
                      hintText: 'MM/YY',
                    ),
                  ),
                  Gap(16),
                  Expanded(
                    child: CustomTextfield(
                      label: 'CVC',
                      hintText: '123',
                    ),
                  ),
                ],
              ),
              const Gap(16),
              const CustomTextfield(
                label: 'Postal code',
                hintText: '012345',
              ),
              const Gap(38),
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  children: [
                    Text(
                      'By adding a new card, you agree to the ',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14, color: AppColors.textGreyColor2),
                    ),
                    Text(
                      'credit/debit card terms.',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            color: const Color(0xFF003130),
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              Text(
                'Change Payment method',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 18,
                      color: AppColors.redColor,
                    ),
              ),
              const Gap(26),
              primaryButton(context, title: 'Confirm', onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const SuccessView(content: 'Your transfer has been\nsuccessful',),
                ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
