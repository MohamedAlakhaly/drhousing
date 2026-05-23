import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/data/on_boarding_data.dart';
import 'package:apartment_rentals/modules/auth/on_boarding/controller/on_boarding_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnBoardingControllerImp>(
      init: OnBoardingControllerImp(),
      builder: (ctrl) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // ── Top row: counter + skip ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${ctrl.currentPage + 1}/${onBoardingData.length}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: ctrl.skipButton,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: ctrl.currentPage < onBoardingData.length - 1
                            ? 1.0
                            : 0.0,
                        child: Text(
                          'skip_button'.tr,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── PageView ────────────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: ctrl.pageController,
                  itemCount: onBoardingData.length,
                  onPageChanged: (i) {
                    ctrl.currentPage = i;
                    ctrl.addPercent();
                  },
                  itemBuilder: (context, i) =>
                      _SlidePage(slide: onBoardingData[i]),
                ),
              ),

              // ── Bottom controls ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                child: Column(
                  children: [
                    // Dot indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onBoardingData.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: ctrl.currentPage == i ? 24 : 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: ctrl.currentPage == i
                                ? HelperFunctions.getPrimary(context)
                                : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Next / Get Started button
                    GestureDetector(
                      onTap: ctrl.jumpToNextSlide,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: HelperFunctions.getPrimary(context),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: HelperFunctions.getPrimary(context).withValues(alpha: 0.35),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            ctrl.currentPage == onBoardingData.length - 1
                                ? 'get_started_button'.tr
                                : 'next_button'.tr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single slide page ────────────────────────────────────────────────────────

class _SlidePage extends StatelessWidget {
  final dynamic slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color:isDarkMode? AppColors.bgCard:Colors.grey[300],
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.divider),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft lime glow
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        HelperFunctions.getPrimary(context).withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // SVG image
                SvgPicture.asset(
                  slide.imagePath,
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.92, 0.92), curve: Curves.easeOut),

          const SizedBox(height: 40),

          // Title
          Text(
            slide.title.toString().tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.15,
              letterSpacing: -0.5,
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 450.ms)
              .slideY(begin: 0.15, curve: Curves.easeOut),

          const SizedBox(height: 14),

          // Subtitle
          Text(
            slide.content.toString().tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
