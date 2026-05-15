import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';


class AppTheme {
  //? app light theme 
  static ThemeData lightMode = ThemeData.light().copyWith(
    //! scaffold color
    scaffoldBackgroundColor: AppColors.bgLight,

    //! brightness
     brightness: Brightness.light,

    //! appbar
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.bgLight
    )
  );

  //? app dark theme
  static ThemeData darkMode = ThemeData.dark().copyWith(
    //! scaffold color
    scaffoldBackgroundColor: AppColors.bgDark,
    //! brightness
     brightness: Brightness.dark,

    //! appbar
     appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.bgDark
    )
  );
}
