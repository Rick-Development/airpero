import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../utils/button.dart';

class SuccessView extends StatelessWidget {
  final String? content;
  final String? buttonText;
  final Widget? next;
  final Widget? secondaryLocation;
  const SuccessView({
    super.key,
    this.content,
    this.buttonText,
    this.next,
    this.secondaryLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Gap(),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top + 24),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: Navigator.of(context).pop,
                child: Row(
                  children: [
                    SvgPicture.asset('assets/svgs/cancel.svg'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Image.asset('assets/images/success.png'),
                const Gap(23),
                Text(
                  'Success!!!',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const Gap(10),
                Text(
                  content ?? 'You Withdrawal has been\nsuccessfully ',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            // const Spacer(),
            Column(
              children: [
                if (secondaryLocation != null) ...[
                  primaryButton(
                    context,
                    title: 'View Receipt',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => secondaryLocation!,
                        ),
                      );
                    },
                  ),
                  const Gap(21),
                ],
                primaryButton(
                  context,
                  title: buttonText ?? 'Go to Home',
                  onTap: () {
                    if (next == null) {
                      Navigator.of(context).pop();
                      return;
                    }
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => next!,
                    ));
                  },
                ),
                Gap(MediaQuery.of(context).padding.bottom + 24),
              ],
            )
          ],
        ),
      ),
    );
  }
}
