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
  late int _beds; // 0=All, 1,2,3, -1=4+
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
      return remainder == 0 ? '€$thousands,000' : '€$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return '€${price.round()}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'filters_title'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Satoshi',
              ),
            ),
            const SizedBox(height: 24),

            // ── Max Price ────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'max_price'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Satoshi',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F0A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _maxPrice >= 5000 ? 'any_label'.tr : _formatPrice(_maxPrice),
                    style: const TextStyle(
                      color: Color(0xFFCCFF00),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Satoshi',
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFFCCFF00),
                inactiveTrackColor: const Color(0xFF2A2A2A),
                thumbColor: const Color(0xFFCCFF00),
                overlayColor: const Color(0xFFCCFF00).withAlpha(30),
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

            // ── Bedrooms ─────────────────────────────────────────
            Text(
              'bedrooms_label'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Satoshi',
              ),
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
                        color: selected
                            ? const Color(0xFF1A1F0A)
                            : const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFCCFF00)
                              : const Color(0xFF2A2A2A),
                        ),
                      ),
                      child: Text(
                        opt.label,
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFFCCFF00)
                              : const Color(0xFF888888),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Satoshi',
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Amenities ────────────────────────────────────────
            Text(
              'amenities_label'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Satoshi',
              ),
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
                      color: selected
                          ? const Color(0xFF1A1F0A)
                          : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFFCCFF00)
                            : const Color(0xFF2A2A2A),
                      ),
                    ),
                    child: Text(
                      OptionTranslator.translateAmenity(a),
                      style: TextStyle(
                        color: selected
                            ? const Color(0xFFCCFF00)
                            : const Color(0xFF888888),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Satoshi',
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Buttons ──────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _reset,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'reset_label'.tr,
                        style: const TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Satoshi',
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
                        color: const Color(0xFFCCFF00),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'apply_filters'.tr,
                        style: const TextStyle(
                          color: Color(0xFF0F0F0F),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Satoshi',
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
