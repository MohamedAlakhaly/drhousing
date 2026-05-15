import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/functions/option_translator.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/edit_personal_info/controller/edit_personal_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditPersonalInfoView extends StatelessWidget {
  const EditPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(EditPersonalInfoControllerImp());
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: GetBuilder<EditPersonalInfoControllerImp>(
          builder: (ctrl) => Form(
            key: ctrl.formKey,
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
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
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
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
                      const SizedBox(width: 16),
                      Text(
                        'edit_profile'.tr,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textPrimary
                              : AppColors.textBlack,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ).animate().fadeIn(delay: 80.ms, duration: 350.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ── Scrollable fields ────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Personal fields ──────────────────────────────
                        _FieldCard(
                          label: 'full_name'.tr,
                          hint: 'full_name_hint'.tr,
                          icon: Iconsax.user,
                          controller: ctrl.nameController,
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'name_required'.tr
                              : null,
                          delay: 200,
                        ),
                        const SizedBox(height: 14),
                        _FieldCard(
                          label: 'phone_number_label'.tr,
                          hint: 'phone_hint'.tr,
                          icon: Iconsax.call,
                          controller: ctrl.phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'phone_required'.tr;
                            } else if (v.length < 10) {
                              Get.snackbar(
                                'error_title'.tr,
                                'phone_format_warning'.tr,
                              );
                              return 'phone_min_length'.tr;
                            }
                            return null;
                          },
                          delay: 280,
                        ),

                        const SizedBox(height: 24),

                        // ── Professional section ──────────────────────────
                        _buildSectionCard(
                          context: context,
                          title: 'professional_status'.tr,
                          icon: Iconsax.briefcase,
                          delayMs: 360,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('employment_status_label'.tr, isDarkMode),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ctrl.employmentOptions
                                    .map(
                                      (opt) => _buildSelectChip(
                                        label: OptionTranslator.translateEmployment(opt),
                                        isSelected:
                                            ctrl.selectedEmploymentStatus
                                                    .value ==
                                                opt,
                                        onTap: () =>
                                            ctrl.selectEmploymentStatus(opt),
                                        isDarkMode: isDarkMode,
                                      ),
                                    )
                                    .toList(),
                              ),

                              // ── Job Title — animated show/hide ────────────
                              Obx(() {
                                final show = ctrl.showJobTitle;
                                return ClipRect(
                                  child: AnimatedSize(
                                    duration:
                                        const Duration(milliseconds: 320),
                                    curve: Curves.easeInOut,
                                    child: AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      opacity: show ? 1.0 : 0.0,
                                      child: show
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 18),
                                                _buildFieldLabel(
                                                    'job_title_label'.tr, isDarkMode),
                                                _FieldCard(
                                                  label: '',
                                                  hint: 'job_title_hint'.tr,
                                                  icon: Iconsax.personalcard,
                                                  controller:
                                                      ctrl.jobTitleController,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  validator: (v) =>
                                                      (v == null ||
                                                          v.trim().isEmpty)
                                                      ? 'job_title_required'.tr
                                                      : null,
                                                  delay: 0,
                                                ),
                                              ],
                                            )
                                          : const SizedBox(
                                              width: double.infinity,
                                            ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // ── Save button ──────────────────────────────────────────
                Padding(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        12,
                        20,
                        MediaQuery.of(context).padding.bottom + 20,
                      ),
                      child: GestureDetector(
                        onTap: ctrl.saveProfile,
                        child: GlowContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          glowColor:
                              AppColors.primary.withValues(alpha: 0.40),
                          spreadRadius: 2,
                          blurRadius: 22,
                          child: ctrl.isLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.check_rounded,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'save_changes'.tr,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 480.ms, duration: 400.ms)
                    .slideY(begin: 0.15, curve: Curves.easeOut),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    );
  }

  Widget _buildSelectChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? AppColors.primaryBg
                  : AppColors.primary.withValues(alpha: 0.10))
              : (isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDarkMode ? AppColors.divider : AppColors.borderLight),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget child,
    int delayMs = 0,
  }) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
            ),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.primaryBg
                          : AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 1,
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delayMs),
          duration: 450.ms,
        )
        .slideY(begin: 0.07, curve: Curves.easeOut);
  }
}

// ─── Field card ───────────────────────────────────────────────────────────────

class _FieldCard extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int delay;

  const _FieldCard({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.delay,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty) ...[
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? AppColors.textMuted : const Color(0xff666666),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
            ],
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              validator: validator,
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
                fontSize: 15,
              ),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 12),
                  child: Icon(icon, color: AppColors.primary, size: 18),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 0,
                  minHeight: 0,
                ),
                filled: true,
                fillColor: isDarkMode
                    ? AppColors.bgSurface
                    : AppColors.bgSurfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.dangerColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.dangerColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
        )
        .slideX(begin: 0.06, curve: Curves.easeOut);
  }
}
