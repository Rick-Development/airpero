import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/config/styles.dart';
import 'package:waiz/controllers/app_controller.dart';
import 'package:waiz/utils/app_constants.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import 'package:get/get.dart';
import 'package:waiz/views/widgets/mediaquery_extension.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/services/localstorage/keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AppController appController = Get.find<AppController>();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    Future.delayed(const Duration(seconds: 3), () {
      HiveHelp.read(Keys.token) != null
          ? Get.offAllNamed(RoutesName.bottomNavBar)
          : HiveHelp.read(Keys.isNewUser) != null
              ? Get.offAllNamed(RoutesName.loginScreen)
              : Get.offAllNamed(RoutesName.onbordingScreen);
    });
    appController.getAppConfig();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.mQuery.width,
      height: context.mQuery.height,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("$rootImageDir/splash_bg.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: AppColors.mainColor.withOpacity(.3),
        body: SizedBox(
          width: context.mQuery.width,
          height: context.mQuery.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Image.asset(
                        "$rootImageDir/splash_middle.png",
                        width: 174.h,
                        height: 174.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 70.h,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        'Waiz',
                        speed: Duration(milliseconds: 500),
                        textStyle: context.t.titleLarge!.copyWith(
                            fontSize: 40.sp,
                            color: AppColors.blackColor,
                            fontFamily: Styles.secondaryFontFamily),
                        colors: [
                          AppColors.mainColor,
                          AppColors.blackColor,
                        ],
                      ),
                    ],
                    isRepeatingAnimation: false,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
