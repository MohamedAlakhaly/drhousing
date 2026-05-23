import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';

class MySubscriptionView extends StatelessWidget {
  const MySubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final bool isDarkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
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
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'my_subscription'.tr,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textPrimary
                              : AppColors.textBlack,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'manage_plan_billing'.tr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.15),

            // ── Content ──────────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                final isPremium = userController.isPremium;
                final isExpired = userController.isPremiumExpired;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
                  child: isPremium
                      ? _PremiumState(controller: userController)
                      : isExpired
                      ? _ExpiredState(controller: userController)
                      : const _FreeState(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STATE 1 — Premium Active
// ══════════════════════════════════════════════════════════════

class _PremiumState extends StatelessWidget {
  final UserController controller;
  const _PremiumState({required this.controller});

  static List<({IconData icon, String text})> get _privileges => [
    (icon: Icons.domain_verification_rounded, text: 'paywall_feature_1'.tr),
    (icon: Icons.event_available_rounded, text: 'paywall_feature_2'.tr),
    (icon: Icons.verified_user_rounded, text: 'paywall_feature_3'.tr),
    (icon: Icons.favorite_rounded, text: 'paywall_feature_4'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ActivePlanCard(controller: controller),
        const SizedBox(height: 20),
        _PrivilegesSection(privileges: _privileges),
        const SizedBox(height: 28),
        _PremiumNote(),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STATE 2 — Expired
// ══════════════════════════════════════════════════════════════

class _ExpiredState extends StatelessWidget {
  final UserController controller;
  const _ExpiredState({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Expired card ──────────────────────────────────────────────────
        Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.dangerColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dangerColor.withValues(alpha: 0.08),
                    blurRadius: 30,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dangerColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.dangerColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.dangerColor,
                              size: 13,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'premium_badge'.tr,
                              style: const TextStyle(
                                color: AppColors.dangerColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dangerColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.dangerColor.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'subscription_expired'.tr,
                          style: const TextStyle(
                            color: AppColors.dangerColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'dr_housing_premium'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textMuted
                          : AppColors.textBlack,
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 18),

                  // Expiry date
                  _InfoRow(
                    icon: Icons.event_busy_rounded,
                    iconColor: AppColors.dangerColor,
                    iconBg: AppColors.dangerColor.withValues(alpha: 0.1),
                    label: 'expired_on'.tr,
                    value: controller.formattedExpiryDate,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 12),

                  // Activation date
                  _InfoRow(
                    icon: Icons.calendar_today_rounded,
                    iconColor: AppColors.textMuted,
                    iconBg: isDarkMode
                        ? AppColors.bgSurface
                        : const Color(0xFFF0F0F0),
                    label: 'activation_date'.tr,
                    value: controller.formattedActivationDate,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 500.ms, delay: 80.ms)
            .slideY(begin: 0.06, duration: 420.ms, delay: 80.ms),

        const SizedBox(height: 20),

        // ── Renew button ──────────────────────────────────────────────────
        GestureDetector(
              onTap: PaymentService.startPremiumCheckout,
              child: GlowContainer(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 17),
                color: HelperFunctions.getPrimary(context),
                borderRadius: BorderRadius.circular(16),
                glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.45),
                spreadRadius: 2,
                blurRadius: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'renew_subscription'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 420.ms, delay: 300.ms)
            .slideY(begin: 0.06, duration: 360.ms, delay: 300.ms),

        const SizedBox(height: 12),
        Center(
          child: Text(
            'renew_price_note'.tr,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  STATE 3 — Free
// ══════════════════════════════════════════════════════════════

class _FreeState extends StatelessWidget {
  const _FreeState();

  static List<({IconData icon, String text})> get _lockedFeatures => [
    (icon: Icons.domain_verification_rounded, text: 'paywall_feature_1'.tr),
    (icon: Icons.event_available_rounded, text: 'paywall_feature_2'.tr),
    (icon: Icons.verified_user_rounded, text: 'paywall_feature_3'.tr),
    (icon: Icons.favorite_rounded, text: 'paywall_feature_4'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FreePlanCard(),
        const SizedBox(height: 20),
        _LockedFeaturesSection(features: _lockedFeatures),
        const SizedBox(height: 20),
        const _UpgradeButton(),
      ],
    );
  }
}

// ── Shared info row ────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final bool isDarkMode;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
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

// ── Active plan card ───────────────────────────────────────────────────────────
class _ActivePlanCard extends StatelessWidget {
  final UserController controller;
  const _ActivePlanCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    final daysLeft = controller.premiumDaysRemaining;
    final isWarning = daysLeft <= 7;

    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: HelperFunctions.getPrimary(context).withValues(alpha: 0.45),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: HelperFunctions.getPrimary(context).withValues(
                  alpha: isDarkMode ? 0.12 : 0.18,
                ),
                blurRadius: isDarkMode ? 36 : 24,
                spreadRadius: isDarkMode ? 4 : 2,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: HelperFunctions.getPrimary(context).withValues(
                  alpha: isDarkMode ? 0.06 : 0.08,
                ),
                blurRadius: 70,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: HelperFunctions.getPrimary(context).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(
                          Icons.workspace_premium_rounded,
                          color: HelperFunctions.getPrimary(context),
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'premium_badge'.tr,
                          style:  TextStyle(
                            color: HelperFunctions.getPrimary(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: HelperFunctions.getPrimary(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _ActiveDot(),
                        const SizedBox(width: 6),
                        Text(
                          'active_badge'.tr,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              Text(
                'dr_housing_premium'.tr,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textPrimary
                      : AppColors.textBlack,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'premium_price'.tr,
                    style:  TextStyle(
                      color: HelperFunctions.getPrimary(context),
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 9, left: 7),
                    child: Text(
                      'one_time'.tr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 1,
              ),
              const SizedBox(height: 18),

              // Activation date
              _InfoRow(
                icon: Icons.calendar_today_rounded,
                iconColor: HelperFunctions.getPrimary(context),
                iconBg: AppColors.primaryBg,
                label: 'activation_date'.tr,
                value: controller.formattedActivationDate,
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 12),

              // Expiry date
              _InfoRow(
                icon: Icons.event_rounded,
                iconColor: isWarning
                    ? AppColors.dangerColor
                    : HelperFunctions.getPrimary(context),
                iconBg: isWarning
                    ? AppColors.dangerColor.withValues(alpha: 0.1)
                    : AppColors.primaryBg,
                label: 'expires_on'.tr,
                value: controller.formattedExpiryDate,
                isDarkMode: isDarkMode,
              ),

              const SizedBox(height: 12),

              // Days remaining badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isWarning
                      ? AppColors.dangerColor.withValues(alpha: 0.1)
                      : AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isWarning
                        ? AppColors.dangerColor.withValues(alpha: 0.4)
                        : HelperFunctions.getPrimary(context).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.timer_outlined,
                      color: isWarning
                          ? AppColors.dangerColor
                          : HelperFunctions.getPrimary(context),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$daysLeft ${'days_remaining'.tr}',
                      style: TextStyle(
                        color: isWarning
                            ? AppColors.dangerColor
                            : HelperFunctions.getPrimary(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 80.ms)
        .slideY(begin: 0.06, end: 0, duration: 420.ms, delay: 80.ms);
  }
}

// ── Active dot ─────────────────────────────────────────────────────────────────
class _ActiveDot extends StatelessWidget {
  const _ActiveDot();

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.3, 1.3),
          duration: 900.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.3, 1.3),
          end: const Offset(0.7, 0.7),
          duration: 900.ms,
          curve: Curves.easeInOut,
        );
  }
}

// ── Privileges section ─────────────────────────────────────────────────────────
class _PrivilegesSection extends StatelessWidget {
  final List<({IconData icon, String text})> privileges;
  const _PrivilegesSection({required this.privileges});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 14),
              child: Row(
                children: [
                  Text(
                    'your_privileges'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${privileges.length}',
                    style: TextStyle(
                      color: isDarkMode
                          ? HelperFunctions.getPrimary(context)
                          : AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
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
                children: privileges
                    .asMap()
                    .entries
                    .map(
                      (e) => _PrivilegeItem(
                        icon: e.value.icon,
                        text: e.value.text,
                        isLast: e.key == privileges.length - 1,
                        delayMs: 200 + e.key * 80,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 450.ms, delay: 180.ms)
        .slideY(begin: 0.06, end: 0, duration: 380.ms, delay: 180.ms);
  }
}

class _PrivilegeItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;
  final int delayMs;
  const _PrivilegeItem({
    required this.icon,
    required this.text,
    required this.isLast,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: HelperFunctions.getPrimary(context), size: 17),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textPrimary
                            : AppColors.textBlack,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: AppColors.primary,
                      size: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 1,
              ),
          ],
        )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: delayMs),
        )
        .slideX(
          begin: 0.06,
          end: 0,
          duration: 340.ms,
          delay: Duration(milliseconds: delayMs),
        );
  }
}

// ── Premium note ───────────────────────────────────────────────────────────────
class _PremiumNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'premium_access_note'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
          height: 1.6,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 560.ms);
  }
}

// ── Free plan card ─────────────────────────────────────────────────────────────
class _FreePlanCard extends StatelessWidget {
  const _FreePlanCard();

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
              width: 1.5,
            ),
            boxShadow: isDarkMode
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.bgSurface
                          : AppColors.bgSurfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.textDim),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          color: AppColors.textMuted,
                          size: 13,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'free_badge'.tr,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.bgSurface
                          : AppColors.bgSurfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.textDim),
                    ),
                    child: Text(
                      'limited_access'.tr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'free_plan'.tr,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textMuted
                      : const Color(0xFF666666),
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'free_label'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, left: 8),
                    child: Text(
                      'forever_label'.tr,
                      style: const TextStyle(
                        color: AppColors.textDim,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 1,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'unlock_everything'.tr,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textMuted
                              : AppColors.textBlack,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'upgrade_price_label'.tr,
                        style: TextStyle(
                          color: isDarkMode
                              ? HelperFunctions.getPrimary(context)
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 80.ms)
        .slideY(begin: 0.06, end: 0, duration: 420.ms, delay: 80.ms);
  }
}

// ── Locked features section ────────────────────────────────────────────────────
class _LockedFeaturesSection extends StatelessWidget {
  final List<({IconData icon, String text})> features;
  const _LockedFeaturesSection({required this.features});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 14),
              child: Text(
                'locked_features'.tr,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textMuted
                      : const Color(0xFF666666),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
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
                children: features
                    .asMap()
                    .entries
                    .map(
                      (e) => _LockedFeatureItem(
                        icon: e.value.icon,
                        text: e.value.text,
                        isLast: e.key == features.length - 1,
                        delayMs: 200 + e.key * 80,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 450.ms, delay: 180.ms)
        .slideY(begin: 0.06, end: 0, duration: 380.ms, delay: 180.ms);
  }
}

class _LockedFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;
  final int delayMs;
  const _LockedFeatureItem({
    required this.icon,
    required this.text,
    required this.isLast,
    required this.delayMs,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.dangerBg
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: AppColors.dangerColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.dangerBg
                          : AppColors.dangerColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.dangerColor,
                      size: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (!isLast)
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 1,
              ),
          ],
        )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: delayMs),
        )
        .slideX(
          begin: 0.06,
          end: 0,
          duration: 340.ms,
          delay: Duration(milliseconds: delayMs),
        );
  }
}

// ── Upgrade button ─────────────────────────────────────────────────────────────
class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: PaymentService.startPremiumCheckout,
          child: GlowContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            color: HelperFunctions.getPrimary(context),
            borderRadius: BorderRadius.circular(16),
            glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.45),
            spreadRadius: 2,
            blurRadius: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_open_rounded,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'upgrade_now_button'.tr,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 420.ms, delay: 340.ms)
        .slideY(begin: 0.06, end: 0, duration: 360.ms, delay: 340.ms);
  }
}
