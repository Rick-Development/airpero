import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../auth_views/login.dart';
import '../auth_views/sign_up.dart';


class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(130),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Image.asset(
                    'assets/images/logo.png',
                    scale: 2,
                    height: 150,
                    width: 150,
                  ),
                )
              ],
            ),
            const Gap(65),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: SizedBox(
                width: 250,
                child: Text(
                  'Billvault ',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    fontFamily: "Arial",
                    color: Colors.black,

                  ),
                ),
              )
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'for fast trading',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      fontFamily: "Arial",
                      color: Colors.black,

                    ),
                  ),
                )
            ),

            const Gap(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                'Billvault App allows you to Trade crypto, Gift cards, pay bills, book your flight and get virtual cards.',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const Gap(76),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  primaryButton(
                    context,
                    color: AppColors.primaryColor,
                    title: 'Get Started',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>  SignUpScreen(),
                      ));
                    },
                  ),
                  const Gap(30),
                  // const Spacer(),

                  secondaryButton(
                    context,
                    title: 'I have an account',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const LoginView(),
                      ));
                    }, svg: '',
                  ),

                  const Gap(38),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


