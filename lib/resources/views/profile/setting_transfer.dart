import 'package:waiz/resources/views/profile/transfer_to_billvaoit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


class SettingTransferView extends StatefulWidget {
  const SettingTransferView({super.key});

  @override
  State<SettingTransferView> createState() => _SettingTransferViewState();
}

class _SettingTransferViewState extends State<SettingTransferView> {
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
              const Gap(36),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const TransferTobillvaoit(),
                  ));
                },
                child: Image.asset('assets/images/transfer_to_billvaoit.png'),
              ),
              const Gap(33),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const TransferTobillvaoit(),
                  ));
                },
                child: Image.asset('assets/images/transfer_to_euro.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
