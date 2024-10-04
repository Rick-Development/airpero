import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../utils/app_colors.dart';
import '../../utils/button.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final langs = [
      {'img': 'arabic', 'lang': 'Arabic'},
      {'img': 'us', 'lang': 'English'},
      {'img': 'hindi', 'lang': 'Hindi'},
      {'img': 'french', 'lang': 'French'},
      {'img': 'german', 'lang': 'German'},
      {'img': 'port', 'lang': 'Portuguese'},
      {'img': 'turk', 'lang': 'Turkish'},
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
                      'Change Language',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(34),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(langs.length, (index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: languageTile(
                      context,
                      img: langs[index]['img'] ?? '',
                      lang: langs[index]['lang'] ?? '',
                      isSelected: index == selectedIndex,
                    ),
                  );
                }),
              ),
              const Gap(24),
              primaryButton(
                context,
                title: 'Save',
                onTap: Navigator.of(context).pop,
              ),
              const Gap(36),
            ],
          ),
        ),
      ),
    );
  }
}

Widget languageTile(
  BuildContext context, {
  bool isSelected = false,
  required String img,
  required String lang,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF5F5F5),
        border: isSelected ? Border.all(color: AppColors.primaryColor) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/$img.png'),
              const Gap(14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF5A5A5A),
                        ),
                  ),
                  Text(
                    lang,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFB8B8B8),
                        ),
                  )
                ],
              ),
            ],
          ),
          SvgPicture.asset(
              'assets/svgs/${isSelected ? 'check-var' : 'uncheck'}.svg')
        ],
      ),
    );
