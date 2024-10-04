import 'package:waiz/app/http/controllers/giftcards/sell_giftcard_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../widgets/custom_textfield.dart';
import 'sell_single_giftcard.dart';
import 'package:get/get.dart';


class SellGiftcardView extends StatefulWidget {
  const SellGiftcardView({super.key});

  @override
  State<SellGiftcardView> createState() => SellGiftcardViewState();
}

class SellGiftcardViewState extends State<SellGiftcardView> {
  bool viewDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
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
                      'Buy Gift Card',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(28),
              CustomTextfield(
                  label: 'Select Country',
                  hintText: 'Nigeria',
                  callback: () async {
                    final sheet = await showModalBottomSheet(
                      context: context,
                      builder: (_) => Container(
                        color: Colors.red,
                      ),
                    );
                    print(sheet);
                  }),
              const Gap(11),
              const CustomTextfield(
                hintText: 'Search for Giftcard',
                trailingSvg: 'search',
              ),
              const Gap(11),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  giftcardWidget(context),
                  giftcardWidget(context),
                  giftcardWidget(context),
                  giftcardWidget(context),
                  giftcardWidget(context),
                  giftcardWidget(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget giftcardWidget(BuildContext context) => InkWell(
  onTap: () {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) =>  SellSingleGiftcardView(),
    ));
  },
  child: Container(
    width: 150,
    // color: Colors.red,
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/apple-gc.png'),
        const Gap(15),
        Text(
          'Apple card',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        )
      ],
    ),
  ),
);
