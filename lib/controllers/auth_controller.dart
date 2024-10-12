import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:waiz/data/repositories/auth_repo.dart';
import 'package:waiz/data/source/check_status.dart';
import 'package:waiz/utils/services/helpers.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../routes/routes_name.dart';
import '../utils/services/localstorage/keys.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  bool isLoading = false;

  // -----------------------sign in--------------------------
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController signInPassEditingController = TextEditingController();

  String userNameVal = "";
  String singInPassVal = "";
  bool isRemember = false;
  bool isBiometricOn = false;

  @override
  void onReady() {
    super.onReady();
    checkBiometrics();
    hasSavedCredentials();
    checkBiometricOn();
    // Check biometrics availability on ready
  }

  void removeSavedCredentials() {
    HiveHelp.remove(Keys.userName);
    HiveHelp.remove(Keys.userPass);
    HiveHelp.remove(Keys.isBiometricOn);
    userNameEditingController.clear();
    signInPassEditingController.clear();
    userNameVal = '';
    singInPassVal = '';
  }

  final LocalAuthentication auth = LocalAuthentication();
  bool isBiometricSupported = false;
  bool isFaceID = false;
  bool isFingerprint = false;

  // Check for biometrics support
  Future<void> checkBiometrics() async {
    try {
      isBiometricSupported = await auth.canCheckBiometrics;
      List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face)) {
        isFaceID = true;
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        isFingerprint = true;
      }
    } catch (e) {
      isBiometricSupported = false;
    }
    update();
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to log in',
          options: const AuthenticationOptions(biometricOnly: true,stickyAuth: true,useErrorDialogs: true));
    } catch (e) {
      // Handle error
    }
    return authenticated;
  }

  // Call this function to login using biometrics
  Future<void> loginWithBiometrics() async {
    bool authenticated = await authenticateWithBiometrics();
    try{
      if (authenticated) {
        // Retrieve the saved username and password from Hive or local storage
        String? savedUsername = HiveHelp.read(Keys.userName);
        String? savedPassword = HiveHelp.read(Keys.userPass);

        if (savedUsername != null && savedPassword != null) {
          userNameEditingController.text = savedUsername;
          // signInPassEditingController.text = savedPassword;
          userNameVal = savedUsername;
          singInPassVal = savedPassword;
          // Perform the login logic with saved credentials
          await login();
        }
      }

    }catch(e){
      if (e.toString().contains('locked out')) {
        // Handle lockout by disabling biometrics
        isBiometricOn = false;
        Get.snackbar("Biometric Lockout", "Too many failed attempts. Please use your password.");
      } else {
        // Handle other biometric-related errors
        Get.snackbar("Authentication Error", "Biometric authentication failed. Please try again.");
      }
    }
  }



  // Check if saved credentials exist
  bool hasSavedCredentials() {
    return HiveHelp.read(Keys.userName) != null && HiveHelp.read(Keys.userPass) != null;
  }

  checkBiometricOn(){
    if (HiveHelp.read(Keys.isBiometricOn) != null) {
      isBiometricOn = HiveHelp.read(Keys.isBiometricOn);
      update();
    }
  }


  clearSignInController() {
    userNameEditingController.clear();
    signInPassEditingController.clear();
    userNameVal = "";
    singInPassVal = "";
  }

  Future login() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.login(data: {
      "username": userNameVal,
      "password": singInPassVal,
    });
    isLoading = false;
    update();
    // Get.offAllNamed(RoutesName.bottomNavBar);
    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        ApiStatus.checkStatus(data['status'], data['message']['message']);
        if (isRemember == true ) {
          HiveHelp.write(Keys.userName, userNameVal);
          HiveHelp.write(Keys.userPass, singInPassVal);
        }if (isBiometricOn == true ) {
          HiveHelp.write(Keys.userName, userNameVal);
          HiveHelp.write(Keys.userPass, singInPassVal);
        }if(isBiometricOn==false){
          removeSavedCredentials();
        }
        HiveHelp.write(Keys.token, data['message']['token']);
        Get.offAllNamed(RoutesName.bottomNavBar);
        clearSignInController();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  // -----------------------sign up--------------------------
  TextEditingController signupFirstNameEditingController =
      TextEditingController();
  TextEditingController signupLastNameEditingController =
      TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController signUpUserNameEditingController =
      TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController signUpPassEditingController = TextEditingController();
  TextEditingController confirmPassEditingController = TextEditingController();

  String signupFirstNameVal = "";
  String signupLastNameVal = "";
  String signUpUserNameVal = "";
  String emailVal = "";
  String phoneNumberVal = "";
  String signUpPassVal = "";
  String signUpConfirmPassVal = "";
  String countryCode = 'US';
  String phoneCode = '+1';
  String countryName = 'United States';

  clearSignUpController() {
    emailEditingController.clear();
    signUpUserNameEditingController.clear();
    signupFirstNameEditingController.clear();
    signupLastNameEditingController.clear();
    phoneNumberEditingController.clear();
    signUpPassEditingController.clear();
    confirmPassEditingController.clear();
    signupFirstNameVal = "";
    signupLastNameVal = "";
    signUpUserNameVal = "";
    emailVal = "";
    phoneNumberVal = "";
    signUpPassVal = "";
    signUpConfirmPassVal = "";
  }

  Future register() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.register(data: {
      "firstname": signupFirstNameVal,
      "lastname": signupLastNameVal,
      "username": signUpUserNameVal,
      'email': emailEditingController.text,
      'country_code': countryCode,
      "phone_code": phoneCode,
      "country": countryName,
      "phone": phoneNumberVal,
      "password": signUpPassVal,
      "password_confirmation": signUpConfirmPassVal
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        ApiStatus.checkStatus(
            data['status'], "User account created successfully.");
        HiveHelp.write(Keys.token, data['message']);
        Get.offAllNamed(RoutesName.bottomNavBar);
        clearSignUpController();
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //------------------------forgot password----------------------
  TextEditingController forgotPassEmailEditingController =
      TextEditingController();
  TextEditingController forgotPassNewPassEditingController =
      TextEditingController();
  TextEditingController forgotPassConfirmPassEditingController =
      TextEditingController();
  TextEditingController otpEditingController1 = TextEditingController();
  TextEditingController otpEditingController2 = TextEditingController();
  TextEditingController otpEditingController3 = TextEditingController();
  TextEditingController otpEditingController4 = TextEditingController();
  TextEditingController otpEditingController5 = TextEditingController();

  String forgotPassEmailVal = "";
  String forgotPassNewPassVal = "";
  String forgotPassConfirmPassVal = "";
  String otpVal1 = "";
  String otpVal2 = "";
  String otpVal3 = "";
  String otpVal4 = "";
  String otpVal5 = "";

  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  forgotPassNewPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  forgotPassConfirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  clearForgotPassVal() {
    forgotPassEmailEditingController.clear();
    forgotPassEmailVal = "";
  }

  clearForgotPassNewPassVal() {
    forgotPassNewPassEditingController.clear();
    forgotPassConfirmPassEditingController.clear();
    forgotPassNewPassVal = "";
    forgotPassConfirmPassVal = "";
  }

  clearForgotPassOtpVal() {
    otpEditingController1.clear();
    otpEditingController2.clear();
    otpEditingController3.clear();
    otpEditingController4.clear();
    otpEditingController5.clear();
    otpVal1 = "";
    otpVal2 = "";
    otpVal3 = "";
    otpVal4 = "";
    otpVal5 = "";
  }

  Future forgotPass({bool? isFromOtpPage = false}) async {
    if (isFromOtpPage == false) {
      isLoading = true;
      update();
    }
    http.Response response = await AuthRepo.forgotPass(data: {
      "email": forgotPassEmailEditingController.text,
    });
    if (isFromOtpPage == false) {
      isLoading = false;
      update();
    }
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.toNamed(RoutesName.otpScreen);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //----------------------verify email-----------------
  ///COUNT DOWN TIMER
  int counter = 60;
  late Timer timer;
  bool isStartTimer = false;
  Duration duration = const Duration(seconds: 1);

  void startTimer() {
    timer = Timer.periodic(duration, (timer) {
      if (counter > 0) {
        counter -= 1;
        isStartTimer = true;
        update();
      } else {
        timer.cancel();
        counter = 60;
        isStartTimer = false;
        update();
      }
    });
  }

  Future geCode() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.getCode(data: {
      "email": forgotPassEmailEditingController.text,
      "code": '${otpVal1 + otpVal2 + otpVal3 + otpVal4}',
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.toNamed(RoutesName.createNewPassScreen);
        clearForgotPassOtpVal();
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  Future updatePass() async {
    isLoading = true;
    update();
    http.Response response = await AuthRepo.updatePass(data: {
      "password": forgotPassNewPassEditingController.text,
      "password_confirmation": forgotPassConfirmPassEditingController.text,
      "email": forgotPassEmailEditingController.text,
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Get.offAllNamed(RoutesName.loginScreen);
        clearForgotPassNewPassVal();
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }
}
