import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final void Function()? onTapPrefixIcon;
  final void Function()? onTap;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffixWidget;
  final int? maxLine;
  final TextInputType? keyboardType;
  final bool? enabled;
  final bool readOnly;

  const CustomTextFormFieldWidget({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.onTapPrefixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.suffixWidget,
    this.maxLine = 1,
    this.keyboardType,
    this.enabled, this.readOnly =false, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return TextFormField(
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLine,
      enabled: enabled,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
        ),
        prefixIcon: prefixIcon != null
            ? GestureDetector(
                onTap: onTapPrefixIcon,
                child: Icon(
                  prefixIcon,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              )
            : null,
        suffixIcon: suffixWidget,
        filled: true,
        fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
