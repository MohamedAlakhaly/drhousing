import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/functions/option_translator.dart';
import 'package:apartment_rentals/global/custom_appbar.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/edit_personal_info/view/edit_personal_info_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/controller/tenant_card_controller.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/view/tenant_card_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ─── Completion helpers ───────────────────────────────────────────────────────

double _computeProfilePercent(
  UserController userController,
  TenantCardController tenantController,
) {
  if (userController.user.value == null) return 0;
  int total = 0;
  int filled = 0;

  void check(bool done) {
    total++;
    if (done) filled++;
  }

  check(userController.displayName.isNotEmpty);
  check(userController.phoneNumber.isNotEmpty);
  check(userController.employmentStatus.isNotEmpty);
  if (userController.employmentStatus == 'Employed' ||
      userController.employmentStatus == 'Self-employed') {
    check(userController.jobTitle.isNotEmpty);
  }
  check(tenantController.selectedMaritalStatus.value.isNotEmpty);
  check(tenantController.selectedCities.isNotEmpty);
  check(tenantController.monthlyBudget.value > 0);
  check(tenantController.hasPets.value != null);
  check(tenantController.occupantsCount.value > 0);

  return total > 0 ? (filled / total).clamp(0.0, 1.0) : 0;
}

List<({String label, bool isDone})> _completionItems(
  UserController userController,
  TenantCardController tenantController,
) => [
  (label: 'full_name'.tr, isDone: userController.displayName.isNotEmpty),
  (
    label: 'phone_number_label'.tr,
    isDone: userController.phoneNumber.isNotEmpty,
  ),
  (
    label: 'employment_status_label'.tr,
    isDone: userController.employmentStatus.isNotEmpty,
  ),
  if (userController.employmentStatus == 'Employed' ||
      userController.employmentStatus == 'Self-employed')
    (label: 'job_title_label'.tr, isDone: userController.jobTitle.isNotEmpty),
  (
    label: 'rent_budget_title'.tr,
    isDone: tenantController.monthlyBudget.value > 0,
  ),
  (
    label: 'marital_status_label'.tr,
    isDone: tenantController.selectedMaritalStatus.value.isNotEmpty,
  ),
  (
    label: 'number_of_occupants'.tr,
    isDone: tenantController.occupantsCount.value > 0,
  ),
  (label: 'pets_label'.tr, isDone: tenantController.hasPets.value != null),
  (
    label: 'preferred_cities_title'.tr,
    isDone: tenantController.selectedCities.isNotEmpty,
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class TenantProfileView extends StatelessWidget {
  const TenantProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    final UserController userController = Get.find<UserController>();
    TenantCardController tenantCardController =
        Get.find<TenantCardController>();
    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      appBar: _buildAppBar(isDarkMode),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _ProfileHeader(userController: userController),
            const SizedBox(height: 20),
            _CompletionCard(
              userController: userController,
              tenantCardController: tenantCardController,
            ),

            const SizedBox(height: 14),
            _ProfessionalCard(userController: userController),
            const SizedBox(height: 14),
            Obx(
              () => tenantCardController.isEmpty
                  ? _EmptyTenantCard()
                  : Column(
                      children: [
                        _FinancialCard(
                          tenantCardController: tenantCardController,
                        ),
                        const SizedBox(height: 14),
                        _HouseholdCard(
                          tenantCardController: tenantCardController,
                        ),
                        const SizedBox(height: 14),
                        _CitiesCard(tenantCardController: tenantCardController),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return CustomAppBar(
      title: 'my_tenant_card'.tr,
      actions: [
        GestureDetector(
          onTap: () => Get.to(() => const TenantCardEditView()),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.primaryBg : Colors.grey[300],
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Icon(
              Iconsax.edit,
              color: isDarkMode ? AppColors.primary : AppColors.textBlack,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final UserController userController;
  const _ProfileHeader({required this.userController});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? AppColors.bgSurface
                          : AppColors.bgSurfaceLight,
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.22),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        HelperFunctions().getInitials(
                          userController.displayName,
                        ),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.black,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              userController.displayName,
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userController.email,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 15,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'verified_tenant'.tr,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: -0.06, end: 0, duration: 400.ms);
  }
}

// ─── Card shell ───────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final Widget child;
  final int delayMs;

  const _InfoCard({
    required this.headerIcon,
    required this.headerTitle,
    required this.child,
    this.delayMs = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
              width: 1,
            ),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 14,
                      spreadRadius: 0,
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
                    child: Icon(headerIcon, color: AppColors.primary, size: 15),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      headerTitle,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textPrimary
                            : AppColors.textBlack,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
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
          duration: 460.ms,
          delay: Duration(milliseconds: delayMs),
        )
        .slideY(
          begin: 0.07,
          end: 0,
          duration: 380.ms,
          delay: Duration(milliseconds: delayMs),
        );
  }
}

// ─── Info row ─────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.textMuted, size: 16),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textPrimary
                      : AppColors.textBlack,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        color: isDarkMode ? AppColors.divider : AppColors.borderLight,
        height: 1,
      ),
    );
  }
}

// ─── 1. Professional card ─────────────────────────────────────────────────────

class _ProfessionalCard extends StatelessWidget {
  final UserController userController;
  const _ProfessionalCard({required this.userController});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Obx(() {
      return _InfoCard(
        headerIcon: Iconsax.briefcase,
        headerTitle: 'professional_section'.tr,
        delayMs: 100,
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.phone_rounded,
              label: 'phone_number_label'.tr,
              value: userController.phoneNumber.isEmpty
                  ? 'not_provided'.tr
                  : userController.phoneNumber,
              trailing: userController.phoneNumber.isEmpty
                  ? GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.editPersonalInfo),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.bgSurface
                              : AppColors.bgSurfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.divider
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          'add_label'.tr,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
            userController.jobTitle.isEmpty ? SizedBox.shrink() : _RowDivider(),
            userController.jobTitle.isEmpty
                ? SizedBox.shrink()
                : _InfoRow(
                    icon: Iconsax.personalcard,
                    label: 'job_title_label'.tr,
                    value: userController.jobTitle,
                    trailing: userController.jobTitle.isEmpty
                        ? InkWell(
                            onTap: () {
                              Get.to(() => EditPersonalInfoView());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.bgSurface
                                    : AppColors.bgSurfaceLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isDarkMode
                                      ? AppColors.divider
                                      : AppColors.borderLight,
                                ),
                              ),
                              child: Text(
                                'add_label'.tr,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
            const _RowDivider(),
            _InfoRow(
              icon: Icons.business_center_rounded,
              label: 'employment_status_label'.tr,
              value: userController.employmentStatus.isEmpty
                  ? 'select_status'.tr
                  : OptionTranslator.translateEmployment(
                      userController.employmentStatus,
                    ),
              trailing:
                  userController.employmentStatus == 'Employed' ||
                      userController.employmentStatus == 'Self-employed'
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.primaryBg
                            : AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _PulseDot(),
                          const SizedBox(width: 5),
                          Text(
                            'active_badge'.tr,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }
}

class _PulseDot extends StatelessWidget {
  const _PulseDot();

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 900.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.2, 1.2),
          end: const Offset(0.8, 0.8),
          duration: 900.ms,
          curve: Curves.easeInOut,
        );
  }
}

// ─── 2. Financial card ────────────────────────────────────────────────────────

class _FinancialCard extends StatelessWidget {
  final TenantCardController tenantCardController;
  const _FinancialCard({required this.tenantCardController});

  String get _formattedIncome {
    double amount = tenantCardController.monthlyBudget.value;

    if (amount >= 1000) {
      final thousands = amount ~/ 1000;
      final remainder = (amount % 1000).toInt();
      return remainder == 0
          ? '€$thousands,000'
          : '€$thousands,${remainder.toString().padLeft(3, '0')}';
    }

    return '€${amount.toInt()}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Obx(() {
      return _InfoCard(
        headerIcon: Iconsax.wallet,
        headerTitle: 'rent_budget_title'.tr,
        delayMs: 200,
        child: tenantCardController.monthlyBudget.value == 0.0
            ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.tenantCardEdit),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.bgSurface
                            : AppColors.bgSurfaceLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Iconsax.wallet_add,
                        color: AppColors.textMuted,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'no_budget_set'.tr,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.textPrimary
                                  : AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'tap_to_define_budget'.tr,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formattedIncome,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7, left: 6),
                        child: Text(
                          'per_month'.tr,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'max_monthly_rent'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (tenantCardController.monthlyBudget / 5000).clamp(
                        0.0,
                        1.0,
                      ),
                      minHeight: 7,
                      backgroundColor: isDarkMode
                          ? AppColors.bgSurface
                          : AppColors.bgSurfaceLight,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '€0',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textDim
                              : const Color(0xff9a9a9a),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        '€5,000',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textDim
                              : const Color(0xff9a9a9a),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      );
    });
  }
}

// ─── 3. Household & Lifestyle card ───────────────────────────────────────────

class _HouseholdCard extends StatelessWidget {
  final TenantCardController tenantCardController;
  const _HouseholdCard({required this.tenantCardController});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Obx(() {
      return _InfoCard(
        headerIcon: Iconsax.people,
        headerTitle: 'household_lifestyle'.tr,
        delayMs: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              icon: Icons.favorite_border_rounded,
              label: 'marital_status_label'.tr,
              value: tenantCardController.selectedMaritalStatus.value.isEmpty
                  ? 'set_your_status'.tr
                  : OptionTranslator.translateMarital(
                      tenantCardController.selectedMaritalStatus.value,
                    ),
              trailing: tenantCardController.selectedMaritalStatus.value.isEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'tap_to_set'.tr,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textMuted,
                          size: 16,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const _RowDivider(),
            _InfoRow(
              icon: Iconsax.home,
              label: 'number_of_occupants'.tr,
              value: tenantCardController.occupantsCount.value == 0
                  ? 'not_specified'.tr
                  : '${tenantCardController.occupantsCount.value} ${tenantCardController.occupantsCount.value == 1 ? 'occupant_singular'.tr : 'occupant_plural'.tr}',
              trailing: tenantCardController.occupantsCount.value == 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.bgSurface
                            : AppColors.bgSurfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.divider
                              : AppColors.borderLight,
                        ),
                      ),
                      child: Text(
                        'not_set'.tr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        ...List.generate(
                          tenantCardController.occupantsCount.value > 3
                              ? 3
                              : tenantCardController.occupantsCount.value,
                          (i) => Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDarkMode
                                    ? AppColors.primaryBg
                                    : AppColors.primary.withValues(alpha: 0.10),
                                border: Border.all(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.4,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: AppColors.primary,
                                size: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 3),
                        if (tenantCardController.occupantsCount > 3)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              "+${tenantCardController.occupantsCount.value - 3}",
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            const _RowDivider(),
            Text(
              'lifestyle_label'.tr,
              style: TextStyle(
                color: isDarkMode ? AppColors.textDim : const Color(0xff9a9a9a),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                _LifestyleChip(
                  icon: Icons.pets_rounded,
                  label: 'pets_label'.tr,
                  value: tenantCardController.hasPets.value == null
                      ? 'no_info_added'.tr
                      : tenantCardController.hasPets.value == true
                      ? 'yes_label'.tr
                      : 'no_label'.tr,
                  isActive: tenantCardController.hasPets.value == true
                      ? true
                      : false,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _LifestyleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isActive;

  const _LifestyleChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive
                ? (isDarkMode
                      ? AppColors.primaryBg
                      : AppColors.primary.withValues(alpha: 0.10))
                : (isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.primary : AppColors.textMuted,
            size: 16,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'pets_label'.tr,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : (isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── 4. Preferred cities card ─────────────────────────────────────────────────

class _CitiesCard extends StatelessWidget {
  final TenantCardController tenantCardController;
  const _CitiesCard({required this.tenantCardController});

  @override
  Widget build(BuildContext context) {
    final cities = tenantCardController.selectedCities;
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Obx(() {
      return _InfoCard(
        headerIcon: Iconsax.location,
        headerTitle: 'preferred_cities_title'.tr,
        delayMs: 400,
        child: cities.isEmpty
            ? GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.tenantCardEdit),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.bgSurface
                            : AppColors.bgSurfaceLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Iconsax.location_add,
                        color: AppColors.textMuted,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'no_cities_selected'.tr,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.textPrimary
                                  : AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'add_cities_hint'.tr,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textMuted,
                      size: 18,
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cities.map((city) => _CityChip(city: city)).toList(),
              ),
      );
    });
  }
}

class _CityChip extends StatelessWidget {
  final String city;
  const _CityChip({required this.city});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgSurface : AppColors.bgSurfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.45),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            city,
            style: TextStyle(
              color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Profile completion card ──────────────────────────────────────────────────

class _CompletionCard extends StatelessWidget {
  final UserController userController;
  final TenantCardController tenantCardController;
  const _CompletionCard({
    required this.userController,
    required this.tenantCardController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final percent = _computeProfilePercent(
        userController,
        tenantCardController,
      );
      final items = _completionItems(userController, tenantCardController);
      final done = items.where((i) => i.isDone).length;

      return _InfoCard(
        headerIcon: Iconsax.profile_tick,
        headerTitle: 'profile_completeness'.tr,
        delayMs: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 58,
              lineWidth: 8,
              percent: percent,
              animation: true,
              animationDuration: 1000,
              animateFromLastPercent: true,
              backgroundColor: HelperFunctions.isDarkMode(context)
                  ? AppColors.bgSurface
                  : AppColors.bgSurfaceLight,
              progressColor: AppColors.primary,
              circularStrokeCap: CircularStrokeCap.round,
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(percent * 100).round()}%',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'done_label'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 22),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'profile_completion_progress'.tr
                        .replaceAll('{done}', done.toString())
                        .replaceAll('{total}', items.length.toString()),
                    style: TextStyle(
                      color: HelperFunctions.isDarkMode(context)
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'complete_profile_attract'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...items.map((item) => _CompletionRow(item: item)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _EmptyTenantCard extends StatelessWidget {
  const _EmptyTenantCard();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
          onTap: () => Get.to(() => TenantCardEditView()),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.primaryBg
                  : AppColors.primary.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.bgCard
                        : AppColors.bgCardLight,
                    shape: BoxShape.circle,
                    boxShadow: isDarkMode
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                            ),
                          ],
                  ),
                  child: const Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'complete_tenant_card'.tr,
                  style: TextStyle(
                    color: isDarkMode
                        ? AppColors.textPrimary
                        : AppColors.textBlack,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'landlords_respond_hint'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'fill_in_now_button'.tr,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .slideY(begin: 0.07, curve: Curves.easeOut);
  }
}

class _CompletionRow extends StatelessWidget {
  final ({String label, bool isDone}) item;
  const _CompletionRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 17,
            height: 17,
            decoration: BoxDecoration(
              color: item.isDone
                  ? (isDarkMode
                        ? AppColors.primaryBg
                        : AppColors.primary.withValues(alpha: 0.12))
                  : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: item.isDone
                    ? AppColors.primary
                    : (isDarkMode ? AppColors.divider : AppColors.borderLight),
                width: 1.5,
              ),
            ),
            child: item.isDone
                ? const Icon(
                    Icons.check_rounded,
                    color: AppColors.primary,
                    size: 10,
                  )
                : null,
          ),
          const SizedBox(width: 9),
          Text(
            item.label,
            style: TextStyle(
              color: item.isDone
                  ? (isDarkMode ? AppColors.textPrimary : AppColors.textBlack)
                  : AppColors.textMuted,
              fontSize: 12,
              fontWeight: item.isDone ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
