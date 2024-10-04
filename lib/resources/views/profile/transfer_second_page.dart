import 'package:waiz/resources/views/profile/transfer_receipt.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';
import '../home/buy_giftcard/pin_bottomsheet.dart';
import '../success_view.dart';

class TransferSecondPage extends StatefulWidget {
  const TransferSecondPage({super.key});

  @override
  State<TransferSecondPage> createState() => _TransferSecondPageState();
}

class _TransferSecondPageState extends State<TransferSecondPage> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Transfer',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              const CustomTextfield(
                label: 'Amount',
                hintText: '₦',
              ),
              const Gap(38),
              const CustomTextfield(
                label: 'Description',
                hintText: '',
              ),
              const Gap(75),
              primaryButton(
                context,
                title: 'Confirm',
                onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const PinBottomsheetView(
                          next: SuccessView(
                            content: 'Your Payment has been successful',
                            secondaryLocation: TransferReceiptPage(),
                          ),
                        );
                      });
                },
              ),
              Gap(MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}
