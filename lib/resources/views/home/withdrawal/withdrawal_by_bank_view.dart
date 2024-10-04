import 'package:waiz/resources/views/home/withdrawal/withdrawal_by_card_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:waiz/resources/utils/app_colors.dart';
import 'package:waiz/resources/widgets/custom_textfield.dart';
import 'package:waiz/resources/utils/button.dart';

import '../../success_view.dart';

class WithdrawalByBankView extends StatelessWidget {
  const WithdrawalByBankView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                            'Withdraw',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
                            'Withdrawal',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
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
                    const CustomTextfield(
                        label: 'Select Bank', hintText: 'UBA Bank'),
                    const Gap(16),
                    const CustomTextfield(
                      label: 'Account number',
                      hintText: 'xxxx xxxx xxxx',
                    ),
                    const Gap(25),
                    primaryButton(context, title: 'Nweke Mary Chisom')
                  ],
                ),
                // const Spacer(),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        children: [
                          Text(
                            'By adding a new card, you agree to the ',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 14,
                                    color: AppColors.textGreyColor2),
                          ),
                          Text(
                            'credit/debit card terms.',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontSize: 14,
                                  color: const Color(0xFF003130),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const WithdrawalByCardView(),
                        ));
                      },
                      child: Text(
                        'Change Payment method',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontSize: 18,
                              color: AppColors.redColor,
                            ),
                      ),
                    ),
                    const Gap(26),
                    primaryButton(context, title: 'Confirm', onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const SuccessView(),
                      ));
                    }),
                    const Gap(48),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
