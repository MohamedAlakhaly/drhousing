import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle titleStyle = const TextStyle(
      fontSize: AppFontsSize.extraLargeFontSize, fontWeight: FontWeight.w800);

  static TextStyle contentStyle = TextStyle(
      fontSize: AppFontsSize.extraSmallFontSize, color: AppColors.textMuted);
}
