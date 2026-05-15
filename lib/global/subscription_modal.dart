import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/modules/navigation_items/premium_subscription/view/premium_subscription_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';

void showSubscriptionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    useSafeArea: false,
    builder: (_) => const _SubscriptionModalSheet(),
  );
}

// ─── Sheet ───────────────────────────────────────────────────────────────────

class _SubscriptionModalSheet extends StatelessWidget {
  const _SubscriptionModalSheet();

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 14, 24, bottomPad > 0 ? bottomPad + 12 : 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DragHandle(),
          const SizedBox(height: 26),
          _LockIcon(),
          const SizedBox(height: 18),
          _Headline(),
          const SizedBox(height: 10),
          _Description(),  
          const SizedBox(height: 26),
          _JoinButton(),
          const SizedBox(height: 10),
          _MaybeLater(),
        ],
      ),
    );
  }
}

// ─── Drag handle ─────────────────────────────────────────────────────────────

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textDim,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ─── Lock icon with glow ──────────────────────────────────────────────────────

class _LockIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      width: 80,
      height: 80,
      color: AppColors.primaryBg,
      borderRadius: BorderRadius.circular(24),
      glowColor: AppColors.primary.withValues(alpha: 0.38),
      blurRadius: 28,
      spreadRadius: 2,
      child: const Center(
        child: Icon(
          Icons.lock_rounded,
          color: AppColors.primary,
          size: 36,
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.4, 0.4),
          end: const Offset(1.0, 1.0),
          duration: 550.ms,
          curve: Curves.elasticOut,
          delay: 80.ms,
        )
        .fadeIn(duration: 300.ms, delay: 80.ms);
  }
}

// ─── Headline ─────────────────────────────────────────────────────────────────

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.textPrimary, AppColors.primaryLight, AppColors.textPrimary],
        stops: [0.0, 0.55, 1.0],
      ).createShader(bounds),
      child: const Text(
        'Unlock Full Details',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          height: 1.1,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 450.ms, delay: 180.ms)
        .slideY(begin: 0.2, end: 0, duration: 380.ms, delay: 180.ms);
  }
}

// ─── Description ──────────────────────────────────────────────────────────────

class _Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'To view photos, exact location, and contact\nthe owner, you need an active premium subscription.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textMuted,
        fontSize: 13.5,
        height: 1.55,
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 250.ms);
  }
}

// ─── Join Premium button ──────────────────────────────────────────────────────

class _JoinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(const PremiumSubscriptionView());
      },
      child: GlowContainer(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        glowColor: AppColors.primary.withValues(alpha: 0.42),
        spreadRadius: 2,
        blurRadius: 22,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: Colors.black,
              size: 20,
            ),
            SizedBox(width: 10),
            Text(
              'Join Premium Now',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: AppFontsSize.smallFontSize,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 420.ms, delay: 420.ms)
        .slideY(begin: 0.15, end: 0, duration: 370.ms, delay: 420.ms);
  }
}

// ─── Maybe Later ─────────────────────────────────────────────────────────────

class _MaybeLater extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: Get.back,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        overlayColor: AppColors.textDim,
      ),
      child: const Text(
        'Maybe Later',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms, delay: 520.ms);
  }
}
