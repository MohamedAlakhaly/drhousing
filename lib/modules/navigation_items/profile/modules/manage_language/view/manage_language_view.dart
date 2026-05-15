import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/manage_language/controller/manage_language_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ManageLanguageView extends StatelessWidget {
  const ManageLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ManageLanguageControllerImp());
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Padding(
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
                    color: isDarkMode
                        ? AppColors.bgCard
                        : AppColors.bgCardLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.divider
                          : AppColors.borderLight,
                    ),
                    boxShadow: isDarkMode
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: isDarkMode
                        ? AppColors.textPrimary
                        : AppColors.textBlack,
                    size: 18,
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 36),

              // ── Header ─────────────────────────────────────────────────────
              Text(
                    'manage_language_title'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 500.ms)
                  .slideY(begin: -0.15, curve: Curves.easeOut),

              const SizedBox(height: 8),

               Text(
                'manage_language_description'.tr,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ).animate().fadeIn(delay: 180.ms, duration: 400.ms),

              const SizedBox(height: 36),

              // ── Language cards ─────────────────────────────────────────────
              Expanded(
                child: GetBuilder<ManageLanguageControllerImp>(
                  builder: (c) => ListView.separated(
                    itemCount: c.languages.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final isSelected = c.currentLanguage == c.langCode[i];
                      return _LangCard(
                        name: c.languages[i],
                        flagPath: c.flags[i],
                        langCode: c.langCode[i],
                        isSelected: isSelected,
                        index: i,
                        onTap: () {
                          c.currentLanguage = c.langCode[i];
                          c.selectedLanguage = c.langCode[i];
                          c.update();
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Done button ────────────────────────────────────────────────
              GetBuilder<ManageLanguageControllerImp>(
                builder: (c) {
                  final canSave =
                      c.selectedLanguage.isNotEmpty &&
                      c.selectedLanguage != c.appLanguage;
                  return AuthButton(
                    text: 'done_button'.tr,
                    isPrimary: canSave,
                    isOutlined: !canSave,
                    onTap: canSave
                        ? () => c.changeLanguage(langCode: c.selectedLanguage)
                        : null,
                  );
                },
              ).animate().fadeIn(delay: 450.ms, duration: 400.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Language card ─────────────────────────────────────────────────────────────

 Map<String, String> get  _nativeNames => {
  'en': 'lang_en'.tr,
  'ar': 'lang_ar'.tr,
  'fr': 'lang_fr'.tr,
  'nl': 'lang_nl'.tr,
};

class _LangCard extends StatelessWidget {
  final String name;
  final String flagPath;
  final String langCode;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const _LangCard({
    required this.name,
    required this.flagPath,
    required this.langCode,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDarkMode
                        ? AppColors.primaryBg
                        : AppColors.primary.withValues(alpha: 0.08))
                  : (isDarkMode ? AppColors.bgCard : AppColors.bgCardLight),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDarkMode ? AppColors.divider : AppColors.borderLight),
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : Colors.black.withValues(alpha: 0.04),
                        blurRadius: isSelected ? 14 : 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Flag SVG in rounded container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.12)
                        : (isDarkMode
                              ? AppColors.bgSurface
                              : AppColors.bgSurfaceLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SvgPicture.asset(flagPath, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),

                // Language names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: isDarkMode
                              ? isSelected
                                    ? AppColors.primary
                                    : AppColors.textPrimary
                              : isSelected
                              ? AppColors.textBlack
                              : AppColors.textMuted,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        child: Text(name),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _nativeNames[langCode] ?? name,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Animated check circle
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedScale(
                    scale: isSelected ? 1.0 : 0.6,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 260 + index * 80),
          duration: 400.ms,
        )
        .slideX(begin: 0.08, curve: Curves.easeOut);
  }
}
