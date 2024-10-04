import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/app_colors.dart';


class Withdrawal2FA extends StatefulWidget {
  const Withdrawal2FA({super.key});

  @override
  State<Withdrawal2FA> createState() => _Withdrawal2FAState();
}

class _Withdrawal2FAState extends State<Withdrawal2FA> {
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
                      'Withdrawal 2FA',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(51),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 21),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF003130),
                    width: .5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Withdrawal 2FA',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isOn = !isOn;
                        });
                      },
                      child: Container(
                        width: 40.0,
                        height: 20.0,
                        clipBehavior: Clip.none,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: const Color(0xFFCFCFCF),
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment:
                                  // true ?
                                  // Alignment.centerRight :
                                  Alignment.centerLeft,
                              child: Container(
                                width: 18.0,
                                height: 18.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: AppColors.primaryColor,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(24),
              Text(
                'Once you turn on 2FA, withdrawal action on your account is locked.',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
              ),
              const Gap(45),
              Text(
                'Every time you try to withdrawal, a 4-digit code will be sent to your registered email address and you will be required to enter this code in order to complete the withdrawal.',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
