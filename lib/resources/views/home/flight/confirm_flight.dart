import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/button.dart';
import '../buy_giftcard/pin_bottomsheet.dart';

class ConfirmFlight extends StatefulWidget {
  const ConfirmFlight({super.key});

  @override
  State<ConfirmFlight> createState() => ConfirmFlightState();
}

class ConfirmFlightState extends State<ConfirmFlight> {
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
                      'Confirm',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(64),
              Text(
                '₦135,700',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Gap(34),
              Column(
                children: [
                  receiptRow(context,
                      title: 'Flight type ', subtitle: 'Economy '),
                  const Gap(25),
                  receiptRow(context,
                      title: 'Mobile Number', subtitle: '07038473758'),
                  const Gap(25),
                  receiptRow(context,
                      title: 'Date of booking', subtitle: '15/10/2023'),
                  const Gap(25),
                  receiptRow(context, title: 'Amount', subtitle: '₦135700.00'),
                  const Gap(25),
                  receiptRow(context,
                      title: 'Reference Number', subtitle: '8063579245'),
                  const Gap(25),
                  receiptRow(context,
                      title: 'Date', subtitle: 'wednesday, july 31,2024'),
                  const Gap(25),
                  receiptRow(context,
                      title: 'Transaction Fee', subtitle: '₦0.00'),
                ],
              ),
              const Spacer(),
              primaryButton(
                context,
                title: 'Confirm',
                onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const PinBottomsheetView(
                          successText:
                              'Your Flight Reservation has been\nsuccessful',
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
