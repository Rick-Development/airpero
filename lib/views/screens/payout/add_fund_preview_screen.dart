// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gamers_arena/config/dimensions.dart';
// import 'package:gamers_arena/themes/themes.dart';
// import 'package:gamers_arena/utils/app_constants.dart';
// import 'package:gamers_arena/views/widgets/app_button.dart';
// import 'package:gamers_arena/views/widgets/custom_appbar.dart';
// import 'package:gamers_arena/views/widgets/custom_textfield.dart';
// import 'package:gamers_arena/views/widgets/spacing.dart';
// import 'package:gamers_arena/views/widgets/text_theme_extension.dart';

// import '../../../config/app_colors.dart';
// import '../../../utils/services/localstorage/hive.dart';
// import '../../../utils/services/localstorage/keys.dart';

// class AddFundPreviewScreen extends StatefulWidget {
//   const AddFundPreviewScreen({super.key});

//   @override
//   State<AddFundPreviewScreen> createState() => _AddFundPreviewScreenState();
// }

// class _AddFundPreviewScreenState extends State<AddFundPreviewScreen> {
//   int selectedGatewayIndex = -1;
//   @override
//   Widget build(BuildContext context) {
//     var storedLanguage = HiveHelp.read(Keys.languageData) ?? {};
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: storedLanguage['Deposit Preview'] ?? 'Deposit Preview',
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: Dimensions.kDefaultPadding,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               VSpace(20.h),
//               Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                       storedLanguage['Bank Transfer'] ?? 'Bank Transfer',
//                       style: context.t.bodyMedium)),
//               VSpace(20.h),
//               Container(
//                 height: 244.h,
//                 width: double.maxFinite,
//                 padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//                 decoration: BoxDecoration(
//                   color: AppThemes.getFillColor(),
//                   borderRadius: BorderRadius.circular(9.r),
//                   border: Border.all(color: AppColors.mainColor, width: .2),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(storedLanguage['Amount'] ?? 'Amount',
//                             style: context.t.displayMedium
//                                 ?.copyWith(color: AppThemes.getBlack50Color())),
//                         Text(
//                           '\$40',
//                           style: context.t.displayMedium,
//                         )
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(storedLanguage['Charge'] ?? 'Charge',
//                             style: context.t.displayMedium
//                                 ?.copyWith(color: AppThemes.getBlack50Color())),
//                         Text(
//                           '\$0.5',
//                           style: context.t.displayMedium,
//                         )
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(storedLanguage['Payable'] ?? 'Payable',
//                             style: context.t.displayMedium
//                                 ?.copyWith(color: AppThemes.getBlack50Color())),
//                         Text(
//                           '\$40.5',
//                           style: context.t.displayMedium,
//                         )
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                             storedLanguage['Conversion Rate'] ??
//                                 'Conversion Rate',
//                             style: context.t.displayMedium
//                                 ?.copyWith(color: AppThemes.getBlack50Color())),
//                         Text(
//                           '1 USD = 78.32 INR',
//                           style: context.t.displayMedium,
//                         )
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('In INR',
//                             style: context.t.displayMedium
//                                 ?.copyWith(color: AppThemes.getBlack50Color())),
//                         Text(
//                           '3,955.16',
//                           style: context.t.displayMedium,
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               VSpace(24.h),
//               Text(
//                 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as  opposed to using \'Content here, content here\', making it look like readable English. Many desktop publishing packages and web page editors now use.',
//                 style: context.t.displayMedium
//                     ?.copyWith(color: AppThemes.getBlack50Color(), height: 1.7),
//               ),
//               VSpace(24.h),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(storedLanguage['Account Number'] ?? 'Account Number',
//                       style: context.t.bodyMedium),
//                   VSpace(12.h),
//                   CustomTextField(
//                       contentPadding: EdgeInsets.only(left: 20.w),
//                       hintext: storedLanguage['Enter Number'] ?? 'Enter Number',
//                       keyboardType: TextInputType.number,
//                       inputFormatters: <TextInputFormatter>[
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       controller: TextEditingController()),
//                   VSpace(24.h),
//                   Text(storedLanguage['Photo'] ?? 'Photo',
//                       style: context.t.bodyMedium),
//                   VSpace(10.h),
//                   Container(
//                     height: 100.h,
//                     width: 100.h,
//                     padding: EdgeInsets.all(20.h),
//                     decoration: BoxDecoration(
//                       color: AppThemes.getFillColor(),
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(color: AppColors.mainColor, width: .2),
//                     ),
//                     child: Image.asset(
//                       '$rootImageDir/photo.png',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   VSpace(40.h),
//                   Material(
//                     color: Colors.transparent,
//                     child: AppButton(
//                       onTap: () {},
//                       text: storedLanguage['Pay Now'] ?? 'Pay Now',
//                       borderRadius: BorderRadius.circular(32.r),
//                     ),
//                   ),
//                   VSpace(50.h),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
