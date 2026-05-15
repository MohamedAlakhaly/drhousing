import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButtonWithShadow extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final Color buttonColor;
  final Color? textColor;
  final Widget? customChild;
  final bool? isCustomChild;
  final Color? borderColor;
  const CustomButtonWithShadow({
    super.key,
    this.onTap,
    required this.buttonText,
    required this.buttonColor,
    this.textColor = Colors.white,
    this.customChild,
    this.isCustomChild = false,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: buttonColor,
              offset: const Offset(0, 0),
              blurRadius: 10,
            ),
          ],
          border: Border.all(color: borderColor!, width: 0.5),
        ),
        child: isCustomChild == false
            ? Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: AppFontsSize.smallFontSize,
                ),
              )
            : customChild,
      ),
    );
  }
}
