import 'package:waiz/resources/views/profile/withdrawal_2fa.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/app_colors.dart';
import 'change_language.dart';
import 'change_password.dart';
import 'change_pin.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
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
                    'Setting',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(28),
            Column(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const ChangePasswordView(),
                      ));
                    },
                    child: settingWidget(context, title: 'Change Password')),
                const Gap(15),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ChangePinView(),
                    ));
                  },
                  child: settingWidget(context, title: 'Change PIN'),
                ),
                // const Gap(15),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (_) => const ChangeLanguageView(),
                //     ));
                //   },
                //   child: settingWidget(context, title: 'Change Language'),
                // ),
                // const Gap(15),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(MaterialPageRoute(
                //       builder: (_) => const Withdrawal2FA(),
                //     ));
                //   },
                //   child: settingWidget(
                //     context,
                //     title: 'Withdrawal 2FA',
                //     isSwitch: true,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingWidget(
  BuildContext context, {
  required String title,
  bool isSwitch = false,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
          ),
          if (isSwitch)
            GestureDetector(
              onTap: () {
                // Toggle switch state here
              },
              child: Container(
                width: 40.0,
                height: 20.0,
                clipBehavior: Clip.none,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: const Color(0xFFCFCFCF),
                ),
                child: Align(
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
              ),
            ),
          // Container(
          //   color: Colors.red,
          //   child: Transform.scale(
          //     scale: .5,
          //     child: Switch(
          //       value: false,
          //       onChanged: (val) {},
          //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //     ),
          //   ),
          // ),
          if (!isSwitch)
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
            ),
        ],
      ),
    );
