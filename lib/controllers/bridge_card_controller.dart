import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;


import '../utils/services/helpers.dart';

class BridgeCardController extends GetxController {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  final formKey = GlobalKey<FormState>();
  static const String _authToken = 'at_test_f1d330d748e8b92be0dbe4978cac304701071fc9faa3d9f08dac8f645135e36f7bac9c458dcc4ed68653af5baf201ecfe8e24fd9b1c981fbb6932401b3a061a8016995a0ee3712dd5dedb0d705a2b7de4c32de1fe99783a60fa2385b1a67fa328c9c3b0a43ac197ded9db3857b7a2de39e23a51d9b6aefbb740cfd64ed3aa9bd4486b9aa20c7f0fe96a6bfd638b662c2597277980202ee4ff2b3a1b43a84012cd1da2860248de647f2cd432ea852735d257d6261efb04de678318c8722e4d7b37a8e7384163789505938caff7dc769b369af4efd05a0209a2c6f16534446bf3a347a1549b11824344a370bc17129b4f55d1b582a6dd2982d92d565f005858035';



  // -----------------------Card Reg Controllers--------------------------
// User Information Controllers
  TextEditingController signupFirstNameEditingController = TextEditingController();
  TextEditingController signupLastNameEditingController = TextEditingController();
  TextEditingController signUpUserNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneNumberEditingController = TextEditingController();
  TextEditingController signUpPassEditingController = TextEditingController();
  TextEditingController confirmPassEditingController = TextEditingController();

// Address Controllers
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController stateEditingController = TextEditingController();
  TextEditingController countryEditingController = TextEditingController();
  TextEditingController postalCodeEditingController = TextEditingController();
  TextEditingController houseNoEditingController = TextEditingController();

// Identity Verification Controllers
  TextEditingController idTypeEditingController = TextEditingController();
  TextEditingController bvnEditingController = TextEditingController();
  TextEditingController selfieImageEditingController = TextEditingController();

// Form Validation Values (for storing user inputs)
  String signupFirstNameVal = "";
  String signupLastNameVal = "";
  String signUpUserNameVal = "";
  String emailVal = "";
  String phoneNumberVal = "";
  String signUpPassVal = "";
  String signUpConfirmPassVal = "";
  String addressVal = "";
  String cityVal = "";
  String stateVal = "";
  String countryVal = "";
  String postalCodeVal = "";
  String houseNoVal = "";
  String idTypeVal = "";
  String bvnVal = "";
  String selfieImageVal = "";
  String selectedCurrency = 'USD';

// Country Information
  String countryCode = 'US';
  String phoneCode = '+1';
  String countryName = 'United States';

// Method to Clear Signup Controllers
  clearSignUpController() {
    signupFirstNameEditingController.clear();
    signupLastNameEditingController.clear();
    signUpUserNameEditingController.clear();
    emailEditingController.clear();
    phoneNumberEditingController.clear();
    signUpPassEditingController.clear();
    confirmPassEditingController.clear();

    // Clear Address controllers
    addressEditingController.clear();
    cityEditingController.clear();
    stateEditingController.clear();
    countryEditingController.clear();
    postalCodeEditingController.clear();
    houseNoEditingController.clear();

    // Clear Identity controllers
    idTypeEditingController.clear();
    bvnEditingController.clear();
    selfieImageEditingController.clear();

    // Reset all stored values
    signupFirstNameVal = "";
    signupLastNameVal = "";
    signUpUserNameVal = "";
    emailVal = "";
    phoneNumberVal = "";
    signUpPassVal = "";
    signUpConfirmPassVal = "";
    addressVal = "";
    cityVal = "";
    stateVal = "";
    countryVal = "";
    postalCodeVal = "";
    houseNoVal = "";
    idTypeVal = "";
    bvnVal = "";
    selfieImageVal = "";
  } XFile? pickedImage;
  String? base64ImageString;
  Map<String, String> imagePickerResults = {};
  Map<String, http.MultipartFile> fileMap = {};

  // Function to pick an image and display it
  Future<void> pickImage(ImageSource source) async {
    final checkPermission = await Permission.camera.request();

    if (checkPermission.isGranted) {
      final picker = ImagePicker();
      final XFile? pickedImageFile = await picker.pickImage(source: source);

      if (pickedImageFile != null) {
        final File imageFile = File(pickedImageFile.path);

        // Compress the image
        Uint8List imageBytes = await imageFile.readAsBytes();
        img.Image? originalImage = img.decodeImage(imageBytes);
        if (originalImage != null) {
          // Resize and compress the image
          img.Image resizedImage = img.copyResize(originalImage, width: 1080); // Adjust the width as needed
          Uint8List compressedBytes = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 80)); // Adjust quality as needed
          File compressedImageFile = File(pickedImageFile.path)..writeAsBytesSync(compressedBytes);

          final int fileSizeInBytes = compressedImageFile.lengthSync();
          final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
          pickedImage = pickedImageFile;
          update();

          if (fileSizeInMB >= 4) {
            Helpers.showSnackBar(
                msg: "Image size exceeds 4 MB even after compression. Please choose a smaller image."
            );
          } else {
            log("Compressed image selected: ${pickedImage!.path}");

            // Convert compressed image to Base64
            base64ImageString = await _convertImageToBase64(compressedImageFile);
            update();

            log("Base64 Image: $base64ImageString");

            // Multipart File for upload
            final file = await http.MultipartFile.fromPath(
                'image', compressedImageFile.path);
            fileMap['image'] = file;

            log("Multipart File: $file");
          }
        }
      }
    } else {
      Helpers.showSnackBar(
          msg: "Please grant camera permission in app settings to use this feature."
      );
    }}

  // Function to convert an image file to Base64 string
  Future<String> _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }


  Future<void> registerCardholder() async {
    _isLoading=true;
    update();
    // API URL
    String url = "https://issuecards.api.bridgecard.co/v1/issuing/sandbox/cardholder/register_cardholder_synchronously";

    // Request body as a JSON payload
    Map<String, dynamic> payload = {
      "first_name": signupFirstNameVal,
      "last_name": signupLastNameVal,
      "address": {
        "address": addressVal,
        "city": cityVal,
        "state": stateVal,
        "country": countryVal,
        "postal_code": postalCodeVal,
        "house_no": houseNoVal
      },
      "phone": phoneNumberVal,
      "email_address": emailVal,
      "identity": {
        "id_type": "NIGERIAN_BVN_VERIFICATION",
        "bvn": bvnVal,
        "selfie_image": base64ImageString
      },
      "meta_data": {"Secret Key": "any_value"}
    };

    // Headers
    Map<String, String> headers = {
      'token': 'Bearer $_authToken',  // Replace with your token
      'Content-Type': 'application/json'
    };

    try {
      log("Base 64");
      log(base64ImageString!);
      // Making the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload), // Encode the payload to JSON
      );

      // Log response for debugging
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        _isLoading=false;
        update();


        // Handle the successful response
        Helpers.showSnackBar(
            msg: "Cardholder registered successfully: $data"
        );
        // You can call a function here to handle the API response, e.g., show success dialog or update state
      } else {
        // Handle errors
        log("Error: ${response.statusCode}");
        log("Error Body: ${response.body}");
        _isLoading=false;
        update();


        Helpers.showSnackBar(
            msg: "Error ${response.statusCode} : ${response.body}"
        );
      }
    } catch (e) {
      // Handle any other errors, such as network issues
      log('An error occurred: $e');
    }
  }






// Future<void> pickFile(String fieldName) async {
  //   log("camera call");
  //   final storageStatus = await Permission.storage.request();
  //
  //   if (storageStatus.isGranted) {
  //     try {
  //       final picker = ImagePicker();
  //       pickedImageFile = await picker.pickImage(source: ImageSource.camera);
  //
  //       if (pickedImageFile != null) {
  //         imagePickerResults[fieldName] = pickedImageFile;
  //         final file = await http.MultipartFile.fromPath(
  //             fieldName, pickedImageFile!.path);
  //         fileMap[fieldName] = file;
  //         log("image picker");
  //         log(file.toString());
  //         update();
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print("Error while picking files: $e");
  //       }
  //     }
  //   } else {
  //     Helpers.showSnackBar(
  //         msg:
  //         "Please grant camera permission in app settings to use this feature.");
  //   }
  // }

}