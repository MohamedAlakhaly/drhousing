import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/functions/option_translator.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/controller/tenant_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TenantCardEditView extends StatelessWidget {
  const TenantCardEditView({super.key});

  @override
  Widget build(BuildContext context) {
    TenantCardController ctrl = Get.find<TenantCardController>();
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'my_tenant_card'.tr,
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.textPrimary
                                : AppColors.textBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'shown_to_landlords'.tr,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 80.ms, duration: 350.ms),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Scrollable sections + save button ────────────────────────
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // ── Marital Status ─────────────────────────────────
                          _SectionCard(
                            icon: Icons.favorite_border_rounded,
                            title: 'marital_status_label'.tr,
                            delay: 150,
                            child: Obx(() {
                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: ctrl.maritalOptions
                                    .map(
                                      (opt) => _SelectChip(
                                        label: OptionTranslator.translateMarital(opt),
                                        isSelected:
                                            ctrl.selectedMaritalStatus.value == opt,
                                        onTap: () =>
                                            ctrl.selectMaritalStatus(opt),
                                      ),
                                    )
                                    .toList(),
                              );
                            }),
                          ),

                          const SizedBox(height: 14),

                          // ── Occupants ──────────────────────────────────────
                          _SectionCard(
                            icon: Iconsax.people,
                            title: 'number_of_occupants'.tr,
                            delay: 240,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'occupants_hint'.tr,
                                        style: const TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Obx(() {
                                  return _CounterRow(
                                    count: ctrl.occupantsCount.value,
                                    onDecrement: ctrl.decrementOccupants,
                                    onIncrement: ctrl.incrementOccupants,
                                  );
                                }),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Pets ───────────────────────────────────────────
                          _SectionCard(
                            icon: Icons.pets_rounded,
                            title: 'pets_label'.tr,
                            delay: 330,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'pets_hint'.tr,
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Obx(() {
                                  return Row(
                                    children: [
                                      _YesNoChip(
                                        label: 'yes_label'.tr,
                                        isSelected: ctrl.hasPets.value == true,
                                        onTap: () => ctrl.setPets(true),
                                      ),
                                      const SizedBox(width: 8),
                                      _YesNoChip(
                                        label: 'no_label'.tr,
                                        isSelected: ctrl.hasPets.value == false,
                                        onTap: () => ctrl.setPets(false),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Rent Budget ────────────────────────────────────
                          _SectionCard(
                            icon: Iconsax.wallet,
                            title: 'max_monthly_rent'.tr,
                            delay: 420,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'budget_hint'.tr,
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? AppColors.primaryBg
                                            : HelperFunctions.getPrimary(context)
                                                .withValues(alpha: 0.10),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: HelperFunctions.getPrimary(context).withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                      ),
                                      child: Obx(() {
                                        return Text(
                                          '€${ctrl.monthlyBudget.toInt()}',
                                          style:  TextStyle(
                                            color: HelperFunctions.getPrimary(context),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: HelperFunctions.getPrimary(context),
                                    inactiveTrackColor: isDarkMode
                                        ? AppColors.bgSurface
                                        : AppColors.bgSurfaceLight,
                                    thumbColor: HelperFunctions.getPrimary(context),
                                    overlayColor:
                                        HelperFunctions.getPrimary(context).withValues(alpha: 0.18),
                                    thumbShape:
                                        const RoundSliderThumbShape(
                                      enabledThumbRadius: 10,
                                    ),
                                    trackHeight: 4,
                                  ),
                                  child: Obx(() {
                                    return Slider(
                                      value: ctrl.monthlyBudget.value,
                                      min: 0,
                                      max: 5000,
                                      divisions: 100,
                                      onChanged: ctrl.setMonthlyBudget,
                                    );
                                  }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '€0',
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? AppColors.textDim
                                              : const Color(0xff9a9a9a),
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        '€5,000',
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? AppColors.textDim
                                              : const Color(0xff9a9a9a),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ── Preferred Cities ─────────────────────────────────
                          _SectionCard(
                            icon: Iconsax.location,
                            title: 'preferred_cities_title'.tr,
                            delay: 510,
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => FractionallySizedBox(
                                  heightFactor: 0.78,
                                  child: _CitiesBottomSheet(ctrl: ctrl),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? AppColors.bgSurface
                                      : AppColors.bgSurfaceLight,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isDarkMode
                                        ? AppColors.divider
                                        : AppColors.borderLight,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                     Icon(
                                      Iconsax.location,
                                      color: HelperFunctions.getPrimary(context),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Obx(() {
                                        final n =
                                            ctrl.selectedCities.length;
                                        return Text(
                                          n == 0
                                              ? 'select_cities_hint'.tr
                                              : '$n ${n == 1 ? 'city_label'.tr : 'cities_label'.tr} ${'selected_label'.tr}',
                                          style: TextStyle(
                                            color: n == 0
                                                ? AppColors.textMuted
                                                : (isDarkMode
                                                    ? AppColors.textPrimary
                                                    : AppColors.textBlack),
                                            fontSize: 14,
                                          ),
                                        );
                                      }),
                                    ),
                                    Obx(() {
                                      final n = ctrl.selectedCities.length;
                                      if (n == 0) {
                                        return const Icon(
                                          Icons.chevron_right_rounded,
                                          color: AppColors.textMuted,
                                          size: 18,
                                        );
                                      }
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? AppColors.primaryBg
                                              : HelperFunctions.getPrimary(context)
                                                  .withValues(alpha: 0.10),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                HelperFunctions.getPrimary(context).withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          '$n',
                                          style:  TextStyle(
                                            color: HelperFunctions.getPrimary(context),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  // ── Save button ─────────────────────────────────────
                  Padding(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          12,
                          20,
                          MediaQuery.of(context).padding.bottom + 20,
                        ),
                        child: GestureDetector(
                          onTap: () => ctrl.updateUserPreferences(),
                          child: GlowContainer(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            color: HelperFunctions.getPrimary(context),
                            borderRadius: BorderRadius.circular(16),
                            glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.40),
                            spreadRadius: 2,
                            blurRadius: 22,
                            child: Obx(() {
                              return ctrl.isLoading.value
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_rounded,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'save_tenant_card'.tr,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideY(begin: 0.15, curve: Curves.easeOut),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;
  final int delay;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
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
                      blurRadius: 10,
                      offset: const Offset(0, 2),
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
                          : HelperFunctions.getPrimary(context).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: HelperFunctions.getPrimary(context), size: 17),
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
          delay: Duration(milliseconds: delay),
          duration: 400.ms,
        )
        .slideY(begin: 0.07, curve: Curves.easeOut);
  }
}

class _SelectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? AppColors.primaryBg
                  : HelperFunctions.getPrimary(context).withValues(alpha: 0.10))
              : (isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? HelperFunctions.getPrimary(context)
                : (isDarkMode ? AppColors.divider : AppColors.borderLight),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? HelperFunctions.getPrimary(context) : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _YesNoChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _YesNoChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                  ? AppColors.primaryBg
                  : HelperFunctions.getPrimary(context).withValues(alpha: 0.10))
              : (isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? HelperFunctions.getPrimary(context)
                : (isDarkMode ? AppColors.divider : AppColors.borderLight),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? HelperFunctions.getPrimary(context) : AppColors.textMuted,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterRow({
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Row(
      children: [
        _CounterBtn(
          icon: Icons.remove_rounded,
          onTap: onDecrement,
          active: false,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            '$count',
            style: TextStyle(
              color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
        ),
        _CounterBtn(icon: Icons.add_rounded, onTap: onIncrement, active: true),
      ],
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _CounterBtn({
    required this.icon,
    required this.onTap,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: active
              ? (isDarkMode
                  ? AppColors.primaryBg
                  : HelperFunctions.getPrimary(context).withValues(alpha: 0.10))
              : (isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active
                ? HelperFunctions.getPrimary(context)
                : (isDarkMode ? AppColors.divider : AppColors.borderLight),
            width: 1.5,
          ),
        ),
        child: Icon(
          icon,
          color: active ? HelperFunctions.getPrimary(context) : AppColors.textMuted,
          size: 18,
        ),
      ),
    );
  }
}

// ─── Cities bottom sheet ──────────────────────────────────────────────────────

class _CitiesBottomSheet extends StatefulWidget {
  final TenantCardController ctrl;
  const _CitiesBottomSheet({required this.ctrl});

  @override
  State<_CitiesBottomSheet> createState() => _CitiesBottomSheetState();
}

class _CitiesBottomSheetState extends State<_CitiesBottomSheet> {
  final TextEditingController _searchCtrl = TextEditingController();

  TenantCardController get ctrl => widget.ctrl;

  @override
  void initState() {
    super.initState();
    ctrl.citySearchQuery.value = '';
    _searchCtrl.addListener(
      () => ctrl.citySearchQuery.value = _searchCtrl.text,
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    ctrl.citySearchQuery.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 30,
                  offset: const Offset(0, -6),
                ),
              ],
      ),
      child: Column(
        children: [
          // ── Drag handle ──────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                Text(
                  'select_cities_title'.tr,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const Spacer(),
                Obx(() {
                  final n = ctrl.selectedCities.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: n == 0
                          ? (isDarkMode
                              ? AppColors.bgSurface
                              : AppColors.bgSurfaceLight)
                          : (isDarkMode
                              ? AppColors.primaryBg
                              : HelperFunctions.getPrimary(context).withValues(alpha: 0.10)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: n == 0
                            ? (isDarkMode
                                ? AppColors.divider
                                : AppColors.borderLight)
                            : HelperFunctions.getPrimary(context),
                      ),
                    ),
                    child: Text(
                      '$n ${'selected_label'.tr}',
                      style: TextStyle(
                        color: n == 0 ? AppColors.textMuted : HelperFunctions.getPrimary(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // ── Search bar ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
                fontSize: 14,
              ),
              cursorColor: HelperFunctions.getPrimary(context),
              decoration: InputDecoration(
                hintText: 'search_cities_hint'.tr,
                hintStyle: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 16, right: 10),
                  child: Icon(
                    Iconsax.search_normal_1,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
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
                  borderSide:  BorderSide(
                    color: HelperFunctions.getPrimary(context),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── City list ────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final cities = ctrl.filteredCities;
              if (cities.isEmpty) {
                return Center(
                  child: Text(
                    'no_cities_found'.tr,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                itemCount: cities.length,
                itemBuilder: (_, i) {
                  final city = cities[i];
                  return Obx(() {
                    final isSelected = ctrl.selectedCities.contains(city);
                    return GestureDetector(
                      onTap: () => ctrl.toggleCity(city),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDarkMode
                                  ? AppColors.primaryBg
                                  : HelperFunctions.getPrimary(context).withValues(alpha: 0.08))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? HelperFunctions.getPrimary(context)
                                    : (isDarkMode
                                        ? AppColors.textDim
                                        : const Color(0xffcccccc)),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                city,
                                style: TextStyle(
                                  color: isSelected
                                      ? HelperFunctions.getPrimary(context)
                                      : (isDarkMode
                                          ? AppColors.textPrimary
                                          : AppColors.textBlack),
                                  fontSize: 15,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? HelperFunctions.getPrimary(context)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? HelperFunctions.getPrimary(context)
                                      : (isDarkMode
                                          ? AppColors.divider
                                          : AppColors.borderLight),
                                  width: 1.5,
                                ),
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.black,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),

          // ── Save button ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  20,
            ),
            child: GestureDetector(
              onTap: Get.back,
              child: GlowContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                color: HelperFunctions.getPrimary(context),
                borderRadius: BorderRadius.circular(14),
                glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.35),
                blurRadius: 20,
                spreadRadius: 1,
                child: Center(
                  child: Text(
                    'save_selection'.tr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
