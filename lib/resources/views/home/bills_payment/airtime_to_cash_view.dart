import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import '../buy_giftcard/pin_bottomsheet.dart';


class AirtimeToCashView extends StatefulWidget {
  const AirtimeToCashView({super.key});

  @override
  State<AirtimeToCashView> createState() => AirtimeToCashViewState();
}

class AirtimeToCashViewState extends State<AirtimeToCashView> {
  late TextEditingController ctrl;
  bool viewDetails = true;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: '₦');
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Airtime to Cash',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
                const Gap(32),
                const CustomTextfield(
                  label: 'Airtime Pin',
                  hintText: '2424******33',
                  keyboardType: TextInputType.number,
                ),
                const Gap(23),
                CustomTextfield(
                  label: 'Amount',
                  ctrl: TextEditingController(text: '₦'),
                ),
                const Spacer(),
                primaryButton(context, title: 'Confirm', onTap: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const PinBottomsheetView();
                      });
                }),
                const Gap(36),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Widget electricSheetWidget(
  BuildContext context, {
  required String title,
}) =>
    Row(
      children: [
        Image.asset('assets/images/ie.png'),
        const Gap(18),
        Text(
          '$title electric',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
        ),
      ],
    );
