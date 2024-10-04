import 'package:waiz/app/http/controllers/pin_controller.dart';
import 'package:waiz/resources/views/virtual_dollar_card/card_details_view.dart';
import 'package:waiz/resources/widgets/usable_loading.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../app/Models/user/User.dart';
import '../../app/http/controllers/deposit_controller.dart';
import '../../app/http/controllers/live_chat_controller.dart';
import '../../app/http/controllers/user_controller.dart';
import '../../app/http/controllers/wallet_controller.dart';
import '../../routes/routes.dart';
import '../utils/app_colors.dart';
import 'profile/profile.dart';
import 'virtual_dollar_card/virtual_dollar_card.dart';
// import 'wallet/wallet.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isVerified = true;
  bool isConnected = true;
  late WalletController walletController = Get.put(WalletController());
  late DepositController depositController  = Get.put(DepositController(user: User()));
  late UserController userController = Get.put(UserController());
  late PinController pinController = Get.put(PinController());

  @override
  void initState() {
    super.initState();
    Get.put(LiveChatController());
    laodDashboard ();
    // Assuming `User().isKYCVerified` is a synchronous check, no need for setState.
    isVerified = User().isKYCVerified;
    checkConnectivity();
  }

  Future<void> laodDashboard () async{
  await walletController.fetchResponse();
  await depositController.fetchResponse("deposit_methods",WebRoutes.depositMethods);
  // await pinController.initPin();
 userController.isLoading.value = false;

  }

  Future<void> checkConnectivity() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isConnected = false;
          print("No Internet Connection");
        });
      } else {
        setState(() {
          isConnected = true;
          print("Connected to the Internet");
        });
      }
    });
  }


  List<Map<String, dynamic>> get _navItems => [
    // {'label': 'Home', 'svg': 'assets/svgs/home_off.svg', 'widget': const WalletView()},
    // {'label': 'Wallet', 'svg': 'assets/svgs/wallet.svg', 'widget': const WalletView()},
    {
      'label': 'Virtual Card',
      'svg': 'assets/svgs/card.svg',
      'widget':  const VirtualDollarCard()
    },
    {'label': 'Profile', 'svg': 'assets/svgs/person.svg', 'widget': const ProfileView()},
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close the sidebar after selecting
  }

  @override
  Widget build(BuildContext context) {
    laodDashboard ();
    return Scaffold(
      body:Obx((){
        return  isConnected
            ?  userController.isLoading.value ?  const UsableLoading() : _navItems[_selectedIndex]['widget']
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.signal_wifi_off, size: 50),
              Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 24.sp),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        height: 74,
        decoration: const BoxDecoration(
          color: AppColors.whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final selected = index == _selectedIndex;
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            _navItems[index]['svg'],
                            colorFilter: ColorFilter.mode(
                              selected
                                  ? AppColors.primaryColor
                                  : AppColors.iconGreyColor2,
                              BlendMode.srcIn,
                            ),
                          ),
                          if (selected)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              top: 0,
                              child: SvgPicture.asset(
                                'assets/svgs/on_home.svg',
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Text(
                      _navItems[index]['label'],
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: selected
                            ? AppColors.primaryColor
                            : AppColors.iconGreyColor2,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

