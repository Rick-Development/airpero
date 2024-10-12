import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:waiz/config/dimensions.dart';
import 'package:waiz/controllers/bridge_card_controller.dart';
import 'package:waiz/controllers/card_controller.dart';
import 'package:waiz/views/widgets/app_button.dart';
import 'package:waiz/views/widgets/text_theme_extension.dart';
import '../../../config/app_colors.dart';
import '../../../themes/themes.dart';
import '../../../utils/services/helpers.dart';
import '../../../utils/services/localstorage/hive.dart';
import '../../../utils/services/localstorage/keys.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/spacing.dart';

class VirtualCardFormScreen extends StatefulWidget {
  final bool? isFromResubmit;

  const VirtualCardFormScreen({super.key, this.isFromResubmit = false});

  @override
  State<VirtualCardFormScreen> createState() => _VirtualCardFormScreenState();
}

class _VirtualCardFormScreenState extends State<VirtualCardFormScreen> {
  // Default selected currency

  @override
  Widget build(BuildContext context) {
    var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
    return GetBuilder<BridgeCardController>(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(title: "Virtual Card Form"),
        body: RefreshIndicator(
          onRefresh: () async {
            if (widget.isFromResubmit == false) {
              // await _.getCardOrder(isFromRefreshIndicator: false);
              // await _.filterData();
            } else {
              // _..clear();
              // _.filterData(isFromResubmit: widget.isFromResubmit);
              // await _.getVirtualCards();
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _.isLoading
                ? SizedBox(
                    height: Dimensions.screenHeight,
                    width: Dimensions.screenWidth,
                    child: Helpers.appLoader(),
                  )
                : Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: Dimensions.kDefaultPadding,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  storedLanguage['Card Currency'] ??
                                      "Card Currency",
                                  style: context.t.displayMedium,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Form(
                                key: _.formKey,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center, // Distribute space evenly
                                          children: [
                                            // Radio button for USD
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Radio<String>(
                                                  value: 'USD',
                                                  groupValue:
                                                      _.selectedCurrency,
                                                  onChanged: (v) {
                                                    _.selectedCurrency = v!;
                                                    _.update();

                                                    // setState(() {
                                                    //   selectedCurrency = value!;
                                                    // });
                                                  },
                                                ),
                                                const Text('USD'),
                                              ],
                                            ),
                                            // Radio button for Naira
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Radio<String>(
                                                  value: 'Naira',
                                                  groupValue:
                                                      _.selectedCurrency,
                                                  onChanged: (v) {
                                                    _.selectedCurrency = v!;
                                                    _.update();
                                                    // setState(() {
                                                    //   selectedCurrency = value!;
                                                    // });
                                                  },
                                                ),
                                                const Text('Naira'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomTextField(
                                        hintext: storedLanguage['First Name'] ??
                                            "First Name",
                                        isPrefixIcon: false,
                                        prefixIcon: 'edit',
                                        controller:
                                            _.signupFirstNameEditingController,
                                        onChanged: (v) {
                                          _.signupFirstNameVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext: storedLanguage['Last Name'] ??
                                            "Last Name",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller:
                                            _.signupLastNameEditingController,
                                        onChanged: (v) {
                                          _.signupLastNameVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext: storedLanguage['Address'] ??
                                            "Address",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.addressEditingController,
                                        onChanged: (v) {
                                          _.addressVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext:
                                            storedLanguage['City'] ?? "City",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.cityEditingController,
                                        onChanged: (v) {
                                          _.cityVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext:
                                            storedLanguage['State'] ?? "State",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.stateEditingController,
                                        onChanged: (v) {
                                          _.stateVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext: storedLanguage['Country'] ??
                                            "Country",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.countryEditingController,
                                        onChanged: (v) {
                                          _.countryVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext:
                                            storedLanguage['Postal Code'] ??
                                                "Postal Code",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller:
                                            _.postalCodeEditingController,
                                        onChanged: (v) {
                                          _.postalCodeVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext: storedLanguage['House No'] ??
                                            "House No",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.houseNoEditingController,
                                        onChanged: (v) {
                                          _.houseNoVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext:
                                            storedLanguage['Phone'] ?? "Phone",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller:
                                            _.phoneNumberEditingController,
                                        onChanged: (v) {
                                          _.phoneNumberVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext:
                                            storedLanguage['Email_address'] ??
                                                "Email address",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.emailEditingController,
                                        onChanged: (v) {
                                          _.emailVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      CustomTextField(
                                        hintext: storedLanguage['BVN Number'] ??
                                            "BVN Number",
                                        isPrefixIcon: false,
                                        prefixIcon: 'person',
                                        controller: _.bvnEditingController,
                                        onChanged: (v) {
                                          _.bvnVal = v;
                                          _.update();
                                        },
                                      ),
                                      VSpace(36.h),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          storedLanguage['Take A Selfie'] ??
                                              "Take A Selfie",
                                          style: context.t.displayMedium,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      VSpace(36.h),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Image preview or default image placeholder
                                          InkWell(
                                            onTap: () {
                                              _.pickImage(ImageSource.camera);
                                            },
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                // Circular border for the image
                                                child: _.pickedImage != null
                                                    ? Image.file(
                                                        File(_
                                                            .pickedImage!.path),
                                                        width: 200,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/images/default_image.png',
                                                        // Path to your default image
                                                        width: 200,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                      VSpace(16.h),

                                      SizedBox(
                                        width: double.infinity,
                                        child: Visibility(
                                          visible: _.isLoading == false,
                                          replacement: const CircularProgressIndicator(),
                                          child: ElevatedButton(onPressed: (){

                                            _.registerCardholder();
                                          }, child: Text("Submit")),
                                        ),
                                      ),
                                      VSpace(16.h),

                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 24.w, vertical: 20.h),
                      //   child: Form(
                      //     key: _.formKey,
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: <Widget>[
                      //         if (_.dynamicFormList.isNotEmpty) ...[
                      //           VSpace(30.h),
                      //           ListView.builder(
                      //             shrinkWrap: false,
                      //             physics: NeverScrollableScrollPhysics(),
                      //             itemCount: _.dynamicFormList.length,
                      //             itemBuilder: (context, index) {
                      //               final dynamicField =
                      //                   _.dynamicFormList[index];
                      //               return Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   if (dynamicField.type == "file")
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Text(
                      //                               dynamicField.fieldLevel,
                      //                               style: context.t.bodyLarge,
                      //                             ),
                      //                             dynamicField.validation ==
                      //                                     'required'
                      //                                 ? const SizedBox()
                      //                                 : Text(
                      //                                     " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                      //                                     style: context
                      //                                         .t.displayMedium,
                      //                                   ),
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 8.h,
                      //                         ),
                      //                         Container(
                      //                           height: 45.5,
                      //                           width: double.maxFinite,
                      //                           padding: EdgeInsets.symmetric(
                      //                               horizontal: 8.w,
                      //                               vertical: 10.h),
                      //                           decoration: BoxDecoration(
                      //                             color:
                      //                                 AppThemes.getFillColor(),
                      //                             borderRadius:
                      //                                 Dimensions.kBorderRadius,
                      //                             border: Border.all(
                      //                                 color:
                      //                                     _.fileColorOfDField,
                      //                                 width:
                      //                                     _.fileColorOfDField ==
                      //                                             AppColors
                      //                                                 .redColor
                      //                                         ? 1
                      //                                         : .2),
                      //                           ),
                      //                           child: Row(
                      //                             children: [
                      //                               HSpace(12.w),
                      //                               Text(
                      //                                 _.imagePickerResults[
                      //                                             dynamicField
                      //                                                 .fieldName] !=
                      //                                         null
                      //                                     ? storedLanguage[
                      //                                             '1 File selected'] ??
                      //                                         "1 File selected"
                      //                                     : storedLanguage[
                      //                                             'No File selected'] ??
                      //                                         "No File selected",
                      //                                 style: context.t.bodySmall?.copyWith(
                      //                                     color: _.imagePickerResults[
                      //                                                 dynamicField
                      //                                                     .fieldName] !=
                      //                                             null
                      //                                         ? AppColors
                      //                                             .greenColor
                      //                                         : AppColors
                      //                                             .black60),
                      //                               ),
                      //                               const Spacer(),
                      //                               Material(
                      //                                 color: Colors.transparent,
                      //                                 child: InkWell(
                      //                                   onTap: () async {
                      //                                     Helpers
                      //                                         .hideKeyboard();
                      //
                      //                                     await _.pickFile(
                      //                                         dynamicField
                      //                                             .fieldName);
                      //                                   },
                      //                                   borderRadius: Dimensions
                      //                                       .kBorderRadius,
                      //                                   child: Ink(
                      //                                     width: 113.w,
                      //                                     decoration:
                      //                                         BoxDecoration(
                      //                                       color: AppColors
                      //                                           .mainColor,
                      //                                       borderRadius:
                      //                                           Dimensions
                      //                                               .kBorderRadius,
                      //                                       border: Border.all(
                      //                                           color: AppColors
                      //                                               .mainColor,
                      //                                           width: .2),
                      //                                     ),
                      //                                     child: Center(
                      //                                         child: Text(
                      //                                             storedLanguage[
                      //                                                     'Choose File'] ??
                      //                                                 'Choose File',
                      //                                             style: context
                      //                                                 .t
                      //                                                 .bodySmall
                      //                                                 ?.copyWith(
                      //                                                     color:
                      //                                                         AppColors.whiteColor))),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 16.h,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   if (dynamicField.type == "text")
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Text(
                      //                               dynamicField.fieldLevel,
                      //                               style:
                      //                                   context.t.displayMedium,
                      //                             ),
                      //                             dynamicField.validation ==
                      //                                     'required'
                      //                                 ? const SizedBox()
                      //                                 : Text(
                      //                                     " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                      //                                     style: context
                      //                                         .t.displayMedium,
                      //                                   ),
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 8.h,
                      //                         ),
                      //                         TextFormField(
                      //                           validator: (value) {
                      //                             // Perform validation based on the 'validation' property
                      //                             if (dynamicField.validation ==
                      //                                     "required" &&
                      //                                 value!.isEmpty) {
                      //                               return storedLanguage[
                      //                                       'Field is required'] ??
                      //                                   "Field is required";
                      //                             }
                      //                             return null;
                      //                           },
                      //                           onChanged: (v) {
                      //                             _
                      //                                 .textEditingControllerMap[
                      //                                     dynamicField
                      //                                         .fieldName]!
                      //                                 .text = v;
                      //                           },
                      //                           controller:
                      //                               _.textEditingControllerMap[
                      //                                   dynamicField.fieldName],
                      //                           decoration: InputDecoration(
                      //                             hintText:
                      //                                 dynamicField.placeholder,
                      //                             contentPadding:
                      //                                 const EdgeInsets
                      //                                     .symmetric(
                      //                                     vertical: 0,
                      //                                     horizontal: 16),
                      //                             filled:
                      //                                 false, // Fill the background with color
                      //                             hintStyle: TextStyle(
                      //                               color: AppColors
                      //                                   .textFieldHintColor,
                      //                             ),
                      //                             fillColor: Colors
                      //                                 .transparent, // Background color
                      //                             enabledBorder:
                      //                                 OutlineInputBorder(
                      //                               borderSide: BorderSide(
                      //                                 color: AppThemes
                      //                                     .getSliderInactiveColor(),
                      //                                 width: 1,
                      //                               ),
                      //                               borderRadius: Dimensions
                      //                                   .kBorderRadius,
                      //                             ),
                      //
                      //                             focusedBorder:
                      //                                 OutlineInputBorder(
                      //                               borderRadius: Dimensions
                      //                                   .kBorderRadius,
                      //                               borderSide: BorderSide(
                      //                                   color: AppColors
                      //                                       .mainColor),
                      //                             ),
                      //                           ),
                      //                           style: context.t.bodyMedium,
                      //                         ),
                      //                         SizedBox(
                      //                           height: 16.h,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   if (dynamicField.type == "number")
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Text(
                      //                               dynamicField.fieldLevel,
                      //                               style:
                      //                                   context.t.displayMedium,
                      //                             ),
                      //                             dynamicField.validation ==
                      //                                     'required'
                      //                                 ? const SizedBox()
                      //                                 : Text(
                      //                                     " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                      //                                     style: context
                      //                                         .t.displayMedium,
                      //                                   ),
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 8.h,
                      //                         ),
                      //                         TextFormField(
                      //                           validator: (value) {
                      //                             // Perform validation based on the 'validation' property
                      //                             if (dynamicField.validation ==
                      //                                     "required" &&
                      //                                 value!.isEmpty) {
                      //                               return storedLanguage[
                      //                                       'Field is required'] ??
                      //                                   "Field is required";
                      //                             }
                      //                             return null;
                      //                           },
                      //                           onChanged: (v) {
                      //                             _
                      //                                 .textEditingControllerMap[
                      //                                     dynamicField
                      //                                         .fieldName]!
                      //                                 .text = v;
                      //                           },
                      //                           controller:
                      //                               _.textEditingControllerMap[
                      //                                   dynamicField.fieldName],
                      //                           keyboardType:
                      //                               TextInputType.number,
                      //                           inputFormatters: <TextInputFormatter>[
                      //                             FilteringTextInputFormatter
                      //                                 .digitsOnly,
                      //                           ],
                      //                           decoration: InputDecoration(
                      //                             hintText:
                      //                                 dynamicField.placeholder,
                      //                             contentPadding:
                      //                                 const EdgeInsets
                      //                                     .symmetric(
                      //                                     vertical: 0,
                      //                                     horizontal: 16),
                      //                             filled:
                      //                                 false, // Fill the background with color
                      //                             hintStyle: TextStyle(
                      //                               color: AppColors
                      //                                   .textFieldHintColor,
                      //                             ),
                      //                             fillColor: Colors
                      //                                 .transparent, // Background color
                      //                             enabledBorder:
                      //                                 OutlineInputBorder(
                      //                               borderSide: BorderSide(
                      //                                 color: AppThemes
                      //                                     .getSliderInactiveColor(),
                      //                                 width: 1,
                      //                               ),
                      //                               borderRadius: Dimensions
                      //                                   .kBorderRadius,
                      //                             ),
                      //
                      //                             focusedBorder:
                      //                                 OutlineInputBorder(
                      //                               borderRadius: Dimensions
                      //                                   .kBorderRadius,
                      //                               borderSide: BorderSide(
                      //                                   color: AppColors
                      //                                       .mainColor),
                      //                             ),
                      //                           ),
                      //                           style: context.t.bodyMedium,
                      //                         ),
                      //                         SizedBox(
                      //                           height: 16.h,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   if (dynamicField.type == "date")
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Text(
                      //                               dynamicField.fieldLevel,
                      //                               style:
                      //                                   context.t.displayMedium,
                      //                             ),
                      //                             dynamicField.validation ==
                      //                                     'required'
                      //                                 ? const SizedBox()
                      //                                 : Text(
                      //                                     " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                      //                                     style: context
                      //                                         .t.displayMedium,
                      //                                   ),
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 8.h,
                      //                         ),
                      //                         InkWell(
                      //                           onTap: () async {
                      //                             /// SHOW DATE PICKER
                      //                             await showDatePicker(
                      //                                     context: context,
                      //                                     builder:
                      //                                         (context, child) {
                      //                                       return Theme(
                      //                                           data: Theme.of(
                      //                                                   context)
                      //                                               .copyWith(
                      //                                             colorScheme:
                      //                                                 ColorScheme
                      //                                                     .dark(
                      //                                               surface:
                      //                                                   AppColors
                      //                                                       .bgColor,
                      //                                               onPrimary:
                      //                                                   AppColors
                      //                                                       .whiteColor,
                      //                                             ),
                      //                                             textButtonTheme:
                      //                                                 TextButtonThemeData(
                      //                                               style: TextButton
                      //                                                   .styleFrom(
                      //                                                 foregroundColor:
                      //                                                     AppColors
                      //                                                         .mainColor, // button text color
                      //                                               ),
                      //                                             ),
                      //                                           ),
                      //                                           child: child!);
                      //                                     },
                      //                                     initialDate:
                      //                                         DateTime.now(),
                      //                                     firstDate:
                      //                                         DateTime(1900),
                      //                                     lastDate:
                      //                                         DateTime(2025))
                      //                                 .then((value) {
                      //                               if (value != null) {
                      //                                 _
                      //                                     .textEditingControllerMap[
                      //                                         dynamicField
                      //                                             .fieldName]!
                      //                                     .text = DateFormat(
                      //                                         'yyyy-MM-dd')
                      //                                     .format(value);
                      //                               }
                      //                             });
                      //                           },
                      //                           child: IgnorePointer(
                      //                             ignoring: false,
                      //                             child: TextFormField(
                      //                               validator: (value) {
                      //                                 // Perform validation based on the 'validation' property
                      //                                 if (dynamicField
                      //                                             .validation ==
                      //                                         "required" &&
                      //                                     value!.isEmpty) {
                      //                                   return storedLanguage[
                      //                                           'Field is required'] ??
                      //                                       "Field is required";
                      //                                 }
                      //                                 return null;
                      //                               },
                      //                               controller:
                      //                                   _.textEditingControllerMap[
                      //                                       dynamicField
                      //                                           .fieldName],
                      //                               decoration: InputDecoration(
                      //                                 contentPadding:
                      //                                     const EdgeInsets
                      //                                         .symmetric(
                      //                                         vertical: 0,
                      //                                         horizontal: 16),
                      //                                 filled:
                      //                                     false, // Fill the background with color
                      //                                 hintStyle: TextStyle(
                      //                                   color: AppColors
                      //                                       .textFieldHintColor,
                      //                                 ),
                      //                                 fillColor: Colors
                      //                                     .transparent, // Background color
                      //                                 enabledBorder:
                      //                                     OutlineInputBorder(
                      //                                   borderSide: BorderSide(
                      //                                     color: AppThemes
                      //                                         .getSliderInactiveColor(),
                      //                                     width: 1,
                      //                                   ),
                      //                                   borderRadius: Dimensions
                      //                                       .kBorderRadius,
                      //                                 ),
                      //                                 hintText: dynamicField
                      //                                     .placeholder,
                      //                                 focusedBorder:
                      //                                     OutlineInputBorder(
                      //                                   borderRadius: Dimensions
                      //                                       .kBorderRadius,
                      //                                   borderSide: BorderSide(
                      //                                       color: AppColors
                      //                                           .mainColor),
                      //                                 ),
                      //                               ),
                      //                               style: context.t.bodyMedium,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 16.h,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   if (dynamicField.type == 'textarea')
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Row(
                      //                           children: [
                      //                             Text(
                      //                               dynamicField.fieldLevel,
                      //                               style:
                      //                                   context.t.displayMedium,
                      //                             ),
                      //                             dynamicField.validation ==
                      //                                     'required'
                      //                                 ? const SizedBox()
                      //                                 : Text(
                      //                                     " ${storedLanguage['(Optional)'] ?? "(Optional)"}",
                      //                                     style: context
                      //                                         .t.displayMedium,
                      //                                   ),
                      //                           ],
                      //                         ),
                      //                         SizedBox(
                      //                           height: 8.h,
                      //                         ),
                      //                         TextFormField(
                      //                           validator: (value) {
                      //                             if (dynamicField.validation ==
                      //                                     "required" &&
                      //                                 value!.isEmpty) {
                      //                               return storedLanguage[
                      //                                       'Field is required'] ??
                      //                                   "Field is required";
                      //                             }
                      //                             return null;
                      //                           },
                      //                           controller:
                      //                               _.textEditingControllerMap[
                      //                                   dynamicField.fieldName],
                      //                           maxLines: 7,
                      //                           minLines: 5,
                      //                           decoration: InputDecoration(
                      //                             hintText:
                      //                                 dynamicField.placeholder,
                      //                             contentPadding:
                      //                                 const EdgeInsets
                      //                                     .symmetric(
                      //                                     vertical: 8,
                      //                                     horizontal: 16),
                      //                             filled: false,
                      //                             hintStyle: TextStyle(
                      //                               color: AppColors
                      //                                   .textFieldHintColor,
                      //                             ),
                      //                             fillColor: Colors
                      //                                 .transparent, // Background color
                      //                             enabledBorder:
                      //                                 OutlineInputBorder(
                      //                               borderSide: BorderSide(
                      //                                 color: AppThemes
                      //                                     .getSliderInactiveColor(),
                      //                                 width: 1,
                      //                               ),
                      //                               borderRadius: Dimensions
                      //                                   .kBorderRadius,
                      //                             ),
                      //                             focusedBorder:
                      //                                 OutlineInputBorder(
                      //                               borderRadius: Dimensions
                      //                                   .kBorderRadius,
                      //                               borderSide: BorderSide(
                      //                                   color: AppColors
                      //                                       .mainColor),
                      //                             ),
                      //                           ),
                      //                           style: context.t.bodyMedium,
                      //                         ),
                      //                         SizedBox(
                      //                           height: 16.h,
                      //                         ),
                      //                       ],
                      //                     ),
                      //                 ],
                      //               );
                      //             },
                      //           ),
                      //         ],
                      //         SizedBox(
                      //           height: 30.h,
                      //         ),

                      //
                      //
                      //       ],
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
