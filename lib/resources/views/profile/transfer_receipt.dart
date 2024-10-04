import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/button.dart';


class TransferReceiptPage extends StatefulWidget {
  const TransferReceiptPage({super.key});

  @override
  State<TransferReceiptPage> createState() => _TransferReceiptPageState();
}

class _TransferReceiptPageState extends State<TransferReceiptPage> {
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
              Text(
                'Status',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Gap(15),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF003130),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Success',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                ),
              ),
              const Gap(15),
              Text(
                'Created : 2023-23-11',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const Gap(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xCCE5EBF0),
                      ),
                    ),
                    const Gap(2),
                    Image.asset('assets/images/logo.png'),
                    const Gap(2),
                    const Expanded(
                      child: Divider(
                        color: Color(0xCCE5EBF0),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Column(
                children: [
                  receiptRow(context, title: 'Provider', subtitle: 'Transfer'),
                  const Gap(25),
                  receiptRow(context, title: 'Customer Name ', subtitle: 'Okechukwu Emeka'),
                  const Gap(25),
                  receiptRow(context, title: 'Package', subtitle: 'waiz'),
                  const Gap(25),
                  receiptRow(context, title: 'Reference Number', subtitle: '18776422518063579245'),
                  const Gap(25),
                  receiptRow(context, title: 'Beneficiary ID', subtitle: '863e879245'),
                  const Gap(25),
                  receiptRow(context, title: 'Date', subtitle: 'wednesday, july 31,2024'),
                  const Gap(25),
                  receiptRow(context, title: 'Amount', subtitle: '₦4850'),
                  const Gap(25),
                  receiptRow(context, title: 'Transaction Fee', subtitle: '₦0.00'),
                ],
              ),
              const Gap(8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Color(0xCCE5EBF0),
                ),
              ),
              const Spacer(),
              primaryButton(
                context,
                title: 'Share Receipt',
                onTap: Navigator.of(context).pop,
              ),
              Gap(MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}

Widget receiptRow(
  BuildContext context, {
  required String title,
  required String subtitle,
}) =>
    Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF808083)),
        ),
        Text(
         subtitle,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111111)),
        ),
      ],
    );
