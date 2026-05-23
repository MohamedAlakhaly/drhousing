import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/global/auth_text_field.dart';
import 'package:apartment_rentals/modules/auth/forget_password/controller/forget_password_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ForgetPasswordControllerImp());
    final isDarkMode = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Back button ────────────────────────────────────────────────
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:isDarkMode ? AppColors.bgCard:Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color:isDarkMode ? AppColors.textPrimary:Colors.black,
                    size: 18,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 48),

              // ── Email icon with glow ────────────────────────────────────────
              Center(
                child: GlowContainer(
                  width: 90,
                  height: 90,
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(26),
                  glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.45),
                  blurRadius: 32,
                  spreadRadius: 2,
                  child:  Center(
                    child: Icon(
                      Icons.lock_reset_rounded,
                      color: HelperFunctions.getPrimary(context),
                      size: 42,
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 750.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),
              ),

              const SizedBox(height: 36),

              // ── Heading ────────────────────────────────────────────────────
               Center(
                child: Text(
                  'forgot_password_title'.tr,
                  style: TextStyle(
                    
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 180.ms, duration: 450.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOut),

              const SizedBox(height: 10),

               Center(
                child: Text(
                  'forgot_password_description'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.55,
                  ),
                ),
              ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

              const SizedBox(height: 40),

              // ── Email field ────────────────────────────────────────────────
              AuthTextField(
                controller: ctrl.emailController,
                hint: 'email'.tr,
                prefixIcon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              )
                  .animate()
                  .fadeIn(delay: 320.ms, duration: 400.ms)
                  .slideX(begin: -0.08, curve: Curves.easeOut),

              const SizedBox(height: 28),

              // ── Reset button ───────────────────────────────────────────────
              Obx(
                () => AuthButton(
                  text: 'reset_password_button'.tr,
                  isLoading: ctrl.isLoading.value,
                  onTap: ctrl.sendEmail,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // ── Back to sign in ────────────────────────────────────────────
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      'remember_your_password'.tr,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.offAllNamed(AppRoutes.signIn),
                      child: Text(
                        'sign_in_button'.tr,
                        style: TextStyle(
                          color: HelperFunctions.getPrimary(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 480.ms, duration: 400.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
