import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class AppInfoView extends StatefulWidget {
  const AppInfoView({super.key});

  @override
  State<AppInfoView> createState() => _AppInfoViewState();
}

class _AppInfoViewState extends State<AppInfoView> {
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
                        'app_info_title'.tr,
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
                        'about_dr_housing'.tr,
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroSection(version: version, isDarkMode: isDarkMode),
                    const SizedBox(height: 28),
                    _AboutSection(isDarkMode: isDarkMode),
                    const SizedBox(height: 24),
                    _FeaturesSection(isDarkMode: isDarkMode),
                    const SizedBox(height: 24),
                    _LegalSection(isDarkMode: isDarkMode),
                    const SizedBox(height: 28),
                    const _DeveloperSection(),
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
//  Hero Section
// ══════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final String version;
  final bool isDarkMode;

  const _HeroSection({required this.version, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 12),

          // ── Neon icon ──
          GlowContainer(
                height: 96,
                width: 96,
                color: isDarkMode ? AppColors.bgCard : Colors.white,
                borderRadius: BorderRadius.circular(26),
                glowColor: AppColors.primary.withValues(alpha: 0.42),
                spreadRadius: 2,
                blurRadius: 34,
                child: Center(
                  child: Image.asset(
                    AppImages.logo,
                    width: 100,
                    height: 100,
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 520.ms)
              .scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack),

          const SizedBox(height: 22),

          // ── App name ──
          Text(
                'Dr Housing',
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textPrimary
                      : AppColors.textBlack,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.12, curve: Curves.easeOut),

          const SizedBox(height: 8),

          // ── Tagline ──
          Text(
            'find_home_slogan'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
          ).animate().fadeIn(delay: 160.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // ── Version badge ──
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  'v$version',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 220.ms, duration: 400.ms)
              .scale(
                begin: const Offset(0.82, 0.82),
                curve: Curves.easeOut,
                delay: 220.ms,
              ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  About Section
// ══════════════════════════════════════════════════════════════

class _AboutSection extends StatelessWidget {
  final bool isDarkMode;
  const _AboutSection({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'about_the_app_title'.tr, isDarkMode: isDarkMode),
        const SizedBox(height: 12),
        Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: _cardDecoration(isDarkMode),
              child: Text(
                'about_the_app_body'.tr,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13.5,
                  height: 1.68,
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 280.ms, duration: 400.ms)
            .slideY(begin: 0.06, curve: Curves.easeOut, delay: 280.ms),
      ],
    ).animate().fadeIn(delay: 260.ms, duration: 350.ms);
  }
}

// ══════════════════════════════════════════════════════════════
//  Features Section
// ══════════════════════════════════════════════════════════════

class _FeaturesSection extends StatelessWidget {
  final bool isDarkMode;
  const _FeaturesSection({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final List _features = [
      (
        icon: Icons.home_work_rounded,
        title: 'feat_browse_title'.tr,
        description: 'feat_browse_desc'.tr,
      ),
      (
        icon: Icons.calendar_month_rounded,
        title: 'feat_book_title'.tr,
        description: 'feat_book_desc'.tr,
      ),
      (
        icon: Icons.favorite_rounded,
        title: 'feat_fav_title'.tr,
        description: 'feat_fav_desc'.tr,
      ),
      (
        icon: Icons.person_rounded,
        title: 'feat_profile_title'.tr,
        description: 'feat_profile_desc'.tr,
      ),
      (
        icon: Icons.workspace_premium_rounded,
        title: 'feat_premium_title'.tr,
        description: 'feat_premium_desc'.tr,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'what_you_can_do'.tr, isDarkMode: isDarkMode),
        const SizedBox(height: 12),
        Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
              decoration: _cardDecoration(isDarkMode),
              child: Column(
                children: _features.asMap().entries.map((e) {
                  return _FeatureItem(
                    icon: e.value.icon,
                    title: e.value.title,
                    description: e.value.description,
                    isLast: e.key == _features.length - 1,
                    delayMs: 360 + e.key * 65,
                    isDarkMode: isDarkMode,
                  );
                }).toList(),
              ),
            )
            .animate()
            .fadeIn(delay: 340.ms, duration: 400.ms)
            .slideY(begin: 0.06, curve: Curves.easeOut, delay: 340.ms),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;
  final int delayMs;
  final bool isDarkMode;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isLast,
    required this.delayMs,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.primaryBg
                          : AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 19),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: isDarkMode
                                ? AppColors.textPrimary
                                : AppColors.textBlack,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          description,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(
              delay: Duration(milliseconds: delayMs),
              duration: 360.ms,
            )
            .slideX(
              begin: 0.05,
              end: 0,
              delay: Duration(milliseconds: delayMs),
              duration: 310.ms,
              curve: Curves.easeOut,
            ),
        if (!isLast)
          Divider(
            color: isDarkMode ? AppColors.divider : AppColors.borderLight,
            height: 1,
          ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Legal Section
// ══════════════════════════════════════════════════════════════

class _LegalSection extends StatelessWidget {
  final bool isDarkMode;
  const _LegalSection({required this.isDarkMode});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: 'legal_title'.tr, isDarkMode: isDarkMode),
        const SizedBox(height: 12),
        Container(
              width: double.infinity,
              decoration: _cardDecoration(isDarkMode),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  children: [
                    _LegalRow(
                      icon: Icons.privacy_tip_outlined,
                      label: 'privacy_policy'.tr,
                      isDarkMode: isDarkMode,
                      onTap: () => _openUrl(
                        'https://drhousing-legal.vercel.app/privacy-policy',
                      ),
                    ),
                    Divider(
                      color: isDarkMode
                          ? AppColors.divider
                          : AppColors.borderLight,
                      height: 1,
                      indent: 56,
                    ),
                    _LegalRow(
                      icon: Icons.description_outlined,
                      label: 'terms_of_service'.tr,
                      isDarkMode: isDarkMode,
                      onTap: () =>
                          _openUrl('https://drhousing-legal.vercel.app/terms'),
                    ),
                    Divider(
                      color: isDarkMode
                          ? AppColors.divider
                          : AppColors.borderLight,
                      height: 1,
                      indent: 56,
                    ),
                    _LegalRow(
                      icon: Icons.article_outlined,
                      label: 'licenses'.tr,
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Get.to(
                          () => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Color(0xFFCCFF00),
                                onPrimary: Colors.black,
                                surface: Color(0xFF1E1E1E),
                                onSurface: Color(0xFFF5F5F5),
                              ),
                              scaffoldBackgroundColor: const Color(0xFF0F0F0F),
                              appBarTheme: const AppBarTheme(
                                backgroundColor: Color(0xFF0F0F0F),
                                foregroundColor: Color(0xFFF5F5F5),
                                elevation: 0,
                              ),
                              cardColor: const Color(0xFF1E1E1E),
                              dividerColor: const Color(0xFF2E2E2E),
                              textTheme: const TextTheme(
                                bodyMedium: TextStyle(color: Color(0xFF888888)),
                                bodyLarge: TextStyle(color: Color(0xFFF5F5F5)),
                              ),
                            ),
                            child: LicensePage(
                              applicationName: 'Dr Housing',
                              applicationVersion: '1.0.0',
                              applicationLegalese: 'copyright_text'.tr,
                              applicationIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Image.asset(
                                  AppImages.logo,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 580.ms, duration: 400.ms)
            .slideY(begin: 0.06, curve: Curves.easeOut, delay: 580.ms),
      ],
    );
  }
}

class _LegalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _LegalRow({
    required this.icon,
    required this.label,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.bgSurface
                    : AppColors.bgSurfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDarkMode ? AppColors.divider : AppColors.borderLight,
                ),
              ),
              child: Icon(icon, color: AppColors.textMuted, size: 16),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textPrimary
                      : AppColors.textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  Developer Section
// ══════════════════════════════════════════════════════════════

class _DeveloperSection extends StatelessWidget {
  const _DeveloperSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'built_with_love'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'solo_developer'.tr,
            style: TextStyle(color: AppColors.textDim, fontSize: 12),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 680.ms, duration: 400.ms);
  }
}

// ── Shared ─────────────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;
  const _SectionTitle({required this.title, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isDarkMode ? AppColors.textPrimary : AppColors.textBlack,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
    );
  }
}

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
