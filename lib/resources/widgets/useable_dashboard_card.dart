import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class UsableDashboardCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  // final Widget view;

  const UsableDashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconBackgroundColor,
     // this.view,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        height: 120,
        width: 150,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: iconBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon,
                ),
              ),
            ),
            const Gap(16),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black,
              ),
            )
          ],
        ),

    );
  }
}
