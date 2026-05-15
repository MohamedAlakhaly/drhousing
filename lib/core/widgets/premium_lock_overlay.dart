import 'dart:ui';

import 'package:apartment_rentals/core/widgets/paywall_bottom_sheet.dart';
import 'package:flutter/material.dart';

class PremiumLockOverlay extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;

  const PremiumLockOverlay({
    super.key,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final clip = borderRadius ?? BorderRadius.zero;

    return GestureDetector(
      onTap: () => showPaywallBottomSheet(context),
      child: ClipRRect(
        borderRadius: clip,
        child: Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: child,
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.30),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LockBadge(),
                    SizedBox(height: 10),
                    Text(
                      'Premium Only',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

class _LockBadge extends StatelessWidget {
  const _LockBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFc9f14e),
          width: 1.5,
        ),
      ),
      child: const Icon(
        Icons.lock_rounded,
        color: Color(0xFFc9f14e),
        size: 26,
      ),
    );
  }
}
