import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import 'confirm_transfer_view.dart';

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const Gap(51),
              const CustomTextfield(label: 'Amount to top-up', hintText: '₦'),
              const Gap(49),
              primaryButton(context, title: 'Next', onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const ConfirmTransferView(),
                ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
