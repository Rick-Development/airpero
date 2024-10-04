import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/app/http/controllers/auth/auth_controller.dart';
import 'package:waiz/app/http/controllers/pin_controller.dart';
import 'package:waiz/resources/widgets/usable_loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../utils/button.dart';
import '../../widgets/custom_textfield.dart';


class ChangePinView extends StatefulWidget {
  const ChangePinView({super.key});


  State<ChangePinView> createState() => _changePinState();
}

class _changePinState extends State<ChangePinView>{
  late final TextEditingController oldPin;
  late final TextEditingController newPin;
  late final TextEditingController confrinNewPin;
  late final PinController pinController = Get.put(PinController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldPin = TextEditingController();
    newPin = TextEditingController();
    confrinNewPin = TextEditingController();
    pinController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx((){
        return pinController.isLoading.value ? const UsableLoading() : SingleChildScrollView(
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
                            'Change Pin',
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
                      hintText: 'Old PIN',
                      obscureText: true,
                      ctrl: oldPin,
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(4),
                    CustomTextfield(
                      hintText: 'New PIN',
                      obscureText: true,
                      ctrl: newPin,
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(4),
                    CustomTextfield(
                      hintText: 'Confirm PIN',
                      obscureText: true,
                      ctrl: confrinNewPin,
                      keyboardType: TextInputType.number,
                    ),
                    const Gap(45),
                    primaryButton(
                      context,
                      title: 'Save',
                      onTap: () async =>{
                        if(oldPin.text == User().pin){
                          if(newPin.text == confrinNewPin.text){
                            await  pinController.changePin(newPin.text)
                          }else{
                            Get.snackbar(
                              'Error',
                              'New Pin mismatch',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
                            )
                          }
                        }else{
                          Get.snackbar(
                            'Error',
                            'Incorrect old pin',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
                          )
                        }

                      },
                    )
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
