import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/functions/input_validation.dart';
import 'package:apartment_rentals/core/functions/social_method.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/global/auth_text_field.dart';
import 'package:apartment_rentals/modules/auth/sign_up/controller/sign_up_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    final ctrl = Get.put(SignUpControllerImp());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: ctrl.globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── Back ─────────────────────────────────────────────────────
                GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.chooseAuthMethod),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.bgCard:Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:  Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDarkMode ? AppColors.textPrimary:Colors.black,
                      size: 18,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 36),

                // ── Person icon with glow ─────────────────────────────────────
                Center(
                  child:
                      GlowContainer(
                            width: 80,
                            height: 80,
                            color: AppColors.primaryBg,
                            borderRadius: BorderRadius.circular(22),
                            glowColor: HelperFunctions.getPrimary(context).withValues(
                              alpha: 0.40,
                            ),
                            blurRadius: 28,
                            spreadRadius: 2,
                            child: Center(
                              child: Icon(
                                Icons.person_add_rounded,
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

                // ── Headline ──────────────────────────────────────────────────
                Center(
                      child: Text(
                        'create_new_account_title'.tr,
                        style: TextStyle(
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
                    'create_new_account_content'.tr,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                const SizedBox(height: 36),

                // ── Full Name ─────────────────────────────────────────────────
                AuthTextField(
                      controller: ctrl.usernameController,
                      hint: 'full_name'.tr,
                      prefixIcon: Iconsax.user,
                      textInputAction: TextInputAction.next,
                      validator: (val) => inputValidation(50, 2, val!, 'name'),
                    )
                    .animate()
                    .fadeIn(delay: 280.ms, duration: 400.ms)
                    .slideX(begin: -0.08, curve: Curves.easeOut),

                const SizedBox(height: 14),

                // ── Email ─────────────────────────────────────────────────────
                AuthTextField(
                      controller: ctrl.emailController,
                      hint: 'email'.tr,
                      prefixIcon: Iconsax.sms,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (val) =>
                          inputValidation(100, 5, val!, 'email'),
                    )
                    .animate()
                    .fadeIn(delay: 330.ms, duration: 400.ms)
                    .slideX(begin: 0.08, curve: Curves.easeOut),

                const SizedBox(height: 14),

                // ── Password ──────────────────────────────────────────────────
                GetBuilder<SignUpControllerImp>(
                      builder: (c) => AuthTextField(
                        controller: c.passwordController,
                        hint: 'password'.tr,
                        prefixIcon: Iconsax.lock,
                        obscureText: c.obscureText,
                        onToggleVisibility: c.showPassword,
                        textInputAction: TextInputAction.done,
                        validator: (val) =>
                            inputValidation(50, 8, val!, 'password'),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 380.ms, duration: 400.ms)
                    .slideX(begin: -0.08, curve: Curves.easeOut),

                const SizedBox(height: 18),

                // ── Privacy checkbox ──────────────────────────────────────────
                GetBuilder<SignUpControllerImp>(
                  builder: (c) => Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          c.agreePrivate = !c.agreePrivate;
                          c.update();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: c.agreePrivate
                                ? HelperFunctions.getPrimary(context)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: c.agreePrivate
                                  ? HelperFunctions.getPrimary(context)
                                  : AppColors.textDim,
                              width: 1.5,
                            ),
                          ),
                          child: c.agreePrivate
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.black,
                                  size: 14,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'agree_privacy'.tr,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: ()=>HelperFunctions().openUrl('https://drhousing-legal.vercel.app/terms'),
                              child: Text(
                                'terms_of_service'.tr,
                                style: TextStyle(
                                  color: HelperFunctions.getPrimary(context),
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'and'.tr,
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: ()=>HelperFunctions().openUrl('https://drhousing-legal.vercel.app/privacy-policy'),
                              child: Text(
                                'privacy_policy'.tr,
                                style: TextStyle(
                                  color: HelperFunctions.getPrimary(context),
                                  fontSize: 13,
                                  height: 1.4,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 430.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── Create Account button ─────────────────────────────────────
                GetBuilder<SignUpControllerImp>(
                  builder: (c) => Opacity(
                    opacity: c.agreePrivate ? 1.0 : 0.5,
                    child: AuthButton(
                      text: 'create_account_button'.tr,
                      isLoading: c.isLoading,
                      onTap: c.agreePrivate ? c.signUp : null,
                    ),
                  ),
                ).animate().fadeIn(delay: 470.ms, duration: 400.ms),

                const SizedBox(height: 24),

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
                ).animate().fadeIn(delay: 520.ms, duration: 400.ms),

                const SizedBox(height: 16),

                // ── Google button ─────────────────────────────────────────────
                GestureDetector(
                  onTap: () => GoogleAuthService.signInWithGoogle(),
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
                ).animate().fadeIn(delay: 560.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // ── Sign in link ──────────────────────────────────────────────
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        'have_account'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: ctrl.goToSignIn,
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
                ).animate().fadeIn(delay: 620.ms, duration: 400.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
