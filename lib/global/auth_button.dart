import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

/// A reusable premium auth button.
/// [isPrimary] = lime filled; [isOutlined] = dark outlined; [isGoogle] = dark card.
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isPrimary;
  final bool isOutlined;
  final Widget? leadingIcon;

  const AuthButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.isPrimary = true,
    this.isOutlined = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    final Widget content = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: isDarkMode
                  ? isPrimary
                        ? Colors.black
                        : AppColors.primary
                  : isPrimary
                  ? AppColors.primary
                  : Colors.black,
              strokeWidth: 2.5,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(
                  color: isDarkMode
                      ? isPrimary
                            ? Colors.black
                            : AppColors.textPrimary
                      : isPrimary
                      ? Colors.black
                      : Colors.grey.shade500,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          );

    if (isPrimary) {
      return GestureDetector(
        onTap: isLoading ? null : onTap,
        child: GlowContainer(
          width: double.infinity,
          height: 56,
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          glowColor: AppColors.primary.withValues(alpha: 0.38),
          blurRadius: 20,
          spreadRadius: 1,
          child: Center(child: content),
        ),
      );
    }

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode? isOutlined ? AppColors.divider : AppColors.bgSurface:
            isOutlined ? Colors.grey.shade300 : AppColors.bgSurface,
            width: 1.5,
          ),
        ),
        child: Center(child: content),
      ),
    );
  }
}
