import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waiz/controllers/bindings/controller_index.dart';
import '../../../../config/app_colors.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/services/pop_app.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final Connectivity _connectivity = Connectivity();
  @override
  void initState() {
    _connectivity.onConnectivityChanged
        .listen(Get.find<AppController>().updateConnectionStatus);
    Get.put(PushNotificationController()).getPushNotificationConfig();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.put(ProfileController()).getProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (_) {
      return GetBuilder<BottomNavController>(builder: (controller) {
        return PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              if (didPop) {
                return;
              }
              return PopApp.onWillPop();
            },
            child: Scaffold(
              body: controller.currentScreen,
              bottomNavigationBar: SafeArea(
                child: Container(
                  height: 84.h,
                  padding: EdgeInsets.only(top: 33.h, left: 24.w, right: 24.w),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: _.isDarkMode() == true
                              ? AppColors.darkBgColor
                              : Colors.grey.shade100,
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            _.isDarkMode() == true
                                ? AppColors.darkCardColor
                                : AppColors
                                    .whiteColor, // Apply a red tint with 50% opacity
                            BlendMode.srcATop, // Use 'srcATop' blend mode
                          ),
                          image:
                              AssetImage("$rootImageDir/bottom_nav_shape.png"),
                          fit: BoxFit.cover)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(0);
                        },
                        child: Image.asset(
                          controller.selectedIndex == 0
                              ? "$rootImageDir/home1.png"
                              : "$rootImageDir/home.png",
                          height: 24.h,
                          color: _.isDarkMode() == true
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 85.w),
                        child: InkResponse(
                          onTap: () {
                            controller.changeScreen(1);
                          },
                          child: Image.asset(
                            controller.selectedIndex == 1
                                ? "$rootImageDir/wallet1.png"
                                : "$rootImageDir/wallet.png",
                            height: controller.selectedIndex == 1 ? 28.h : 26.h,
                            color: _.isDarkMode() == true
                                ? AppColors.whiteColor
                                : AppColors.blackColor,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(2);
                        },
                        child: Image.asset(
                          controller.selectedIndex == 2
                              ? "$rootImageDir/recipients1.png"
                              : "$rootImageDir/recipients.png",
                          height: controller.selectedIndex == 2 ? 22.h : 24.h,
                          width: controller.selectedIndex == 2 ? 25.w : 36.w,
                          color: _.isDarkMode() == true
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          fit: controller.selectedIndex == 2
                              ? BoxFit.fitWidth
                              : BoxFit.cover,
                        ),
                      ),
                      InkResponse(
                        onTap: () {
                          controller.changeScreen(3);
                        },
                        child: Image.asset(
                          controller.selectedIndex == 3
                              ? "$rootImageDir/person2.png"
                              : "$rootImageDir/person.png",
                          height: controller.selectedIndex == 3 ? 20.h : 23.h,
                          color: _.isDarkMode() == true
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: _.isDarkMode() == true
                              ? AppColors.darkBgColor
                              : Color(0xffD6CCF9),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: Offset(0, 5))
                    ],
                  ),
                  child: ClipOval(
                    child: FloatingActionButton(
                      backgroundColor: AppColors.blackColor,
                      child: Image.asset(
                        "$rootImageDir/money_transfer.png",
                        fit: BoxFit.cover,
                        height: 26.h,
                        width: 26.h,
                      ),
                      onPressed: () {
                        Get.delete<RecipientListController>();
                        MoneyTransferController.to.resetMoneyTransferData();
                        MoneyTransferController.to.getTransferCurrencies();
                        Get.toNamed(RoutesName.moneyTransferScreen1);
                      },
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            ));
      });
    });
  }
}
