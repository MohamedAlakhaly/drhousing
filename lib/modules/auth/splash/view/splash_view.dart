import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/modules/auth/splash/controller/splash_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashControllerImp());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Ambient lime glow — top
            Positioned(
              top: -120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        HelperFunctions.getPrimary(context).withValues(alpha: 0.10),
                        HelperFunctions.getPrimary(context).withValues(alpha: 0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Glowing logo container
                  GlowContainer(
                    width: 100,
                    height: 100,
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(28),
                    glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.50),
                    blurRadius: 40,
                    spreadRadius: 4,
                    child:  Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          AppImages.logo,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 28),

                  // Brand name
                  const Text(
                    'Dr Housing',
                    style: TextStyle(
                      
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 6,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.2, curve: Curves.easeOut),

                  const SizedBox(height: 8),

                  // Tagline
                   Text(
                    'find_your_home_slogan'.tr,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms),
                ],
              ),
            ),

            // Bottom pulsing dot indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration:  BoxDecoration(
                    color: HelperFunctions.getPrimary(context),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(0.6, 0.6),
                      end: const Offset(1.4, 1.4),
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.4, 1.4),
                      end: const Offset(0.6, 0.6),
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    )
                    .animate()
                    .fadeIn(delay: 800.ms),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
