import 'package:waiz/resources/views/auth_views/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../home.dart';
import 'login.dart';

class CreatePinView extends StatefulWidget {
  final bool fromEmail;
  const CreatePinView({super.key, this.fromEmail = true});

  @override
  State<CreatePinView> createState() => _CreatePinViewState();
}

class _CreatePinViewState extends State<CreatePinView> {
  bool confirm = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Gap(MediaQuery.of(context).padding.top + 24),
            Row(
              children: [
                InkWell(
                  onTap: Navigator.of(context).pop,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.iconGreyColor,
                  ),
                ),
                const Gap(20),
                Text(
                  '${confirm ? 'Confirm' : 'Create'} pin',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                ),
              ],
            ),
            const Gap(49),
            Text(
              'Enter a 4-digit code you won’t forget',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(69),
            Pinput(
              controller: _ctrl,
              length: 4,
              onCompleted: (val) {
                if (confirm) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const Home(),
                  ));
                }
                setState(() {
                  confirm = true;
                  _ctrl.clear();
                });
              },
            ),
            const Gap(24),
            const Spacer(),
            primaryButton(
              context,
              color: AppColors.primaryColor,
              title: 'Confirm',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => widget.fromEmail
                      ? const LoginView()
                      : const ResetPasswordView(),
                ));
              },
            ),
            const Gap(42)
          ],
        ),
      ),
    );
  }
}
