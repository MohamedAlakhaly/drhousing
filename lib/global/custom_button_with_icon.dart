import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButtonWithIcon extends StatelessWidget {
  final Color? buttonColor;
  final Color? iconColor;
  final Color? textColor;
  final String buttonText;
  final void Function()? onTap;
  final IconData? icon;
  const CustomButtonWithIcon({
    super.key,
    this.buttonColor = AppColors.primary,
    this.textColor = Colors.white,
    required this.buttonText,
    this.iconColor = Colors.white,
    this.onTap, this.icon=Icons.arrow_forward_rounded,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: TextStyle(
                fontSize: AppFontsSize.smallFontSize,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Icon(icon, color: iconColor)
          ],
        ),
      ),
    );
  }
}
