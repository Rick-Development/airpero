import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

CustomAppTheme appTheme = CustomAppTheme();

class CustomAppTheme extends ChangeNotifier {
  // static late bool _isDarkMode;

  // ThemeMode get currentTheme =>
  //     _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  ThemeMode get currentTheme => ThemeMode.light;
  // _isDarkMode ? ThemeMode.light : ThemeMode.light;

  // static initThemeState() {
  //   //get user prefared theme state
  //   // condition for setting the theme state
  //   // if(saved state == system)
  //   _isDarkMode =
  //       SchedulerBinding.instance.platformDispatcher.platformBrightness ==
  //           Brightness.dark;
  // }

  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
        primaryColor: AppColors.primaryColor,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          onSurfaceVariant: AppColors.blackColor,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 42,
            color: AppColors.whiteColor,
          ),
          displayLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 32,
            color: AppColors.blackColor,
          ),
          displayMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.blackColor,
          ),
          displaySmall: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.blackColor,
          ),
          titleLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: AppColors.blackColor,
          ),
          titleMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColors.blackColor,
          ),
          titleSmall: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.blackColor,
          ),
          bodyLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.blackColor,
          ),
          bodyMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.blackColor,
          ),
          bodySmall: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: AppColors.blackColor,
          ),
          labelLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.blackColor,
          ),
          labelMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.blackColor,
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      );

  static ThemeData get darkTheme => ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 9, 9, 9),
        primaryColor: AppColors.primaryColor,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 42,
            color: AppColors.whiteColor,
          ),
          displayLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 32,
            color: AppColors.whiteColor,
          ),
          displayMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.whiteColor,
          ),
          displaySmall: GoogleFonts.lato(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.whiteColor,
          ),
          titleLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: AppColors.whiteColor,
          ),
          titleMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: AppColors.whiteColor,
          ),
          titleSmall: GoogleFonts.lato(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.whiteColor,
          ),
          bodyLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.textGreyColor,
          ),
          bodyMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.textGreyColor,
          ),
          bodySmall: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: AppColors.textGreyColor,
          ),
          labelLarge: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.whiteColor,
          ),
          labelMedium: GoogleFonts.lato(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.whiteColor,
          ),
        ),
      );
}
