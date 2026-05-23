import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/modules/admin/bookings/view/admin_bookings_view.dart';
import 'package:apartment_rentals/modules/admin/dashboard/view/admin_dashboard_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/controller/profile_controller.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/change_theme/view/change_theme_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/edit_personal_info/view/edit_personal_info_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/manage_language/view/manage_language_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/app_info/view/app_info_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/app_version/view/app_version_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/my_subscription/view/my_subscription_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_profile/view/tenant_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    ProfileControllerImp controller = Get.put(ProfileControllerImp());
    UserController userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgDark : AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header bar ───────────────────────────────────────────────
              Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Text(
                      'profile_title'.tr,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppColors.textPrimary
                            : const Color(0xff1a1a1a),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: -0.1, curve: Curves.easeOut),

              // ── Avatar + name ────────────────────────────────────────────
              _buildProfileSection(userController, isDarkMode, context,),

              const SizedBox(height: 8),

              // ── ACCOUNT section ──────────────────────────────────────────
              _buildSectionLabel('account_section_label'.tr, delay: 350.ms),

              _buildMenuGroup(
                isDarkMode: isDarkMode,
                delay: 400.ms,
                items: [
                  _buildMenuItem(
                    context: context,
                    isDarkMode: isDarkMode,
                    icon: Icons.badge_outlined,
                    title: 'my_tenant_card'.tr,
                    subtitle: 'view_rental_resume'.tr,
                    delay: 420.ms,
                    onTap: () => Get.to(() => const TenantProfileView()),
                  ),
                  _buildMenuItem(
                    context: context,
                    isDarkMode: isDarkMode,
                    icon: Icons.workspace_premium_outlined,
                    title: 'my_subscriptions'.tr,
                    subtitle: userController.isPremium
                        ? 'sub_status_active'.tr
                        : 'sub_status_upgrade'.tr,
                    delay: 460.ms,
                    onTap: () => Get.to(() => const MySubscriptionView()),
                  ),
                ],
              ),

              // ── PREFERENCES section ──────────────────────────────────────
              _buildSectionLabel('preferences_section_label'.tr, delay: 500.ms),

              _buildMenuGroup(
                isDarkMode: isDarkMode,
                delay: 540.ms,
                items: [
                  _buildMenuItem(
                    context: context,
                    isDarkMode: isDarkMode,
                    icon: Icons.language_outlined,
                    title: 'manageLanguageAppBarTitle'.tr,
                    subtitle: switch (Get.locale?.languageCode) {
                      'ar' => 'العربية',
                      'nl' => 'Nederlands',
                      'fr' => 'Français',
                      _ => 'English',
                    },
                    delay: 560.ms,
                    onTap: () => Get.to(() => const ManageLanguageView()),
                  ),
                  _buildMenuItem(
                    context: context,
                    isDarkMode: isDarkMode,
                    icon: Icons.dark_mode_outlined,
                    title: 'visual_mode'.tr,
                    subtitle: isDarkMode
                        ? 'dark_mode_active'.tr
                        : 'light_mode_active'.tr,
                    delay: 600.ms,
                    onTap: () => Get.to(() => const ChangeThemeView()),
                  ),
                  _buildMenuItem(
                    context: context,
                    isDarkMode: isDarkMode,
                    icon: Icons.info_outline_rounded,
                    title: 'app_info'.tr,
                    subtitle: 'about_and_legal'.tr,
                    delay: 640.ms,
                    onTap: () => Get.to(() => const AppInfoView()),
                  ),
                  _buildMenuItem(
                    context: context,
                    isDarkMode: isDarkMode,
                    icon: Icons.system_update_outlined,
                    title: 'app_version'.tr,
                    subtitle: 'version_up_to_date'.tr,
                    delay: 680.ms,
                    onTap: () => Get.to(() => const AppVersionView()),
                  ),
                ],
              ),

              // ── ADMIN section (manager / super_admin only) ───────────────
              Obx(() {
                if (!userController.isManager) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('admin_section_label'.tr, delay: 720.ms),
                    _buildMenuGroup(
                      isDarkMode: isDarkMode,
                      delay: 760.ms,
                      items: [
                        if (userController.isSuperAdmin)
                          _buildMenuItem(
                            context: context,
                            isDarkMode: isDarkMode,
                            icon: Icons.dashboard_outlined,
                            title: 'admin_dashboard_title'.tr,
                            subtitle: 'admin_dashboard_subtitle'.tr,
                            delay: 780.ms,
                            onTap: () =>
                                Get.to(() => const AdminDashboardView()),
                          ),
                        _buildMenuItem(
                          context: context,
                          isDarkMode: isDarkMode,
                          icon: Icons.calendar_month_outlined,
                          title: 'admin_bookings_title'.tr,
                          subtitle: 'admin_bookings_subtitle'.tr,
                          delay: 820.ms,
                          onTap: () => Get.to(() => const AdminBookingsView()),
                        ),
                      ],
                    ),
                  ],
                );
              }),

              // ── Sign out ─────────────────────────────────────────────────
              _buildSignOutButton(controller, isDarkMode),

              // ── Delete account ───────────────────────────────────────────
              _buildDeleteAccountButton(controller, isDarkMode),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserController userController, bool isDarkMode,BuildContext context) {
    bool isPremium = userController.isPremium;
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        child: Row(
          children: [
            // ── Avatar ───────────────────────────────────────────────────
            Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: HelperFunctions.getPrimary(context), width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? AppColors.bgCard : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          HelperFunctions().getInitials(
                            userController.displayName,
                          ),
                          style:  TextStyle(
                            color: HelperFunctions.getPrimary(context),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 150.ms, duration: 500.ms)
                .scale(
                  begin: const Offset(0.75, 0.75),
                  curve: Curves.easeOutBack,
                ),

            const SizedBox(width: 16),

            // ── Name + email + badge ─────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                        userController.displayName,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textPrimary
                              : const Color(0xff1a1a1a),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 220.ms, duration: 400.ms)
                      .slideX(begin: 0.08, curve: Curves.easeOut),

                  const SizedBox(height: 3),

                  Text(
                        userController.email,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 260.ms, duration: 400.ms)
                      .slideX(begin: 0.08, curve: Curves.easeOut),

                  const SizedBox(height: 10),

                  Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? isPremium
                                    ? AppColors.primaryBg
                                    : AppColors.dangerBg
                              : isPremium
                              ? AppColors.primaryBg
                              : AppColors.dangerColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isPremium
                                ? HelperFunctions.getPrimary(context)
                                : AppColors.dangerColor,
                            width: isPremium ? 1 : 0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPremium
                                  ? Icons.workspace_premium_rounded
                                  : Icons.person_outline_rounded,
                              color: isPremium
                                  ? HelperFunctions.getPrimary(context)
                                  : AppColors.dangerColor,
                              size: 12,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isPremium ? 'premium_badge'.tr : 'basic_badge'.tr,
                              style: TextStyle(
                                color: isPremium
                                    ? HelperFunctions.getPrimary(context)
                                    : AppColors.dangerColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideX(begin: 0.08, curve: Curves.easeOut),
                ],
              ),
            ),

            // ── Edit button ──────────────────────────────────────────────
            GestureDetector(
                  onTap: () => Get.to(() => const EditPersonalInfoView()),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.bgCard : Colors.white,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.divider
                            : const Color(0xffE0E0E0),
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: AppColors.textMuted,
                      size: 16,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 320.ms, duration: 400.ms)
                .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),
          ],
        ),
      );
    });
  }

  Widget _buildSectionLabel(String label, {required Duration delay}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
    ).animate().fadeIn(delay: delay, duration: 350.ms);
  }

  Widget _buildMenuGroup({
    required List<Widget> items,
    required Duration delay,
    required bool isDarkMode,
  }) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.bgCard : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? AppColors.divider : const Color(0xffE8E8E8),
              ),
              boxShadow: isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(children: items),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideY(begin: 0.05, curve: Curves.easeOut);
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDarkMode,
    String? subtitle,
    bool isSecondary = false,
    required Duration delay,
    VoidCallback? onTap,
    required BuildContext context
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isDarkMode ? AppColors.divider : const Color(0xffEEEEEE),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // ── Icon container ───────────────────────────────────────────
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isSecondary ? Colors.transparent : AppColors.primaryBg,
                borderRadius: BorderRadius.circular(10),
                border: isSecondary
                    ? Border.all(
                        color: isDarkMode
                            ? AppColors.divider
                            : const Color(0xffE0E0E0),
                      )
                    : null,
              ),
              child: Icon(
                icon,
                color: isSecondary ? AppColors.textMuted : HelperFunctions.getPrimary(context),
                size: 17,
              ),
            ),

            const SizedBox(width: 14),

            // ── Text ─────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSecondary
                          ? AppColors.textMuted
                          : (isDarkMode
                                ? AppColors.textPrimary
                                : const Color(0xff1a1a1a)),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // ── Chevron ──────────────────────────────────────────────────
            Icon(
              Icons.chevron_right_rounded,
              color: isSecondary ? AppColors.textDim : AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(
    ProfileControllerImp controller,
    bool isDarkMode,
  ) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: GestureDetector(
            onTap: controller.confirmAndDeleteAccount,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.dangerColor.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.dangerIconBg
                          : AppColors.dangerColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: AppColors.dangerColor,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'delete_account_title'.tr,
                          style: const TextStyle(
                            color: AppColors.dangerColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'delete_account_subtitle'.tr,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 750.ms, duration: 400.ms)
        .slideY(begin: 0.06, curve: Curves.easeOut);
  }

  Widget _buildSignOutButton(ProfileControllerImp controller, bool isDarkMode) {
    return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: GestureDetector(
            onTap: controller.signOut,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.dangerBg
                    : AppColors.dangerColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.dangerColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.dangerIconBg
                          : AppColors.dangerColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.dangerColor,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'sign_out'.tr,
                    style: const TextStyle(
                      color: AppColors.dangerColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 700.ms, duration: 400.ms)
        .slideY(begin: 0.06, curve: Curves.easeOut);
  }
}
