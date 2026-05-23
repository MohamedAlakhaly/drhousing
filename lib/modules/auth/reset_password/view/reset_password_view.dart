import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/global/auth_text_field.dart';
import 'package:apartment_rentals/modules/auth/reset_password/controller/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResetPasswordView extends GetView<ResetPasswordControllerImp> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetPasswordControllerImp());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Back button ──────────────────────────────────────────────
                GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.signIn),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: 18,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 36),

                // ── Shield icon with glow ────────────────────────────────────
                Center(
                  child: GlowContainer(
                    width: 80,
                    height: 80,
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(22),
                    glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.40),
                    blurRadius: 28,
                    spreadRadius: 2,
                    child:  Center(
                      child: Icon(
                        Icons.shield_rounded,
                        color: HelperFunctions.getPrimary(context),
                        size: 36,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.6, 0.6),
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),
                ),

                const SizedBox(height: 28),

                // ── Headline ─────────────────────────────────────────────────
                Center(
                  child: Text(
                    'reset_password_new_title'.tr,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 450.ms)
                    .slideY(begin: 0.15, curve: Curves.easeOut),

                const SizedBox(height: 6),

                Center(
                  child: Text(
                    'reset_password_new_content'.tr,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 36),

                // ── Password ─────────────────────────────────────────────────
                GetBuilder<ResetPasswordControllerImp>(
                  builder: (ctrl) => AuthTextField(
                    controller: ctrl.passwordController,
                    hint: 'reset_password_new_hint'.tr,
                    prefixIcon: Iconsax.lock,
                    obscureText: ctrl.obscureText,
                    onToggleVisibility: ctrl.showPassword,
                    textInputAction: TextInputAction.next,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'pleaseEnterPassword'.tr;
                      }
                      if (val.length < 8) {
                        return 'passwordTooShort'.tr;
                      }
                      return null;
                    },
                  ),
                )
                    .animate()
                    .fadeIn(delay: 280.ms, duration: 400.ms)
                    .slideX(begin: -0.08, curve: Curves.easeOut),

                const SizedBox(height: 14),

                // ── Confirm Password ─────────────────────────────────────────
                GetBuilder<ResetPasswordControllerImp>(
                  builder: (ctrl) => AuthTextField(
                    controller: ctrl.confirmPasswordController,
                    hint: 'reset_password_confirm_hint'.tr,
                    prefixIcon: Iconsax.lock_1,
                    obscureText: ctrl.obscureConfirmText,
                    onToggleVisibility: ctrl.showConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'pleaseConfirmPassword'.tr;
                      }
                      if (val != ctrl.passwordController.text) {
                        return 'passwordsDoNotMatch'.tr;
                      }
                      return null;
                    },
                  ),
                )
                    .animate()
                    .fadeIn(delay: 340.ms, duration: 400.ms)
                    .slideX(begin: 0.08, curve: Curves.easeOut),

                const SizedBox(height: 32),

                // ── Submit button ─────────────────────────────────────────────
                Obx(
                  () => AuthButton(
                    text: 'reset_password_button'.tr,
                    isLoading: controller.isLoading.value,
                    onTap: controller.resetPassword,
                  ),
                ).animate().fadeIn(delay: 420.ms, duration: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}