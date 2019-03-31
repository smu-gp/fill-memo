import 'package:flutter/material.dart';
import 'package:sp_client/util/color.dart';

class AppThemes {
  static final ThemeData defaultTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    primaryColorLight: AppColors.primaryColorLight,
    primaryColorDark: AppColors.primaryColorDark,
    accentColor: AppColors.accentColor,
    backgroundColor: AppColors.backgroundColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    dialogBackgroundColor: AppColors.backgroundColor,
    bottomAppBarColor: AppColors.primaryColorDark,
    // For BottomNavigationBar background color
    canvasColor: AppColors.primaryColorDark,
    toggleableActiveColor: AppColors.accentColor,
    textSelectionHandleColor: AppColors.accentColor,
  );

  AppThemes._();
}
