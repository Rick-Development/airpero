import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UsableShortcut extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget view;

  const UsableShortcut({
    super.key,
    required this.title,
    required this.icon,
    required this.view,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => view,
      ));
    },
      child:  Container(
    padding: const EdgeInsets.all(5),
    height: 100,
    width: 80,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    // color: AppColors.primaryColor,
    //   color: Color(0xFFa5b5b5),
    ),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          const Gap(2),
          SizedBox(
            width: 60,
            child: Text(title,
              textAlign: TextAlign.center ,
            ),
          )
        ],
      ),
      ),
    );
  }
}
