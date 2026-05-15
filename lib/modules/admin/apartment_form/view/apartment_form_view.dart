import 'package:apartment_rentals/core/constant/app_colors.dart';
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

    return Scaffold(
      backgroundColor: AppColors.bgDark,
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
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // isEditing ثابت — بدون Obx
                  Text(
                    ctrl.isEditing
                        ? 'admin_edit_apartment'.tr
                        : 'admin_add_apartment'.tr,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
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
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.divider),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: c.selectedLangIndex.value,
                                    dropdownColor: AppColors.bgCard,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13),
                                    items: List.generate(
                                      ApartmentFormController.langs.length,
                                      (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(
                                          ApartmentFormController.langLabels[
                                              ApartmentFormController.langs[i]]!,
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
                              ...ApartmentFormController.langs.map((lang) =>
                                Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: c.isTitleFilled(lang)
                                        ? AppColors.primaryBg
                                        : AppColors.bgSurface,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: c.isTitleFilled(lang)
                                          ? AppColors.primary.withValues(alpha: 0.5)
                                          : AppColors.divider,
                                    ),
                                  ),
                                  child: Text(
                                    lang.toUpperCase(),
                                    style: TextStyle(
                                      color: c.isTitleFilled(lang)
                                          ? AppColors.primary
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
                          // ── Title & description for selected language ─────────
                          _FormField(
                            label: 'admin_title_label'.tr,
                            controller: c.titleCtrls[c.selectedLang]!,
                            hint: 'admin_title_hint'.tr,
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
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _FormField(
                            label: 'floor_label'.tr,
                            controller: ctrl.floorCtrl,
                            hint: '3',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormField(
                      label: 'admin_address_label'.tr,
                      controller: ctrl.addressCtrl,
                      hint: 'admin_address_hint'.tr,
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
                    Obx(() => Row(
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
                                  ? (s == 'available' ? AppColors.primaryBg : AppColors.dangerBg)
                                  : AppColors.bgCard,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected
                                    ? (s == 'available' ? AppColors.primary : AppColors.dangerColor)
                                    : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              'admin_status_$s'.tr,
                              style: TextStyle(
                                color: selected
                                    ? (s == 'available' ? AppColors.primary : AppColors.dangerColor)
                                    : AppColors.textMuted,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
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
                                      label: '${'admin_image_label'.tr} ${i + 1}',
                                      controller: c.imageCtrls[i],
                                      hint: 'https://...',
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
                                          color: AppColors.dangerColor.withValues(alpha: 0.3),
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
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'admin_add_image'.tr,
                                    style: const TextStyle(
                                      color: AppColors.primary,
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
                    _SectionHeader(label: 'amenities_label'.tr, icon: Iconsax.star),
                    _AmenityToggle(label: 'amenity_parking'.tr, icon: Iconsax.car, value: ctrl.hasParking),
                    _AmenityToggle(label: 'amenity_laundry'.tr, icon: Iconsax.drop, value: ctrl.hasLaundry),
                    _AmenityToggle(label: 'amenity_elevator'.tr, icon: Iconsax.arrow_up_2, value: ctrl.hasElevator),
                    _AmenityToggle(label: 'amenity_pets'.tr, icon: Iconsax.heart, value: ctrl.hasPets),
                    _AmenityToggle(label: 'amenity_balcony'.tr, icon: Iconsax.home_2, value: ctrl.hasBalcony),
                    const SizedBox(height: 24),

                    // ── Rental terms ──────────────────────────────────────────
                    _SectionHeader(label: 'rental_terms'.tr, icon: Iconsax.document_text),
                    _AmenityToggle(label: 'housing_assistance'.tr, icon: Iconsax.shield_tick, value: ctrl.acceptsHousingAssistance),
                    _AmenityToggle(label: 'cpas_guarantee'.tr, icon: Iconsax.shield_tick, value: ctrl.acceptsCpasOrOcmw),
                    _AmenityToggle(label: 'all_bills_included'.tr, icon: Iconsax.electricity, value: ctrl.isAllBillsIncluded),
                    const SizedBox(height: 32),

                    // ── Save button ───────────────────────────────────────────
                    Obx(() => GestureDetector(
                      onTap: ctrl.isLoading.value ? null : ctrl.save,
                      child: GlowContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        glowColor: AppColors.primary.withValues(alpha: 0.35),
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
                                  const Icon(Icons.check_rounded, color: Colors.black, size: 20),
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
                    )),
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
            child: Icon(icon, color: AppColors.primary, size: 14),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
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
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.textDirection,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
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
        Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          textDirection: textDirection,
          onChanged: onChanged,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textDim, fontSize: 13),
            filled: true,
            fillColor: AppColors.bgCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.dangerColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.dangerColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// ── Amenity toggle ─────────────────────────────────────────────────────────────
class _AmenityToggle extends StatelessWidget {
  const _AmenityToggle({required this.label, required this.icon, required this.value});
  final String label;
  final IconData icon;
  final RxBool value;

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => value.value = !value.value,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: value.value ? AppColors.primaryBg : AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value.value
                ? AppColors.primary.withValues(alpha: 0.6)
                : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: value.value ? AppColors.primary : AppColors.textMuted, size: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: value.value ? AppColors.textPrimary : AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value.value ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: value.value ? AppColors.primary : AppColors.textDim,
                  width: 1.5,
                ),
              ),
              child: value.value
                  ? const Icon(Icons.check_rounded, color: Colors.black, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    ));
  }
}