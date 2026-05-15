import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomChooseLanguageButton extends StatelessWidget {
  final String language;
  final String flag;
  final void Function()? onTap;
  final Color borderColor;
  final Color bgColor;
  final List<BoxShadow>? boxShadow;
  const CustomChooseLanguageButton({
    super.key,
    required this.language,
    required this.flag,
    required this.borderColor,
    this.onTap,
    required this.bgColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              flag,
              height: 35,
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.center,
                language,
                style:  TextStyle(
                  fontSize: AppFontsSize.mediumFontSize,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
