import 'package:flutter/material.dart';
import 'package:sp_client/util/color.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLightColor,
    primaryColorLight: AppColors.primaryLightColorLight,
    primaryColorDark: AppColors.primaryLightColorDark,
    accentColor: AppColors.accentColor,
    backgroundColor: AppColors.backgroundLightColor,
    scaffoldBackgroundColor: AppColors.backgroundLightColor,
    dialogBackgroundColor: AppColors.backgroundLightColor,
    bottomAppBarColor: AppColors.primaryLightColorLight,
    // For BottomNavigationBar background color
    canvasColor: AppColors.primaryLightColorLight,
    toggleableActiveColor: AppColors.accentColor,
    textSelectionHandleColor: AppColors.accentColor,
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    ),
    fontFamily: 'NotoSansKR',
  );

  static final ThemeData darkTheme = ThemeData(
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
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    ),
    fontFamily: 'NotoSansKR',
  );

  AppThemes._();
}
