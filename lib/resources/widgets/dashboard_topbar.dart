


import 'package:waiz/resources/views/profile/profile.dart';
import 'package:waiz/resources/views/profile/profile_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../app/Models/user/User.dart';
import '../utils/app_colors.dart';
import '../views/home/add_money/add_money.dart';

class DasboardTopBar extends StatelessWidget{

  Widget build(BuildContext context){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
      InkWell(
        onTap: () => Get.to(const ProfileSettingView()),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primaryColor,
          child: ClipOval(
            child: Image.asset(
              'assets/images/img.png',
              width: 32, // Ensure the width and height are consistent
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
            const Gap(8),
            Text('Hi, ${User().username} 👋🏿',
            style: TextStyle(
              fontSize: 16,
            ),),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddMoney()));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Gap(8),
              SvgPicture.asset('assets/svgs/add.svg'),
              const Gap(8),
              SvgPicture.asset('assets/svgs/notification.svg'),
            ],
          ),
        ),
      ],
    );
  }
}