import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/option_translator.dart';
import 'package:apartment_rentals/global/custom_appbar.dart';
import 'package:apartment_rentals/modules/auth/complete_profile/controller/complete_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CompleteProfileView extends StatelessWidget {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CompleteProfileControllerImp());

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: CustomAppBar(title: 'Complete Your Profile'),
      body: GetBuilder<CompleteProfileControllerImp>(
        builder: (controller) => Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHeader(),
                const SizedBox(height: 24),
                _buildPersonalHeader(controller),
                const SizedBox(height: 16),
                _buildProfessionalStatus(controller),
                const SizedBox(height: 16),
                _buildFinancialSnapshot(controller),
                const SizedBox(height: 16),
                _buildSocialStatus(controller),
                const SizedBox(height: 36),
                _buildSaveButton(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Page header ────────────────────────────────────────────────────────────

  Widget _buildPageHeader() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about yourself',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: AppFontsSize.largeFontSize,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Help landlords find the perfect match for their property',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.1, end: 0, duration: 400.ms);
  }

  // ─── Section card wrapper ────────────────────────────────────────────────────

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    int delayMs = 0,
  }) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        )
        .animate()
        .fadeIn(
          duration: 500.ms,
          delay: Duration(milliseconds: delayMs),
        )
        .slideY(
          begin: 0.08,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: delayMs),
        );
  }

  // ─── Custom text field ───────────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 14, right: 10),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: AppColors.bgSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.dangerColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }

  // ─── Selection chip ──────────────────────────────────────────────────────────

  Widget _buildSelectChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBg : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
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

  // ─── Toggle yes/no chip ──────────────────────────────────────────────────────

  Widget _buildYesNoChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBg : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
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

  // ─── Counter button ──────────────────────────────────────────────────────────

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryBg : AppColors.bgSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary ? AppColors.primary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: isPrimary ? AppColors.primary : AppColors.textMuted,
          size: 18,
        ),
      ),
    );
  }

  // ─── Field label ─────────────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    );
  }

  // ─── Section 1 : Personal Header ─────────────────────────────────────────────

  Widget _buildPersonalHeader(CompleteProfileControllerImp controller) {
    return _buildSectionCard(
      title: 'Personal Info',
      icon: Iconsax.user,
      delayMs: 100,
      child: Column(
        children: [
          _buildTextField(
            controller: controller.nameController,
            hint: 'Full Name',
            icon: Iconsax.edit,
            textInputAction: TextInputAction.next,
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Name is required' : null,
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: controller.phoneController,
            hint: 'Phone Number (e.g. +32 466 12 34 56)',
            icon: Iconsax.call,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Phone number is required' : null,
          ),
        ],
      ),
    );
  }

  // ─── Section 2 : Professional Status ─────────────────────────────────────────

  Widget _buildProfessionalStatus(CompleteProfileControllerImp controller) {
    return _buildSectionCard(
      title: 'Professional Status',
      icon: Iconsax.briefcase,
      delayMs: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('employment_status_label'.tr),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.employmentOptions
                .map(
                  (option) => _buildSelectChip(
                    label: OptionTranslator.translateEmployment(option),
                    isSelected: controller.selectedEmploymentStatus == option,
                    onTap: () => controller.selectEmploymentStatus(option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 18),
          _buildFieldLabel('job_title_label'.tr),
          _buildTextField(
            controller: controller.jobTitleController,
            hint: 'e.g. Software Engineer',
            icon: Iconsax.personalcard,
          ),
        ],
      ),
    );
  }

  // ─── Section 3 : Financial Snapshot ──────────────────────────────────────────

  Widget _buildFinancialSnapshot(CompleteProfileControllerImp controller) {
    return _buildSectionCard(
      title: 'How much rent can you afford?',
      icon: Iconsax.wallet,
      delayMs: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Max Monthly Rent',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '\$${controller.monthlyIncome.toInt()}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.bgSurface,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.18),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              trackHeight: 4,
              trackShape: const RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              value: controller.monthlyIncome,
              min: 0,
              max: 20000,
              divisions: 200,
              onChanged: controller.setMonthlyIncome,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '\$0',
                  style: TextStyle(color: AppColors.textDim, fontSize: 11),
                ),
                Text(
                  '\$20,000',
                  style: TextStyle(color: AppColors.textDim, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section 4 : Social Status ────────────────────────────────────────────────

  Widget _buildSocialStatus(CompleteProfileControllerImp controller) {
    return _buildSectionCard(
      title: 'Household & Lifestyle',
      icon: Iconsax.people,
      delayMs: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('marital_status_label'.tr),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.maritalOptions
                .map(
                  (option) => _buildSelectChip(
                    label: OptionTranslator.translateMarital(option),
                    isSelected: controller.selectedMaritalStatus == option,
                    onTap: () => controller.selectMaritalStatus(option),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Iconsax.home,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Number of Occupants',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'How many people will live in the flat',
                      style: TextStyle(color: AppColors.textDim, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  _buildCounterButton(
                    icon: Icons.remove_rounded,
                    onTap: controller.decrementOccupants,
                    isPrimary: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      controller.occupantsCount.toString(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _buildCounterButton(
                    icon: Icons.add_rounded,
                    onTap: controller.incrementOccupants,
                    isPrimary: true,
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.divider, height: 28),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'LIFESTYLE',
              style: TextStyle(
                color: AppColors.textDim,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          _buildLifestyleRow(
            icon: Icons.pets_rounded,
            label: 'Pets',
            isYes: controller.hasPets == true,
            isNo: controller.hasPets == false,
            onYes: () => controller.setPets(true),
            onNo: () => controller.setPets(false),
          ),
        ],
      ),
    );
  }

  Widget _buildLifestyleRow({
    required IconData icon,
    required String label,
    required bool isYes,
    required bool isNo,
    required VoidCallback onYes,
    required VoidCallback onNo,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            _buildYesNoChip(label: 'pets_yes'.tr, isSelected: isYes, onTap: onYes),
            const SizedBox(width: 8),
            _buildYesNoChip(label: 'pets_no'.tr, isSelected: isNo, onTap: onNo),
          ],
        ),
      ],
    );
  }

  // ─── Save & Continue button ───────────────────────────────────────────────────

  Widget _buildSaveButton(CompleteProfileControllerImp controller) {
    return GestureDetector(
          onTap: controller.saveProfile,
          child: GlowContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            glowColor: AppColors.primary.withValues(alpha: 0.45),
            spreadRadius: 2,
            blurRadius: 24,
            child: controller.isLoading
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
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save & Continue',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontsSize.smallFontSize,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 700.ms)
        .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: 700.ms);
  }
}
