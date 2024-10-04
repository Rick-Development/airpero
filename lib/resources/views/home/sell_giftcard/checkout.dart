import 'package:waiz/resources/views/home/buy_giftcard/pin_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/button.dart';


class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => CheckoutViewState();
}

class CheckoutViewState extends State<CheckoutView> {
  bool viewDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(MediaQuery.of(context).padding.top + 24),
            InkWell(
              onTap: Navigator.of(context).pop,
              splashColor: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const Gap(24),
                  Text(
                    'Checkout',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(33),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/apple-gc.png'),
              radius: 32,
            ),
            const Gap(9),
            Text(
              'Apple Pay E-Gift Card',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const Gap(23),
            rowWidget(context, title: 'Recipient:', value: 'example@gmail.com'),
            rowWidget(context, title: 'SMS:', value: '+2347056584464'),
            rowWidget(context, title: 'Quantity:', value: '1'),
            rowWidget(context, title: 'From:', value: 'Uchenna'),
            rowWidget(context, title: 'Unit price:', value: '₦16,050.00'),
            rowWidget(context, title: 'Subtotal:', value: '₦2,05.00'),
            rowWidget(context, title: 'Total fee:', value: '₦16,25.00'),
            const Spacer(flex: 4),
            primaryButton(context, title: 'Confirm', onTap: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return const PinBottomsheetView();
                  });
            }),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

Widget rowWidget(
    BuildContext context, {
      required String title,
      required String value,
    }) =>
    Container(
      margin: const EdgeInsets.only(bottom: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
