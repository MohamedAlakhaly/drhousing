import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/static/admin_booking_model.dart';
import 'package:apartment_rentals/modules/admin/bookings/controller/admin_bookings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
// ── Date/time helpers ─────────────────────────────────────────────────────────

String _fmtDate(DateTime dt) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String _fmtTime(DateTime dt) {
  final h = dt.hour;
  final m = dt.minute.toString().padLeft(2, '0');
  final isPM = h >= 12;
  final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$displayH:$m ${isPM ? 'PM' : 'AM'}';
}

Color _statusColor(String s) => switch (s) {
  'confirmed' => AppColors.primary,
  'cancelled' => AppColors.dangerColor,
  _ => const Color(0xFFFFA726),
};

Color _statusBg(String s) => switch (s) {
  'confirmed' => AppColors.primaryBg,
  'cancelled' => AppColors.dangerBg,
  _ => const Color(0x1AFFA726),
};

// ── Root view ─────────────────────────────────────────────────────────────────

class AdminBookingsView extends StatelessWidget {
  const AdminBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AdminBookingsController());

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
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
                        'admin_bookings_title'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'admin_bookings_subtitle'.tr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: ctrl.fetchBookings,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Iconsax.refresh,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.1),

            // ── Filter chips ─────────────────────────────────────────────────
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: ctrl.filters.map((f) {
                    final selected = ctrl.selectedFilter.value == f;
                    const expiredColor = Color(0xFFFF6B35);
                    final activeColor = f == 'expired'
                        ? expiredColor
                        : AppColors.primary;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ctrl.selectedFilter.value = f;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? activeColor : AppColors.bgCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? activeColor : AppColors.divider,
                          ),
                        ),
                        child: Text(
                          'admin_filter_$f'.tr,
                          style: TextStyle(
                            color: selected
                                ? Colors.black
                                : AppColors.textMuted,
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 350.ms),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return _SkeletonList();
                }

                if (ctrl.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.wifi_off_rounded,
                          color: AppColors.textMuted,
                          size: 44,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ctrl.errorMessage.value,
                          style: const TextStyle(color: AppColors.textMuted),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: ctrl.fetchBookings,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'retryButton'.tr,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final list = ctrl.filteredBookings;

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.calendar,
                          color: AppColors.textMuted,
                          size: 44,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'admin_no_bookings'.tr,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.bgCard,
                  onRefresh: ctrl.fetchBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _BookingRow(
                      booking: list[i],
                      controller: ctrl,
                      index: i,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Booking row ───────────────────────────────────────────────────────────────

class _BookingRow extends StatelessWidget {
  const _BookingRow({
    required this.booking,
    required this.controller,
    required this.index,
  });

  final AdminBookingModel booking;
  final AdminBookingsController controller;
  final int index;

  void _showActions(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.bgCard : Colors.grey[300],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              booking.tenantName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              booking.tenantEmail,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            if (booking.tenantPhone != null) ...[
              const SizedBox(height: 2),
              Text(
                booking.tenantPhone!,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 20),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 16),
            if (booking.status.value == 'pending')
              _ActionButton(
                icon: Icons.check_circle_outline_rounded,
                label: 'admin_mark_complete'.tr,
                color: AppColors.primary,
                onTap: () {
                  Get.back();
                  controller.markComplete(booking);
                },
              ),
            const SizedBox(height: 10),
            if (booking.status.value == 'confirmed') ...[
              const SizedBox(height: 10),
              _ActionButton(
                icon: Icons.access_time_filled_rounded,
                label: 'admin_mark_expired'.tr,
                color: const Color(0xFFFF6B35),
                onTap: () {
                  Get.back();
                  controller.markExpired(booking);
                },
              ),
            ],
            const SizedBox(height: 10),
            _ActionButton(
              icon: Icons.delete_outline_rounded,
              label: 'admin_delete_booking'.tr,
              color: AppColors.dangerColor,
              onTap: () {
                Get.back();
                controller.deleteBooking(booking);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return Obx(() {
      final status = booking.status.value;
      final sColor = _statusColor(status);
      final sBg = _statusBg(status);
      final isExpired =
          booking.bookingDate.isBefore(DateTime.now()) && status == 'pending';

      return GestureDetector(
            onTap: () => _showActions(context),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.bgCard : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? AppColors.divider : Colors.grey[400]!,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Status bar
                      Container(width: 4, color: sColor),

                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Top row: apartment + badge ──────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      booking.apartmentTitle.isEmpty
                                          ? '—'
                                          : booking.apartmentTitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: sBg,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: sColor.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      'status_$status'.tr,
                                      style: TextStyle(
                                        color: sColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              if (isExpired) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x1AFF6B35),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFFF6B35,
                                      ).withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Color(0xFFFF6B35),
                                        size: 10,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'admin_tab_expired'.tr,
                                        style: const TextStyle(
                                          color: Color(0xFFFF6B35),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 10),

                              // ── Tenant info ──────────────────────────────────
                              _InfoRow(
                                icon: Iconsax.user,
                                text: booking.tenantName,
                              ),
                              const SizedBox(height: 4),
                              _InfoRow(
                                icon: Iconsax.sms,
                                text: booking.tenantEmail,
                              ),
                              if (booking.tenantPhone != null) ...[
                                const SizedBox(height: 4),
                                _InfoRow(
                                  icon: Iconsax.call,
                                  text: booking.tenantPhone!,
                                ),
                              ],

                              const SizedBox(height: 10),

                              // ── Date / time ──────────────────────────────────
                              Row(
                                children: [
                                  const Icon(
                                    Iconsax.calendar_1,
                                    color: AppColors.textMuted,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _fmtDate(booking.bookingDate),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Iconsax.clock,
                                    color: AppColors.textMuted,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _fmtTime(booking.bookingDate),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (booking.bookingEndTime != null) ...[
                                    const Text(
                                      ' → ',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      _fmtTime(booking.bookingEndTime!),
                                      style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tap hint
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Center(
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.textDim,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: 100 + (index * 60)),
            duration: 400.ms,
          )
          .slideY(begin: 0.08, curve: Curves.easeOut);
    });
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: HelperFunctions.getPrimary(context), size: 12),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: 5,
      itemBuilder: (_, index) => Shimmer.fromColors(
        baseColor: isDark ? AppColors.bgCard : AppColors.bgSurfaceLight,
        highlightColor: isDark
            ? const Color(0xFF2A2A2A)
            : AppColors.borderLight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 130,
          decoration: BoxDecoration(
            color: isDark ? AppColors.bgCard : AppColors.bgCardLight,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
