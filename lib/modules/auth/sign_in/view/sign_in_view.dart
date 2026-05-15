import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/functions/input_validation.dart';
import 'package:apartment_rentals/core/functions/social_method.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/global/auth_text_field.dart';
import 'package:apartment_rentals/modules/auth/sign_in/controller/sign_in_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignInView extends GetView<SignInControllerImp> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SignInControllerImp());

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
                  onTap: () => Get.offAllNamed(AppRoutes.chooseAuthMethod),
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

                // ── Lock icon with glow ──────────────────────────────────────
                Center(
                  child:
                      GlowContainer(
                            width: 80,
                            height: 80,
                            color: AppColors.primaryBg,
                            borderRadius: BorderRadius.circular(22),
                            glowColor: AppColors.primary.withValues(
                              alpha: 0.40,
                            ),
                            blurRadius: 28,
                            spreadRadius: 2,
                            child: const Center(
                              child: Icon(
                                Icons.lock_rounded,
                                color: AppColors.primary,
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
                        'welcome_back_in_app_title'.tr,
                        style: TextStyle(
                          color: AppColors.textPrimary,
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
                    'welcome_back_in_app_content'.tr,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 36),

                // ── Email ────────────────────────────────────────────────────
                AuthTextField(
                      controller: controller.emailController,
                      hint: 'email'.tr,
                      prefixIcon: Iconsax.sms,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (val) =>
                          inputValidation(100, 5, val!, 'email'),
                    )
                    .animate()
                    .fadeIn(delay: 280.ms, duration: 400.ms)
                    .slideX(begin: -0.08, curve: Curves.easeOut),

                const SizedBox(height: 14),

                // ── Password ─────────────────────────────────────────────────
                GetBuilder<SignInControllerImp>(
                      builder: (ctrl) => AuthTextField(
                        controller: ctrl.passwordController,
                        hint: 'password'.tr,
                        prefixIcon: Iconsax.lock,
                        obscureText: ctrl.obscureText,
                        onToggleVisibility: ctrl.showPassword,
                        textInputAction: TextInputAction.done,
                        validator: (val) =>
                            inputValidation(100, 7, val!, 'password'),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 340.ms, duration: 400.ms)
                    .slideX(begin: 0.08, curve: Curves.easeOut),

                const SizedBox(height: 12),

                // ── Forgot password link ──────────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: controller.goToForgetPassword,
                    child: Text(
                      'forgot_password'.tr,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 380.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── Sign In button ────────────────────────────────────────────
                GetBuilder<SignInControllerImp>(
                  builder: (ctrl) => AuthButton(
                    text: 'sign_in_button'.tr,
                    isLoading: ctrl.isLoading,
                    onTap: () => ctrl.signIn(),
                  ),
                ).animate().fadeIn(delay: 420.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── OR divider ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.divider, thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'or'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.divider, thickness: 1),
                    ),
                  ],
                ).animate().fadeIn(delay: 480.ms, duration: 400.ms),

                const SizedBox(height: 20),

                // ── Google button ─────────────────────────────────────────────
                GestureDetector(
                  onTap: () {
                    GoogleAuthService.signInWithGoogle();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppImages.google,
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'continue_with_google_button'.tr,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 540.ms, duration: 400.ms),

                const SizedBox(height: 32),

                // ── Sign up prompt ────────────────────────────────────────────
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'don\'t_have_an_account'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.goToSignUp,
                        child:  Text(
                          'sign_up_button'.tr,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
