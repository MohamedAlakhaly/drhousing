import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/functions/social_method.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/modules/auth/choose_auth_method/controller/choose_auth_method_controller.getx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class ChooseAuthMethodView extends StatelessWidget {
  const ChooseAuthMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ChooseAuthMethodControllerImp());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 52),

              // ── Logo ──────────────────────────────────────────────────────
              GlowContainer(
                    width: 130,
                    height: 130,
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(22),
                    glowColor: HelperFunctions.getPrimary(
                      context,
                    ).withValues(alpha: 0.40),
                    blurRadius: 30,
                    spreadRadius: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        AppImages.logo,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.6, 0.6),
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 500.ms),

              const SizedBox(height: 32),

              // ── Headline ─────────────────────────────────────────────────
              Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'welcome_in_app_title'.tr,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        TextSpan(
                          text: 'Dr Housing',
                          style: GoogleFonts.cormorantGaramond(
                            color: const Color(0xffD4AF37),
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 500.ms)
                  .slideY(begin: 0.15, curve: Curves.easeOut),

              // GlowContainer(
              //       width: 80,
              //       height: 80,
              //       color: AppColors.primaryBg,
              //       borderRadius: BorderRadius.circular(22),
              //       glowColor: AppColors.primary.withValues(alpha: 0.40),
              //       blurRadius: 30,
              //       spreadRadius: 2,
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(22),
              //         child: Image.asset(
              //           AppImages.logo,
              //           width: 42,
              //           height: 42,
              //         ),
              //       ),
              //     )
              //     .animate()
              //     .scale(
              //       begin: const Offset(0.6, 0.6),
              //       duration: 700.ms,
              //       curve: Curves.elasticOut,
              //     )
              //     .fadeIn(duration: 500.ms),

              // const SizedBox(height: 32),

              // // ── Headline ─────────────────────────────────────────────────
              // Text.rich(
              //       TextSpan(
              //         children: [
              //           TextSpan(
              //             text: 'welcome_in_app_title'.tr,
              //             style: TextStyle(
              //               color: AppColors.textPrimary,
              //               fontSize: 30,
              //               fontWeight: FontWeight.w800,
              //               letterSpacing: -0.5,
              //             ),
              //           ),
              //           const TextSpan(
              //             text: 'Dr Housing',
              //             style: TextStyle(
              //               color: AppColors.primary,
              //               fontSize: 30,
              //               fontWeight: FontWeight.w800,
              //               letterSpacing: -0.5,
              //             ),
              //           ),
              //         ],
              //       ),
              //       textAlign: TextAlign.center,
              //     )
              //     .animate()
              //     .fadeIn(delay: 200.ms, duration: 500.ms)
              //     .slideY(begin: 0.15, curve: Curves.easeOut),

              // const SizedBox(height: 8),

              // Text(
              //   'welcome_in_app_content'.tr,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: AppColors.textMuted,
              //     fontSize: 14,
              //     height: 1.5,
              //   ),
              // ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 48),

              // ── Google Sign-In ────────────────────────────────────────────
              GestureDetector(
                    onTap: () => kIsWeb
                        ? GoogleAuthService.signInWithGoogleWeb()
                        : GoogleAuthService.signInWithGoogle(),
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
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 450.ms)
                  .slideY(begin: 0.1, curve: Curves.easeOut),

              const SizedBox(height: 16),

              // ── OR divider ───────────────────────────────────────────────
              Row(
                children: [
                  const Expanded(
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
                  const Expanded(
                    child: Divider(color: AppColors.divider, thickness: 1),
                  ),
                ],
              ).animate().fadeIn(delay: 480.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // ── Sign Up with Email ────────────────────────────────────────
              AuthButton(
                text: 'get_started_button'.tr,
                isPrimary: true,
                leadingIcon: const Icon(
                  Iconsax.sms,
                  color: Colors.black,
                  size: 18,
                ),
                onTap: ctrl.goToSignUp,
              ).animate().fadeIn(delay: 540.ms, duration: 400.ms),

              const SizedBox(height: 12),

              // ── Sign In with Email ────────────────────────────────────────
              AuthButton(
                text: 'already_have_an_account_button'.tr,
                isPrimary: false,
                isOutlined: true,
                onTap: ctrl.goToSignIn,
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              const SizedBox(height: 40),

              // ── Footer ───────────────────────────────────────────────────
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'choose_auth_method_footer'.tr,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => HelperFunctions().openUrl(
                          'https://drhousing-legal.vercel.app/terms',
                        ),
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
                        onTap: () => HelperFunctions().openUrl(
                          'https://drhousing-legal.vercel.app/privacy-policy',
                        ),
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
                ],
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
