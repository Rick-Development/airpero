import 'package:waiz/resources/views/auth_views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../app/http/controllers/auth/auth_controller.dart';
import '../../../app/http/controllers/user_controller.dart';
import '../../utils/app_colors.dart';
import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/usable_loading.dart';
import '../../widgets/usable_textfield.dart';
import '../home.dart';
import 'forgot_password.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());



    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();


    return Scaffold(
      body: Stack(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
       child:  Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(MediaQuery.of(context).padding.top + 14),
            // Using Obx to listen for loading state changes

            const Gap(38),
            Text(
              'Login with Email',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: Colors.black,
                  ),
            ),
            const Gap(8),
            Text(
              'Please enter email and password to login into your account',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.textGreyColor,
                  ),
              textAlign: TextAlign.center,
            ),

            const Gap(30),
            UsableTextField(
              controller: usernameController,
              label: 'Email',
              // keyboardType: Keyboa,
            ),
            const Gap(15),
              UsableTextField(
              controller: passwordController,
              label: 'Password',
                  keyboardType: TextInputType.visiblePassword,
            ),
            const Gap(21),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ForgotPasswordView(),
                ));
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: AppColors.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
            ),
            const Spacer(),
            primaryButton(context, color: AppColors.primaryColor, title: 'Login', onTap: () async {
             if(await authController.login(email: usernameController.text, password: passwordController.text)){

               UserController userController = Get.put(UserController());
               // Delay for 10 seconds
               // await Future.delayed(const Duration(seconds: 5));
               Get.snackbar("Success", "Login successfully", backgroundColor: Colors.blue, colorText: Colors.white);
               // authController.isLoading.value = false;
               Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const Home(),
              ));
             }else{
               Get.snackbar("", "Login failed. please try again",backgroundColor: Colors.red,colorText: Colors.white);
              }
            }),
            const Gap(38),

      Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.blackColor,
                      ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(SignUpScreen());
                  },
                  child: Text(
                    'Create account',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                  ),
                ),
              ],
            ),
            const Gap(40),
          ],
        ),
        ),
    Obx(() {
    return authController.isLoading.value
    ? const UsableLoading() : Container(); // Show loading animation
    }),
    ]
      ),
    );
  }
}
