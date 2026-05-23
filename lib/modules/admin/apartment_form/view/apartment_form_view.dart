import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/admin/apartment_form/controller/apartment_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ApartmentFormView extends StatelessWidget {
  final ApartmentModel? existing;
  const ApartmentFormView({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ApartmentFormController(existing: existing));
    final isDark = HelperFunctions.isDarkMode(context);
    final primary = HelperFunctions.getPrimary(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.bgCard
                            : AppColors.bgCardLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? AppColors.divider
                              : AppColors.borderLight,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDark
                            ? AppColors.textPrimary
                            : AppColors.textBlack,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    ctrl.isEditing
                        ? 'admin_edit_apartment'.tr
                        : 'admin_add_apartment'.tr,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            // ── Scrollable form ──────────────────────────────────────────────
            Expanded(
              child: Form(
                key: ctrl.formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // ── Title & description ───────────────────────────────────
                    _SectionHeader(
                      label: 'admin_content_section'.tr,
                      icon: Iconsax.text,
                    ),
                    GetBuilder<ApartmentFormController>(
                      builder: (c) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Language dropdown + completion indicators ────────
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.bgCard
                                      : AppColors.bgCardLight,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.divider
                                        : AppColors.borderLight,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: c.selectedLangIndex.value,
                                    dropdownColor: isDark
                                        ? AppColors.bgCard
                                        : AppColors.bgCardLight,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.textPrimary
                                          : AppColors.textBlack,
                                      fontSize: 13,
                                    ),
                                    items: List.generate(
                                      ApartmentFormController.langs.length,
                                      (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(
                                          ApartmentFormController
                                              .langLabels[ApartmentFormController
                                              .langs[i]]!,
                                        ),
                                      ),
                                    ),
                                    onChanged: (i) {
                                      if (i != null) {
                                        c.selectedLangIndex.value = i;
                                        c.update();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              ...ApartmentFormController.langs.map(
                                (lang) => Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: c.isTitleFilled(lang)
                                        ? AppColors.primaryBg
                                        : (isDark
                                              ? AppColors.bgSurface
                                              : AppColors.bgSurfaceLight),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: c.isTitleFilled(lang)
                                          ? primary.withValues(alpha: 0.5)
                                          : (isDark
                                                ? AppColors.divider
                                                : AppColors.borderLight),
                                    ),
                                  ),
                                  child: Text(
                                    lang.toUpperCase(),
                                    style: TextStyle(
                                      color: c.isTitleFilled(lang)
                                          ? primary
                                          : AppColors.textDim,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _FormField(
                            label: 'admin_title_label'.tr,
                            controller: c.titleCtrls[c.selectedLang]!,
                            hint: 'admin_title_hint'.tr,
                            isDark: isDark,
                            primary: primary,
                            textDirection: c.selectedLang == 'ar'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            validator: c.selectedLangIndex.value == 0
                                ? (v) => (v == null || v.trim().isEmpty)
                                      ? 'admin_title_required'.tr
                                      : null
                                : null,
                            onChanged: (_) => c.update(),
                          ),
                          const SizedBox(height: 12),
                          _FormField(
                            label: 'admin_description_label'.tr,
                            controller: c.descCtrls[c.selectedLang]!,
                            hint: 'admin_description_hint'.tr,
                            maxLines: 4,
                            isDark: isDark,
                            primary: primary,
                            textDirection: c.selectedLang == 'ar'
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            onChanged: (_) => c.update(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Basic info ────────────────────────────────────────────
                    _SectionHeader(
                      label: 'admin_basic_info_section'.tr,
                      icon: Iconsax.building,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'max_price'.tr,
                            controller: ctrl.priceCtrl,
                            hint: '800',
                            isDark: isDark,
                            primary: primary,
                            keyboardType: TextInputType.number,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'admin_price_required'.tr
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'bedrooms_label'.tr,
                            controller: ctrl.bedCountCtrl,
                            hint: '2',
                            isDark: isDark,
                            primary: primary,
                            keyboardType: TextInputType.number,
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'admin_beds_required'.tr
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _FormField(
                            label: 'sqm_label'.tr,
                            controller: ctrl.sqmCtrl,
                            hint: '65',
                            isDark: isDark,
                            primary: primary,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'floor_label'.tr,
                            controller: ctrl.floorCtrl,
                            hint: '3',
                            isDark: isDark,
                            primary: primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormField(
                      label: 'admin_address_label'.tr,
                      controller: ctrl.addressCtrl,
                      hint: 'admin_address_hint'.tr,
                      isDark: isDark,
                      primary: primary,
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'admin_address_required'.tr
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // ── Status ────────────────────────────────────────────────
                    Text(
                      'admin_status_label'.tr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        children: ['available', 'rented'].map((s) {
                          final selected = ctrl.status.value == s;
                          return GestureDetector(
                            onTap: () => ctrl.status.value = s,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? (s == 'available'
                                          ? AppColors.primaryBg
                                          : AppColors.dangerBg)
                                    : (isDark
                                          ? AppColors.bgCard
                                          : AppColors.bgCardLight),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: selected
                                      ? (s == 'available'
                                            ? primary
                                            : AppColors.dangerColor)
                                      : (isDark
                                            ? AppColors.divider
                                            : AppColors.borderLight),
                                ),
                              ),
                              child: Text(
                                'admin_status_$s'.tr,
                                style: TextStyle(
                                  color: selected
                                      ? (s == 'available'
                                            ? primary
                                            : AppColors.dangerColor)
                                      : AppColors.textMuted,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Images ────────────────────────────────────────────────
                    _SectionHeader(
                      label: 'admin_images_section'.tr,
                      icon: Iconsax.image,
                    ),
                    GetBuilder<ApartmentFormController>(
                      builder: (c) => Column(
                        children: [
                          ...List.generate(
                            c.imageCtrls.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _FormField(
                                      label:
                                          '${'admin_image_label'.tr} ${i + 1}',
                                      controller: c.imageCtrls[i],
                                      hint: 'https://...',
                                      isDark: isDark,
                                      primary: primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => c.removeImageField(i),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.dangerBg,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: AppColors.dangerColor
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.remove_rounded,
                                        color: AppColors.dangerColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: c.addImageField,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.bgCard
                                    : AppColors.bgCardLight,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_rounded,
                                    color: primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'admin_add_image'.tr,
                                    style: TextStyle(
                                      color: primary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Amenities ─────────────────────────────────────────────
                    _SectionHeader(
                      label: 'amenities_label'.tr,
                      icon: Iconsax.star,
                    ),
                    _AmenityToggle(
                      label: 'amenity_parking'.tr,
                      icon: Iconsax.car,
                      value: ctrl.hasParking,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _AmenityToggle(
                      label: 'amenity_laundry'.tr,
                      icon: Iconsax.drop,
                      value: ctrl.hasLaundry,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _AmenityToggle(
                      label: 'amenity_elevator'.tr,
                      icon: Iconsax.arrow_up_2,
                      value: ctrl.hasElevator,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _AmenityToggle(
                      label: 'amenity_pets'.tr,
                      icon: Iconsax.heart,
                      value: ctrl.hasPets,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _AmenityToggle(
                      label: 'amenity_balcony'.tr,
                      icon: Iconsax.home_2,
                      value: ctrl.hasBalcony,
                      isDark: isDark,
                      primary: primary,
                    ),
                    const SizedBox(height: 24),

                    // ── Rental terms ──────────────────────────────────────────
                    _SectionHeader(
                      label: 'rental_terms'.tr,
                      icon: Iconsax.document_text,
                    ),
                    _AmenityToggle(
                      label: 'housing_assistance'.tr,
                      icon: Iconsax.shield_tick,
                      value: ctrl.acceptsHousingAssistance,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _AmenityToggle(
                      label: 'cpas_guarantee'.tr,
                      icon: Iconsax.shield_tick,
                      value: ctrl.acceptsCpasOrOcmw,
                      isDark: isDark,
                      primary: primary,
                    ),
                    _AmenityToggle(
                      label: 'all_bills_included'.tr,
                      icon: Iconsax.electricity,
                      value: ctrl.isAllBillsIncluded,
                      isDark: isDark,
                      primary: primary,
                    ),
                    const SizedBox(height: 32),

                    // ── Save button ───────────────────────────────────────────
                    Obx(
                      () => GestureDetector(
                        onTap: ctrl.isLoading.value ? null : ctrl.save,
                        child: GlowContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          color: primary,
                          borderRadius: BorderRadius.circular(16),
                          glowColor: primary.withValues(alpha: 0.35),
                          spreadRadius: 2,
                          blurRadius: 20,
                          child: ctrl.isLoading.value
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
                                      ctrl.isEditing
                                          ? 'save_changes'.tr
                                          : 'admin_publish_apartment'.tr,
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
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final primary = HelperFunctions.getPrimary(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primary, size: 14),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.textPrimary : AppColors.textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Text field ─────────────────────────────────────────────────────────────────
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.isDark,
    required this.primary,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.textDirection,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final Color primary;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          textDirection: textDirection,
          onChanged: onChanged,
          style: TextStyle(
            color: isDark ? AppColors.textPrimary : AppColors.textBlack,
            fontSize: 14,
          ),
          cursorColor: primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textDim, fontSize: 13),
            filled: true,
            fillColor: isDark ? AppColors.bgCard : AppColors.bgCardLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.divider : AppColors.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.dangerColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.dangerColor,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Amenity toggle ─────────────────────────────────────────────────────────────
class _AmenityToggle extends StatelessWidget {
  const _AmenityToggle({
    required this.label,
    required this.icon,
    required this.value,
    required this.isDark,
    required this.primary,
  });
  final String label;
  final IconData icon;
  final RxBool value;
  final bool isDark;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => value.value = !value.value,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: value.value
                ? AppColors.primaryBg
                : (isDark ? AppColors.bgCard : AppColors.bgCardLight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: value.value
                  ? primary.withValues(alpha: 0.6)
                  : (isDark ? AppColors.divider : AppColors.borderLight),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: value.value ? primary : AppColors.textMuted,
                size: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: value.value
                        ? (isDark ? AppColors.primary : AppColors.primary)
                        : (isDark ? AppColors.textMuted : AppColors.textBlack),
                    fontSize: 14,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: value.value ? primary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: value.value ? primary : AppColors.textDim,
                    width: 1.5,
                  ),
                ),
                child: value.value
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 13,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
