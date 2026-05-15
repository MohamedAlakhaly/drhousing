import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomNormalButton extends StatelessWidget {
  final Color? buttonColor;
  final Color? textColor;
  final String buttonText;
  final void Function()? onTap;
  const CustomNormalButton({
    super.key,
    this.buttonColor = AppColors.primary,
    this.textColor = Colors.white,
    required this.buttonText,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: buttonColor,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: AppFontsSize.smallFontSize,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
