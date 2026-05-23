import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/functions/option_translator.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showFilterBottomSheet(BuildContext context) {
  final ApartmentController controller = Get.find();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FilterSheet(controller: controller),
  );
}

class _FilterSheet extends StatefulWidget {
  final ApartmentController controller;
  const _FilterSheet({required this.controller});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late double _maxPrice;
  late int _beds;
  late List<String> _amenities;

  static const _bedOptions = [
    (label: 'All', value: 0),
    (label: '1', value: 1),
    (label: '2', value: 2),
    (label: '3', value: 3),
    (label: '4+', value: -1),
  ];

  @override
  void initState() {
    super.initState();
    _maxPrice = widget.controller.maxPrice.value;
    _beds = widget.controller.bedsFilter.value;
    _amenities = List.from(widget.controller.amenitiesFilter);
  }

  void _apply() {
    widget.controller.maxPrice.value = _maxPrice;
    widget.controller.bedsFilter.value = _beds;
    widget.controller.amenitiesFilter.value = _amenities;
    Navigator.of(context).pop();
  }

  void _reset() {
    setState(() {
      _maxPrice = 5000.0;
      _beds = 0;
      _amenities = [];
    });
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      final thousands = (price / 1000).floor();
      final remainder = (price % 1000).round();
      return remainder == 0
          ? '€$thousands,000'
          : '€$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return '€${price.round()}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = HelperFunctions.isDarkMode(context);
    final primary = HelperFunctions.getPrimary(context);

    // ── Colors based on mode ──────────────────────────────────────────────
    final bgColor = isDark ? const Color(0xFF161616) : AppColors.bgLight;
    final handleColor = isDark ? const Color(0xFF333333) : AppColors.borderLight;
    final titleColor = isDark ? AppColors.textPrimary : AppColors.textBlack;
    final labelColor = isDark ? AppColors.textPrimary : AppColors.textBlack;
    final cardBg = isDark ? AppColors.bgCard : AppColors.bgCardLight;
    final cardBorder = isDark ? const Color(0xFF2A2A2A) : AppColors.borderLight;
    final selectedBg = isDark ? const Color(0xFF1A1F0A) : primary.withValues(alpha: 0.08);
    final unselectedText = isDark ? AppColors.textMuted : const Color(0xFF666666);
    final sliderInactive = isDark ? const Color(0xFF2A2A2A) : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ────────────────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: handleColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'filters_title'.tr,
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // ── Max Price ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'max_price'.tr,
                  style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: selectedBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _maxPrice >= 5000 ? 'any_label'.tr : _formatPrice(_maxPrice),
                    style: TextStyle(color: primary, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: primary,
                inactiveTrackColor: sliderInactive,
                thumbColor: primary,
                overlayColor: primary.withAlpha(30),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                value: _maxPrice,
                min: 0,
                max: 5000,
                divisions: 100,
                onChanged: (v) => setState(() => _maxPrice = v),
              ),
            ),
            const SizedBox(height: 20),

            // ── Bedrooms ──────────────────────────────────────────────────
            Text(
              'bedrooms_label'.tr,
              style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Row(
              children: _bedOptions.map((opt) {
                final selected = _beds == opt.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _beds = opt.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? selectedBg : cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected ? primary : cardBorder,
                        ),
                      ),
                      child: Text(
                        opt.label,
                        style: TextStyle(
                          color: selected ? primary : unselectedText,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Amenities ─────────────────────────────────────────────────
            Text(
              'amenities_label'.tr,
              style: TextStyle(color: labelColor, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: OptionTranslator.amenityKeys.map((a) {
                final selected = _amenities.contains(a);
                return GestureDetector(
                  onTap: () => setState(() {
                    selected ? _amenities.remove(a) : _amenities.add(a);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? selectedBg : cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: selected ? primary : cardBorder),
                    ),
                    child: Text(
                      OptionTranslator.translateAmenity(a),
                      style: TextStyle(
                        color: selected ? primary : unselectedText,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Buttons ───────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _reset,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: cardBorder),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'reset_label'.tr,
                        style: TextStyle(
                          color: unselectedText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _apply,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.35),
                            blurRadius: 16,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'apply_filters'.tr,
                        style: const TextStyle(
                          color: Color(0xFF0F0F0F),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}