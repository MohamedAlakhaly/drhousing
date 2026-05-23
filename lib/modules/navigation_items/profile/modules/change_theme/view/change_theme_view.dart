import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/constant/app_text_style.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/custom_appbar.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/change_theme/controller/change_theme_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class ChangeThemeView extends StatelessWidget {
  const ChangeThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ChangeThemeControllerImp controller = Get.put(ChangeThemeControllerImp());
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: const CustomAppBar(title: ''),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity, height: 50),

              // ── Rive Animation ────────────────────────────────────────────
              GetBuilder<ChangeThemeControllerImp>(
                builder: (ctrl) {
                  return SizedBox(
                    height: 300,
                    width: 300,
                    child: RiveAnimation.asset(
                      AppImages.switchTheme,
                      controllers: [ctrl.switchTheme!],
                    ),
                  );
                },
              )
                  .animate()
                  .fade(duration: 800.ms)
                  .scale(
                    delay: 200.ms,
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 40),

              // ── Title & Description ───────────────────────────────────────
              Column(
                children: [
                  Text(
                    'changeAppThemeTitle'.tr,
                    style: AppTextStyle.titleStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'changeAppThemeDescription'.tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.contentStyle.copyWith(wordSpacing: 3),
                  ),
                ],
              ).animate().slideY(begin: 0.3, end: 0, duration: 500.ms).fade(),

              const SizedBox(height: 40),

              // ── Theme Buttons ─────────────────────────────────────────────
              GetBuilder<ChangeThemeControllerImp>(
                builder: (ctrl) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildThemeButton(
                          label: 'darkButton'.tr,
                          isSelected: ctrl.themeMode == 'dark',
                          onTap: ctrl.changeToDarkMode,
                          isDarkMode: isDarkMode,
                          context: context,
                        ),
                        _buildThemeButton(
                          label: 'lightButton'.tr,
                          isSelected: ctrl.themeMode == 'light',
                          onTap: ctrl.changeToLightMode,
                          isDarkMode: isDarkMode,
                          context: context,
                        ),
                        _buildThemeButton(
                          label: 'systemButton'.tr,
                          isSelected: ctrl.themeMode == 'system',
                          onTap: ctrl.changeToSystemMode,
                          isDarkMode: isDarkMode,
                          icon: Icons.phone_android_rounded,
                          context: context,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
    required BuildContext context,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.ease,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? HelperFunctions.getPrimary(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HelperFunctions.getPrimary(context).withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected
                    ? Colors.black
                    : (isDarkMode ? Colors.white : Colors.black54),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : (isDarkMode ? Colors.white : Colors.black54),
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ).animate().shimmer(
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.2),
        );
  }
}