import 'dart:ui';
import 'package:flutter/material.dart';

class CustomIconButtonWithBlurBackground extends StatelessWidget {
  final IconData buttonIcon;
  final void Function()? onTap;
  const CustomIconButtonWithBlurBackground({
    super.key,
    required this.buttonIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle),
            child: Icon(buttonIcon),
          ),
        ),
      ),
    );
  }
}
