import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/modules/auth/verify_email/controller/verify_email_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(
      VerifyEmailControllerImp(email: Get.arguments as String? ?? ''),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // ── Email icon ─────────────────────────────────────────────────
              Center(
                child:
                    GlowContainer(
                          width: 96,
                          height: 96,
                          color: AppColors.primaryBg,
                          borderRadius: BorderRadius.circular(28),
                          glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.45),
                          blurRadius: 36,
                          spreadRadius: 3,
                          child:  Center(
                            child: Icon(
                              Icons.mark_email_read_rounded,
                              color: HelperFunctions.getPrimary(context),
                              size: 44,
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

              // ── Headline ───────────────────────────────────────────────────
              Text(
                    'verify_email_title'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 450.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOut),

              const SizedBox(height: 10),

              Text(
                'verify_email_content'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.6,
                ),
              ).animate().fadeIn(delay: 280.ms, duration: 400.ms),

              const SizedBox(height: 48),

              // ── Open Email button ──────────────────────────────────────────
              AuthButton(
                text: 'open_email_button'.tr,
                isPrimary: true,
                leadingIcon: const Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.black,
                  size: 18,
                ),
                onTap: HelperFunctions().openUserMailApp,
              ).animate().fadeIn(delay: 380.ms, duration: 400.ms),

              const SizedBox(height: 14),

              // ── Sign In button ─────────────────────────────────────────────
              AuthButton(
                text: 'back_to_sign_in'.tr,
                isPrimary: false,
                isOutlined: true,
                onTap: ctrl.goToSignIn,
              ).animate().fadeIn(delay: 440.ms, duration: 400.ms),

              const SizedBox(height: 28),

              // ── Resend button مع Cooldown ──────────────────────────────────
              Obx(() {
                final cooldown = ctrl.resendCooldown.value;
                final isResending = ctrl.isResending.value;

                return GestureDetector(
                  onTap: cooldown > 0 || isResending ? null : ctrl.reSendEmail,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: cooldown > 0
                          ? AppColors.bgCard
                          : AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: cooldown > 0
                            ? AppColors.divider
                            : HelperFunctions.getPrimary(context).withValues(alpha: 0.4),
                      ),
                    ),
                    child: isResending
                        ?  SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: HelperFunctions.getPrimary(context),
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            cooldown > 0
                                ? '${'resend_cooldown'.tr.replaceAll('{seconds}', '$cooldown')}'
                                : 'resend_button'.tr,
                            style: TextStyle(
                              color: cooldown > 0
                                  ? AppColors.textMuted
                                  : HelperFunctions.getPrimary(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // ── Spam notice ────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                     Icon(
                      Iconsax.info_circle,
                      color: HelperFunctions.getPrimary(context),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'spam_message'.tr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 580.ms, duration: 400.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
