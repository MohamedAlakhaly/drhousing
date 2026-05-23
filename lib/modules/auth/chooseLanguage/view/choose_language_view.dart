import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/localization/local_controller.getx.dart';
import 'package:apartment_rentals/global/auth_button.dart';
import 'package:apartment_rentals/modules/auth/chooseLanguage/controller/choose_language_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChooseLanguageView extends StatelessWidget {
  const ChooseLanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChooseLanguageControllerImp());
    final langController = Get.find<AppLocalController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // ── Header ──────────────────────────────────────────────────────
              Text(
                    'select_language_title'.tr,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: -0.5,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: -0.15, curve: Curves.easeOut),

              const SizedBox(height: 8),

              Text(
                'select_language_content'.tr,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 40),

              // ── Language Cards ───────────────────────────────────────────────
              Expanded(
                child: GetBuilder<ChooseLanguageControllerImp>(
                  builder: (ctrl) => ListView.separated(
                    itemCount: ctrl.options.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final opt = ctrl.options[i];
                      final isSelected = ctrl.currentLanguage == opt.code;
                      return _LangCard(
                        option: opt,
                        isSelected: isSelected,
                        index: i,
                        onTap: () {
                          ctrl.selectLang(opt.code);
                          langController.changeLocal(opt.code);
                        },
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Continue Button ──────────────────────────────────────────────
              GetBuilder<ChooseLanguageControllerImp>(
                builder: (ctrl) => AuthButton(
                  text: 'done_button'.tr,
                  isPrimary: ctrl.currentLanguage.isNotEmpty,
                  isOutlined: ctrl.currentLanguage.isEmpty,
                  onTap: ctrl.currentLanguage.isNotEmpty
                      ? ctrl.chooseLanguage
                      : null,
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Language card ─────────────────────────────────────────────────────────────

class _LangCard extends StatelessWidget {
  final LangOption option;
  final bool isSelected;
  final int index;
  final VoidCallback onTap;

  const _LangCard({
    required this.option,
    required this.isSelected,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? (isSelected ? AppColors.primaryBg : AppColors.bgCard)
                  : (isSelected ? Colors.grey[200] : Colors.grey[50]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected
                    ? HelperFunctions.getPrimary(context)
                    : AppColors.divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                // Flag emoji in a rounded container
                Container(
                  width: 48,
                  height: 48,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? (isSelected
                              ? HelperFunctions.getPrimary(
                                  context,
                                ).withValues(alpha: 0.15)
                              : AppColors.primaryBg)
                        : (isSelected
                              ? HelperFunctions.getPrimary(
                                  context,
                                ).withValues(alpha: 0.15)
                              : Colors.grey[300]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    option.flag,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 16),

                // Language names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.name,
                        style: TextStyle(
                          color: isDarkMode
                              ? (isSelected
                                    ? HelperFunctions.getPrimary(context)
                                    : AppColors.textPrimary)
                              : (isSelected
                                    ? HelperFunctions.getPrimary(context)
                                    : AppColors.textBlack),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.nativeName,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Check mark when selected
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: HelperFunctions.getPrimary(context),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 200 + index * 80),
          duration: 400.ms,
        )
        .slideX(begin: 0.1, curve: Curves.easeOut);
  }
}
