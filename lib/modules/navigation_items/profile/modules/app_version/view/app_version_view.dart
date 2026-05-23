import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class AppVersionView extends StatefulWidget {
  const AppVersionView({super.key});

  @override
  State<AppVersionView> createState() => _AppVersionViewState();
}

class _AppVersionViewState extends State<AppVersionView> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((v) {
      if (mounted) setState(() => _info = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    final String version = _info?.version ?? '1.0.0';
    final String build = _info?.buildNumber ?? '1';
    final String platform = kIsWeb
        ? 'Web'
        : defaultTargetPlatform == TargetPlatform.android
        ? 'Android'
        : 'iOS';

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
                        'app_version_title'.tr,
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
                        'app_version_subtitle'.tr,
                        style: TextStyle(
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                child: Column(
                  children: [
                    _AnimatedAppIcon(isDarkMode: isDarkMode),
                    const SizedBox(height: 20),

                    // ── App name ──
                    Text(
                          'Dr Housing',
                          style: GoogleFonts.cormorantGaramond(
                            color: const Color(0xffD4AF37),
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 120.ms, duration: 400.ms)
                        .slideY(
                          begin: 0.12,
                          curve: Curves.easeOut,
                          delay: 120.ms,
                        ),

                    const SizedBox(height: 28),

                    _VersionInfoCard(
                      version: version,
                      buildNumber: build,
                      platform: platform,
                      isDarkMode: isDarkMode,
                    ),

                    const SizedBox(height: 24),
                    _ChangelogSection(
                      privileges: [
                        (
                          icon: Icons.rocket_launch_rounded,
                          text: 'release_initial'.tr,
                        ),
                        (
                          icon: Icons.manage_search_rounded,
                          text: 'release_browse'.tr,
                        ),
                        (
                          icon: Icons.event_note_rounded,
                          text: 'release_bookings'.tr,
                        ),
                        (icon: Icons.stars_rounded, text: 'release_premium'.tr),
                        (
                          icon: Icons.account_circle_rounded,
                          text: 'release_favorites'.tr,
                        ),
                      ],
                      version: version,
                    ),

                    const SizedBox(height: 28),

                    const _UpToDateBadge(),
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

// ══════════════════════════════════════════════════════════════
//  Animated App Icon (pulse loop + entrance)
// ══════════════════════════════════════════════════════════════

class _AnimatedAppIcon extends StatefulWidget {
  final bool isDarkMode;
  const _AnimatedAppIcon({required this.isDarkMode});

  @override
  State<_AnimatedAppIcon> createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<_AnimatedAppIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.07,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
          scale: _scaleAnim,
          child: GlowContainer(
            height: 100,
            width: 100,
            color: widget.isDarkMode ? AppColors.bgCard : Colors.white,
            borderRadius: BorderRadius.circular(28),
            glowColor: HelperFunctions.getPrimary(context).withValues(alpha: 0.46),
            spreadRadius: 3,
            blurRadius: 38,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  AppImages.logo,
                  width: 104,
                  height: 104,
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 520.ms)
        .scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack);
  }
}

// ══════════════════════════════════════════════════════════════
//  Version Info Card
// ══════════════════════════════════════════════════════════════

class _VersionInfoCard extends StatelessWidget {
  final String version;
  final String buildNumber;
  final String platform;
  final bool isDarkMode;

  const _VersionInfoCard({
    required this.version,
    required this.buildNumber,
    required this.platform,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(isDarkMode),
          child: Column(
            children: [
              _InfoRow(
                label: 'version_label'.tr,
                value: version,
                isDarkMode: isDarkMode,
              ),
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 24,
              ),
              _InfoRow(
                label: 'build_number_label'.tr,
                value: buildNumber,
                isDarkMode: isDarkMode,
              ),
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 24,
              ),
              _InfoRow(
                label: 'platform_label'.tr,
                value: platform,
                isDarkMode: isDarkMode,
              ),
              Divider(
                color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                height: 24,
              ),
              _InfoRow(
                label: 'release_date_label'.tr,
                value: 'release_month_year'.tr,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 420.ms)
        .slideY(begin: 0.06, curve: Curves.easeOut, delay: 200.ms);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDarkMode;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Changelog Section
// ══════════════════════════════════════════════════════════════
class _ChangelogSection extends StatelessWidget {
  final List<({IconData icon, String text})> privileges;
  final String version;
  const _ChangelogSection({required this.privileges, required this.version});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'whats_new'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: HelperFunctions.getPrimary(context).withValues(alpha: 0.40),
                    ),
                  ),
                  child: Text(
                    'v$version',
                    style:  TextStyle(
                      color: HelperFunctions.getPrimary(context),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 360.ms, duration: 400.ms),
            const SizedBox(height: 12),
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
                    child: Icon(
                      Icons.check_rounded,
                      color: HelperFunctions.getPrimary(context),
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

// ══════════════════════════════════════════════════════════════
//  Up To Date Badge
// ══════════════════════════════════════════════════════════════

class _UpToDateBadge extends StatelessWidget {
  const _UpToDateBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.primaryBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: HelperFunctions.getPrimary(context).withValues(alpha: 0.36),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(
                Icons.check_circle_rounded,
                color: HelperFunctions.getPrimary(context),
                size: 18,
              ),
              const SizedBox(width: 9),
              Text(
                kIsWeb ? 'web_latest_version'.tr : 'up_to_date_msg'.tr,
                style:  TextStyle(
                  color: HelperFunctions.getPrimary(context),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 720.ms, duration: 400.ms)
        .scale(
          begin: const Offset(0.88, 0.88),
          curve: Curves.easeOutBack,
          delay: 720.ms,
        );
  }
}
// ── Shared ─────────────────────────────────────────────────────────────────────

BoxDecoration _cardDecoration(bool isDarkMode) {
  return BoxDecoration(
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
  );
}
