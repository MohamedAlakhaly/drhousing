import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/modules/auth/success_send_email/controller/success_send_email_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SuccessSendEmailView extends StatelessWidget {
  const SuccessSendEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(SuccessSendEmailControllerImp());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // ── Animated checkmark ─────────────────────────────────────────
              Center(
                child: GlowContainer(
                  width: 110,
                  height: 110,
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  glowColor: AppColors.primary.withValues(alpha: 0.50),
                  blurRadius: 40,
                  spreadRadius: 4,
                  child: const Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 54,
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 1.0),
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms)
                    .then(delay: 300.ms)
                    .shimmer(
                      duration: 1200.ms,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
              ),

              const SizedBox(height: 40),

              // ── Headline ───────────────────────────────────────────────────
              Text(
                'success_send_email_title'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 500.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOut),

              const SizedBox(height: 10),

              Text(
                'success_send_email_description'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.6,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 450.ms),

              const SizedBox(height: 52),

              // ── Open Email button ───────────────────────────────────────────
              AuthButton(
                text: 'open_email_button'.tr,
                isPrimary: true,
                leadingIcon: const Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.black,
                  size: 18,
                ),
                onTap: HelperFunctions().openUserMailApp,
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              const SizedBox(height: 14),

              // ── Back to Sign In ────────────────────────────────────────────
              AuthButton(
                text: 'back_to_sign_in'.tr,
                isPrimary: false,
                isOutlined: true,
                onTap: ctrl.goToSignIn,
              ).animate().fadeIn(delay: 560.ms, duration: 400.ms),

              const SizedBox(height: 36),

              // ── Spam notice ─────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.info_circle, color: AppColors.primary, size: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'spam_message'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 650.ms, duration: 400.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
