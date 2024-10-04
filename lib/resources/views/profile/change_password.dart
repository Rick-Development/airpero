import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/app/http/controllers/auth/auth_controller.dart';
import 'package:waiz/app/http/controllers/password_controller.dart';
import 'package:waiz/resources/widgets/usable_loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _changePasswordView();
}

class _changePasswordView extends State<ChangePasswordView>{
  late final TextEditingController oldPassword;
  late final TextEditingController newPassword;
  late final TextEditingController confirmNewPassword;
  late PasswordController passwordController = Get.put(PasswordController());



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldPassword = TextEditingController();
    newPassword = TextEditingController();
    confirmNewPassword = TextEditingController();
    passwordController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx((){
        return passwordController.isLoading.value ? const UsableLoading() :
        SingleChildScrollView(
          child: Padding(
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
                          'Change Password',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(34),
                   CustomTextfield(
                    hintText: 'Old Password',
                    obscureText: true,
                     ctrl: oldPassword,
                  ),
                  const Gap(4),
                   CustomTextfield(
                    hintText: 'New Password',
                    obscureText: true,
                    ctrl: newPassword,
                  ),
                  const Gap(4),
                   CustomTextfield(
                    hintText: 'Confirm Password',
                    obscureText: true,
                     ctrl: confirmNewPassword,
                  ),
                  const Gap(45),
                  primaryButton(
                    context,
                    title: 'Save',
                    onTap: () async =>
                    {
                    await passwordController.validate(
                        oldPassword: oldPassword.text, password: newPassword.text,password_confirmation: confirmNewPassword.text)
                      // if( await passwordController.validate(
                      //     email: User().email, password: oldPassword.text) == true){
                      //   if(newPassword == oldPassword){
                      //     passwordController.changePassword(newPassword.text)
                      //   } else
                      //     {
                      //       Get.snackbar(
                      //         'Error',
                      //         'Password mismatch',
                      //         snackPosition: SnackPosition.BOTTOM,
                      //         backgroundColor: Colors.red,
                      //         colorText: Colors.white,
                      //         icon: const Icon(Icons.warning_amber_rounded,
                      //             color: Colors.white),
                      //       ),
                      //       passwordController.isLoading.value = false
                      //     }
                      // } else
                      //   {
                      //     Get.snackbar(
                      //       'Error',
                      //       'Incorrect old password',
                      //       snackPosition: SnackPosition.BOTTOM,
                      //       backgroundColor: Colors.red,
                      //       colorText: Colors.white,
                      //       icon: const Icon(Icons.warning_amber_rounded,
                      //           color: Colors.white),
                      //     ),
                      //     passwordController.isLoading.value = false
                      //   },
                    }
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
