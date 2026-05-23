import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/modules/admin/apartment_form/view/apartment_form_view.dart';
import 'package:apartment_rentals/modules/admin/bookings/view/admin_bookings_view.dart';
import 'package:apartment_rentals/modules/admin/dashboard/controller/admin_dashboard_controller.dart';
import 'package:apartment_rentals/modules/admin/users/view/admin_users_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AdminDashboardController());
    final userCtrl = Get.find<UserController>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.bgCard,
          onRefresh: ctrl.fetchStats,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 20),

              // ── Header ────────────────────────────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'admin_dashboard_title'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Obx(
                        () => Text(
                          userCtrl.displayName,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Role badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      'admin_role_super'.tr,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 350.ms),

              const SizedBox(height: 28),

              // ── Stats grid ────────────────────────────────────────────────
              Text(
                'admin_overview_label'.tr,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 12),

              Obx(
                () => ctrl.isLoading.value
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  icon: Iconsax.building,
                                  label: 'admin_stat_apartments'.tr,
                                  value: ctrl.totalApartments.value,
                                  color: HelperFunctions.getPrimary(context),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  icon: Iconsax.calendar,
                                  label: 'admin_stat_bookings'.tr,
                                  value: ctrl.totalBookings.value,
                                  color: const Color(0xFF64B5F6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  icon: Iconsax.people,
                                  label: 'admin_stat_users'.tr,
                                  value: ctrl.totalUsers.value,
                                  color: const Color(0xFFBA68C8),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  icon: Iconsax.clock,
                                  label: 'admin_stat_pending'.tr,
                                  value: ctrl.pendingBookings.value,
                                  color: const Color(0xFFFFA726),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

              const SizedBox(height: 28),

              // ── Management links ──────────────────────────────────────────
              Text(
                'admin_management_label'.tr,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ).animate().fadeIn(delay: 250.ms),
              const SizedBox(height: 12),

              _NavCard(
                icon: Iconsax.calendar_tick,
                title: 'admin_bookings_title'.tr,
                subtitle: 'admin_bookings_subtitle'.tr,
                delay: 300.ms,
                onTap: () => Get.to(() => const AdminBookingsView()),
              ),
              _NavCard(
                icon: Iconsax.add_square,
                title: 'admin_add_apartment'.tr,
                subtitle: 'admin_add_apartment_subtitle'.tr,
                delay: 360.ms,
                onTap: () => Get.to(() => const ApartmentFormView()),
              ),
              _NavCard(
                icon: Iconsax.people,
                title: 'admin_users_title'.tr,
                subtitle: 'admin_users_subtitle'.tr,
                delay: 420.ms,
                onTap: () => Get.to(() => const AdminUsersView()),
              ),

              const SizedBox(height: 28),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.bgCard : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.divider : Colors.grey[400]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Nav card ──────────────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.delay,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Duration delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.bgCard : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? AppColors.divider : Colors.grey[400]!,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: delay, duration: 380.ms)
        .slideY(begin: 0.06, curve: Curves.easeOut);
  }
}
