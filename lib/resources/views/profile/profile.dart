import 'package:waiz/app/http/controllers/auth/auth_controller.dart';
import 'package:waiz/resources/views/auth_views/login.dart';
import 'package:waiz/resources/views/profile/profile_setting.dart';
import 'package:waiz/resources/views/profile/setting.dart';
import 'package:waiz/resources/views/profile/setting_transfer.dart';
import 'package:waiz/resources/views/profile/support.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../app/Models/user/User.dart';
import '../../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../website_viewer.dart';




class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    User user = new User();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Gap(MediaQuery.of(context).padding.top + 46),
            Container(
              height: 100,
              width: 100,
              child: CircleAvatar(
                // radius: 16,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/img.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Gap(20),
            Text(
              toBeginningOfSentenceCase(user.fullName) ?? '',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const Gap(14),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     // Text(
            //     //   'ID 28954761',
            //     //   style: Theme.of(context).textTheme.labelLarge?.copyWith(
            //     //         fontWeight: FontWeight.w400,
            //     //         fontSize: 19,
            //     //       ),
            //     // ),
            //     const Gap(6),
            //     const Icon(Icons.copy_outlined)
            //   ],
            // ),
            const Gap(43),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ProfileSettingView(),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF5F5F5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.primaryColor,
                      ),
                      child: SvgPicture.asset('assets/svgs/person.svg'),
                    ),
                    const Gap(15),
                    Text(
                      'Profile Setting',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: "Gilroy-Bold",
                            fontSize: 18,
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            const Gap(18),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const SettingView(),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF5F5F5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.primaryColor,
                      ),
                      child: SvgPicture.asset('assets/svgs/setting.svg'),
                    ),
                    const Gap(15),
                    Text(
                      'Setting',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                        fontFamily: "Gilroy-Bold",
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            const Gap(18),
            InkWell(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                  // builder: (_) => const SupportView(),
                  Get.to(Get.to(WebsiteViewer(url: WebRoutes.tawktoLink,title: 'Live Support',)));
                // ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF5F5F5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.primaryColor,
                      ),
                      child: SvgPicture.asset('assets/svgs/headset.svg'),
                    ),
                    const Gap(15),
                    Text(
                      'Support',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                        fontFamily: "Gilroy-Bold",
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            const Gap(18),
            InkWell(
              onTap: () => Get.snackbar("message", 'Comming Soon...'),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF5F5F5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.primaryColor,
                      ),
                      child: SvgPicture.asset('assets/svgs/about.svg'),
                    ),
                    const Gap(15),
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                        fontFamily: "Gilroy-Bold",
                          ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            const Gap(18),
            InkWell(
              onTap: () =>{
                authController.logout(context)

              },
              child:  Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFF5F5F5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFDF1313),
                      ),
                      child: SvgPicture.asset('assets/svgs/logout.svg'),
                    ),
                    const Gap(15),
                    Text(
                      'Logout',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: const Color(0xFFDF1313),
                        fontFamily: "Gilroy-Bold",
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
