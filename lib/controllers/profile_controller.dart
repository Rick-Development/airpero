import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waiz/utils/services/localstorage/hive.dart';
import '../../config/app_colors.dart';
import '../data/models/profile_model.dart';
import '../data/repositories/profile_repo.dart';
import '../data/source/check_status.dart';
import '../utils/services/helpers.dart';
import '../utils/services/localstorage/keys.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  bool isLoading = false;

  // -----------------------edit profile--------------------------
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController addressLine1EditingController = TextEditingController();
  TextEditingController addressLine2EditingController = TextEditingController();

  Future validateEditProfile(context) async {
    if (firstNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(
        msg: 'First Name is required',
      );
    } else if (lastNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(
        msg: 'Last Name is required',
      );
    } else if (userNameEditingController.text.isEmpty) {
      Helpers.showSnackBar(
        msg: 'User Name is required',
      );
    } else if (addressLine1EditingController.text.isEmpty) {
      Helpers.showSnackBar(
        msg: 'Address Line 1 is required',
      );
    } else if (phoneNumberEditingController.text.isEmpty) {
      Helpers.showSnackBar(
        msg: 'Phone Nubmer is required',
      );
    } else {
      await updateProfile(context);
    }
  }

  List<Profile> profileList = [];
  String userId = '';
  String userPhoto = '';
  String userName = '';
  String join_date = '';
  String addressVerificationMsg = "";
  String selectedLanguage = "English";
  String selectedLanguageId = "1";
  bool isLanguageSelected = false;
  String userEmail = "";
  String countryCode = 'US';
  String phoneCode = '+1';
  String countryName = 'United States';
  Future getProfile() async {
    isLoading = true;
    update();
    http.Response response = await ProfileRepo.getProfile();
    profileList.clear();
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (data['status'] == 'success') {
        profileList.add(ProfileModel.fromJson(data).message!.profile!);
        if (profileList.isNotEmpty) {
          var data = profileList[0];
          _getInfo(data);
        }
      } else {
        ApiStatus.checkStatus(data['status'], data['message']);
      }
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  _getInfo(Profile? data) {
    userId = data == null ? '' : data.id.toString();
    userName = data == null ? '' : data.firstname! + " " + data.lastname!;
    userEmail = data == null ? '' : data.email ?? '';
    join_date = data == null ? '' : data.userJoinDate ?? "";
    userPhoto = data == null ? '' : data.image;
    firstNameEditingController.text = data == null ? '' : data.firstname ?? "";
    lastNameEditingController.text = data == null ? '' : data.lastname ?? "";
    userNameEditingController.text = data == null ? '' : data.username ?? "";
    emailEditingController.text = data == null ? '' : data.email ?? "";
    phoneNumberEditingController.text = data == null ? '' : data.phone ?? "";
    addressLine1EditingController.text =
        data == null ? '' : data.addressOne ?? "";
    addressLine2EditingController.text =
        data == null ? '' : data.addressTwo ?? "";
    selectedLanguageId = data == null
        ? "1"
        : data.language_id == null
            ? "1"
            : data.language_id.toString();
    selectedLanguage =
        data == null ? "English" : data.languageName ?? "English";
    phoneCode = data == null ? "" : data.phone_code;
    countryName = data == null ? "" : data.country;
    countryCode = data == null ? "" : data.country_code;
    // for showing in the GET OTP PAGE
    HiveHelp.write(Keys.userEmail, userEmail);
    HiveHelp.write(Keys.userPhone, phoneNumberEditingController.text);
    HiveHelp.write(
        Keys.userPhoneCode,
        data == null
            ? ""
            : data.phone_code == null
                ? ""
                : data.phone_code.toString());
    // for showing in the create recipient dialog of RECIPIENT LIST PAGE
    HiveHelp.write(Keys.userProfile, data == null ? "" : data.image ?? "");
  }

  bool isUpdateProfile = false;
  Future updateProfile(context) async {
    isUpdateProfile = true;
    update();
    http.Response response = await ProfileRepo.profileUpdate(data: {
      "first_name": firstNameEditingController.text,
      "last_name": lastNameEditingController.text,
      "username": userNameEditingController.text,
      "email": emailEditingController.text,
      "phone": phoneNumberEditingController.text,
      "language_id": selectedLanguageId,
      "address_one": addressLine1EditingController.text,
      "address_two": addressLine2EditingController.text,
      "phone_code": phoneCode,
      "country": countryName,
      "country_code": countryCode,
    });
    isUpdateProfile = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        getProfile();
        Navigator.of(context).pop();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  XFile? pickedImage;
  Future<void> pickImage(ImageSource source) async {
    final checkPermission = await Permission.camera.request();
    if (checkPermission.isGranted) {
      final picker = ImagePicker();
      final pickedImageFile = await picker.pickImage(source: source);
      final File imageFile = File(pickedImageFile!.path);
      final int fileSizeInBytes = await imageFile.length();
      final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      pickedImage = pickedImageFile;
      if (pickedImage != null) {
        if (fileSizeInMB >= 4) {
          Helpers.showSnackBar(
              msg: "Image size exceeds 4 MB. Please choose a smaller image.");
        } else {
          await ProfileController.to
              .updateProfilePhoto(filePath: pickedImage!.path);
        }
      }
      update();
    } else {
      Helpers.showSnackBar(
          msg:
              "Please grant camera permission in app settings to use this feature.");
    }
  }

  bool isUploadingPhoto = false;
  Future updateProfilePhoto({required String filePath}) async {
    isUploadingPhoto = true;
    update();
    http.Response response = await ProfileRepo.profileImageUpload(
        files: await http.MultipartFile.fromPath('image', filePath));
    isUploadingPhoto = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        await getProfile();
        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  //--------------------------change password--------------------------
  TextEditingController currentPassEditingController = TextEditingController();
  TextEditingController newPassEditingController = TextEditingController();
  TextEditingController confirmEditingController = TextEditingController();

  RxString currentPassVal = "".obs;
  RxString newPassVal = "".obs;
  RxString confirmPassVal = "".obs;

  bool currentPassShow = true;
  bool isNewPassShow = true;
  bool isConfirmPassShow = true;

  currentPassObscure() {
    currentPassShow = !currentPassShow;
    update();
  }

  newPassObscure() {
    isNewPassShow = !isNewPassShow;
    update();
  }

  confirmPassObscure() {
    isConfirmPassShow = !isConfirmPassShow;
    update();
  }

  void validateUpdatePass(context) async {
    if (newPassVal.value != confirmPassVal.value) {
      Helpers.showToast(
        msg: "New Password and Confirm Password didn't match!",
        gravity: ToastGravity.CENTER,
        bgColor: AppColors.redColor,
      );
    } else {
      await updateProfilePass(context);
    }
  }

  clearChangePasswordVal() {
    currentPassEditingController.clear();
    newPassEditingController.clear();
    confirmEditingController.clear();
    currentPassVal.value = '';
    newPassVal.value = '';
    confirmPassVal.value = '';
  }

  Future updateProfilePass(context) async {
    isLoading = true;
    update();
    http.Response response = await ProfileRepo.profilePassUpdate(data: {
      "current_password": currentPassVal.value,
      "password": newPassVal.value,
      "password_confirmation": confirmPassVal.value,
    });
    isLoading = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        clearChangePasswordVal();
        Navigator.of(context).pop();

        update();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }

  bool isUpdateEmail = false;
  Future updateEmail(
      {required BuildContext context, required String id}) async {
    isUpdateEmail = true;
    update();
    http.Response response = await ProfileRepo.emailUpdate(
        id: id, email: emailEditingController.text);
    isUpdateEmail = false;
    update();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ApiStatus.checkStatus(data['status'], data['message']);
      if (data['status'] == 'success') {
        Navigator.of(context).pop();
      }
      update();
    } else {
      Helpers.showSnackBar(msg: '${data['message']}');
    }
  }
}
