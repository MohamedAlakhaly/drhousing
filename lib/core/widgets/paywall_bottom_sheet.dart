import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/core/services/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';

void showPaywallBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    useSafeArea: false,
    builder: (_) => const _PaywallSheet(),
  );
}

class _PaywallSheet extends StatelessWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewPadding.bottom;
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgCard : AppColors.bgLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 14, 24, bottomPad > 0 ? bottomPad + 12 : 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Handle(isDarkMode: isDarkMode),
          const SizedBox(height: 24),
          _CrownIcon(isDarkMode: isDarkMode),
          const SizedBox(height: 16),
          _Title(isDarkMode: isDarkMode),
          const SizedBox(height: 22),
          _FeatureList(isDarkMode: isDarkMode),
          const SizedBox(height: 20),
          _PriceBadge(isDarkMode: isDarkMode),
          const SizedBox(height: 24),
          const _UnlockButton(),
          const SizedBox(height: 6),
          const _MaybeLater(),
          const SizedBox(height: 10),
          const _RestoreNote(),
        ],
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  final bool isDarkMode;
  const _Handle({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(color: AppColors.textDim, borderRadius: BorderRadius.circular(2)),
    );
  }
}

class _CrownIcon extends StatelessWidget {
  final bool isDarkMode;
  const _CrownIcon({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return GlowContainer(
          width: 80,
          height: 80,
          color: isDarkMode ? AppColors.primaryBg : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
          glowColor: AppColors.primary.withValues(alpha: 0.42),
          blurRadius: 30,
          spreadRadius: 2,
          child: Center(
            child: Icon(
              Icons.workspace_premium_rounded,
              color: isDarkMode ? AppColors.primary : Colors.black,
              size: 38,
            ),
          ),
        )
        .animate()
        .scale(begin: const Offset(0.4, 0.4), end: const Offset(1.0, 1.0), duration: 550.ms, curve: Curves.elasticOut, delay: 60.ms)
        .fadeIn(duration: 300.ms, delay: 60.ms);
  }
}

class _Title extends StatelessWidget {
  final bool isDarkMode;
  const _Title({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
          'paywall_title'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 160.ms)
        .slideY(begin: 0.15, end: 0, duration: 350.ms, delay: 160.ms);
  }
}

class _FeatureList extends StatelessWidget {
  final bool isDarkMode;
  const _FeatureList({required this.isDarkMode});

  static List<String> get _items => [
    'paywall_feature_1'.tr,
    'paywall_feature_2'.tr,
    'paywall_feature_3'.tr,
    'paywall_feature_4'.tr,
  ];

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Column(
      children: [
        for (int i = 0; i < items.length; i++)
          _FeatureRow(text: items[i], index: i, isDarkMode: isDarkMode),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final int index;
  final bool isDarkMode;

  const _FeatureRow({required this.text, required this.index, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.primary, size: 14),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: 200 + index * 60))
        .slideX(begin: -0.1, end: 0, duration: 300.ms, delay: Duration(milliseconds: 200 + index * 60));
  }
}

class _PriceBadge extends StatelessWidget {
  final bool isDarkMode;
  const _PriceBadge({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.primaryBg : Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: isDarkMode ? AppColors.primary.withValues(alpha: 0.40) : Colors.grey[400]!),
          ),
          child: Text(
            'paywall_price_badge'.tr,
            style: TextStyle(
              color: isDarkMode ? AppColors.primary : AppColors.textBlack,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 350.ms, delay: 460.ms)
        .scale(begin: const Offset(0.92, 0.92), end: const Offset(1.0, 1.0), duration: 300.ms, delay: 460.ms);
  }
}

class _UnlockButton extends StatelessWidget {
  const _UnlockButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            Get.back();
            PaymentService.startPremiumCheckout();
          },
          child: GlowContainer(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            glowColor: AppColors.primary.withValues(alpha: 0.45),
            spreadRadius: 2,
            blurRadius: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_open_rounded, color: Colors.black, size: 20),
                const SizedBox(width: 10),
                Text(
                  'paywall_unlock_button'.tr,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 540.ms)
        .slideY(begin: 0.15, end: 0, duration: 350.ms, delay: 540.ms);
  }
}

class _MaybeLater extends StatelessWidget {
  const _MaybeLater();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: Get.back,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        overlayColor: AppColors.textDim,
      ),
      child: Text(
        'paywall_maybe_later'.tr,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: 620.ms);
  }
}

class _RestoreNote extends StatelessWidget {
  const _RestoreNote();

  @override
  Widget build(BuildContext context) {
    return Text(
      'paywall_restore_note'.tr,
      style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
    ).animate().fadeIn(duration: 300.ms, delay: 680.ms);
  }
}