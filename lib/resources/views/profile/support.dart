import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';


class SupportView extends StatefulWidget {
  const SupportView({super.key});

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
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
                      'Support',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(34),
              secondaryButton(context,
                  title: 'Continue with Facebook', svg: 'fb'),
              const Gap(34),
              secondaryButton(context,
                  title: 'Continue with Gmail', svg: 'google'),
              const Spacer(),
              Text(
                'Send Message',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Gap(22),
              const CustomTextfield(
                hintText: 'Name',
              ),
              const CustomTextfield(
                hintText: 'Email',
              ),
              const CustomTextfield(
                hintText: 'Write your text',
                minLines: 6,
              ),
              const Spacer(
                flex: 2,
              ),
              primaryButton(context, title: 'Send'),
              Gap(MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}
