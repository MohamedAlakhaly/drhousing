import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundColorWidget extends StatelessWidget {
  const BackgroundColorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors. bgDark, AppColors.bgCard.withValues(alpha: 0.8), AppColors.bgDark],
            ),
          ),
        ),

        // Top right primary glow
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom left primary glow
        Positioned(
          bottom: -50,
          left: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.primary.withValues(alpha: 0.1), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

}