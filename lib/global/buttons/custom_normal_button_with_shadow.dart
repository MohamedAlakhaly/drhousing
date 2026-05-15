import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';

class CustomNormalButtonWithShadow extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  final bool isEnabled;
  final Color? shadowColor;

  const CustomNormalButtonWithShadow({
    super.key,
    required this.buttonText,
    this.onTap,
    this.isEnabled = true,
    this.shadowColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    final Color buttonColor = isEnabled
        ? shadowColor!
        : (isDarkMode ? Colors.grey[700]! : Colors.grey[400]!);

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [buttonColor, buttonColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isEnabled ? null : buttonColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: shadowColor!.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: isEnabled
                  ? Colors.white
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[700]),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
