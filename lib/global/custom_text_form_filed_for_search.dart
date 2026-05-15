import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextFormFiledForSearch extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;
  final void Function()? onTapClear;
  const CustomTextFormFiledForSearch({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged, this.onTapClear,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[300],
        suffixIcon: GestureDetector(
            onTap: onTapClear,
            child: Container(
              width: 105,
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: controller!.text.isEmpty
                      ? isDarkMode
                          ? AppColors.bgDark
                          : AppColors.bgLight
                      : isDarkMode
                          ? AppColors.bgLight
                          : AppColors.bgDark,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: [
                  Icon(Icons.clear,
                      color: controller!.text.isEmpty
                          ? isDarkMode
                              ? Colors.white
                              : Colors.black
                          : isDarkMode
                              ? Colors.black
                              : Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Clear',
                    style: TextStyle(
                        color: controller!.text.isEmpty
                            ? isDarkMode
                                ? Colors.white
                                : Colors.black
                            : isDarkMode
                                ? Colors.black
                                : Colors.white),
                  )
                ],
              ),
            )),
        hint: Text(hintText),
        prefixIcon: Icon(Iconsax.search_normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
              color: isDarkMode ? Colors.grey.shade700 : Colors.black),
        ),
      ),
    );
  }
}
