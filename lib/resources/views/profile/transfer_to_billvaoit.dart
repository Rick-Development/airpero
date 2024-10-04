import 'package:waiz/resources/views/profile/transfer_second_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';

class TransferTobillvaoit extends StatefulWidget {
  const TransferTobillvaoit({super.key});

  @override
  State<TransferTobillvaoit> createState() => _TransferTobillvaoitState();
}

class _TransferTobillvaoitState extends State<TransferTobillvaoit> {
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
                label: 'User ID',
                hintText: '@',
              ),
              const Gap(25),
              primaryButton(context, title: 'Nweke Mary Chisom', radius: 4),
              const Gap(75),
              primaryButton(context, title: 'Confirm', onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (_) => const TransferSecondPage(),
                ));
              }),
              Gap(MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}
