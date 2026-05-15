import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_state.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/static/booking_model.dart';
import 'package:apartment_rentals/modules/navigation_items/bookings/controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

// ── Date / time formatters ────────────────────────────────────────────────────

String _formatDate(DateTime dt) {
  final months = [
    'jan'.tr, 'feb'.tr, 'mar'.tr, 'apr'.tr,
    'may'.tr, 'jun'.tr, 'jul'.tr, 'aug'.tr,
    'sep'.tr, 'oct'.tr, 'nov'.tr, 'dec'.tr,
  ];
  final days = [
    'mon'.tr, 'tue'.tr, 'wed'.tr, 'thu'.tr,
    'fri'.tr, 'sat'.tr, 'sun'.tr,
  ];
  return '${days[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
}

String _formatTime(DateTime dt) {
  final h = dt.hour;
  final m = dt.minute.toString().padLeft(2, '0');
  final isPM = h >= 12;
  final displayH = h == 0 ? 12 : (h > 12 ? h - 12 : h);
  return '$displayH:$m ${isPM ? 'pm'.tr : 'am'.tr}';
}

// ── Status color helpers ──────────────────────────────────────────────────────

Color _statusColor(String status) => switch (status) {
  'confirmed' => AppColors.primary,
  'cancelled' => AppColors.dangerColor,
  _ => const Color(0xFFFFA726), // pending → amber
};

Color _statusBgColor(String status) => switch (status) {
  'confirmed' => AppColors.primaryBg,
  'cancelled' => AppColors.dangerBg,
  _ => const Color(0x1AFFA726),
};

// ── Root view ─────────────────────────────────────────────────────────────────

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'booking_view_title'.tr,
                        style: TextStyle(
                          color: isDarkMode
                              ? AppColors.textPrimary
                              : AppColors.textBlack,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'booking_view_description'.tr,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: controller.fetchBookings,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDarkMode ? AppColors.bgCard : AppColors.bgGrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Iconsax.refresh,
                        color: isDarkMode
                            ? AppColors.textMuted
                            : AppColors.textBlack,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

            // ── Filter chips ─────────────────────────────────────────────────
            // في الـ view
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children:
                      [
                            (BookingFilter.all, 'booking_view_tab_all'.tr),
                            (
                              BookingFilter.pending,
                              'booking_view_tab_pending'.tr,
                            ),
                            (
                              BookingFilter.cancelled,
                              'booking_view_tab_cancelled'.tr,
                            ),
                            (
                              BookingFilter.confirmed,
                              'booking_view_tab_confirmed'.tr,
                            ),
                          ]
                          .map(
                            (item) => _FilterTab(
                              isDarkMode: isDarkMode,
                              label: item.$2,
                              isSelected:
                                  controller.selectedFilter.value == item.$1,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                controller.selectedFilter.value = item.$1;
                              },
                            ),
                          )
                          .toList(),
                ),
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: 4,
                    itemBuilder: (_, index) =>
                        _SkeletonCard(isDarkMode: isDarkMode),
                  );
                }

                if (controller.hasError) {
                  return _ErrorState(
                    message: controller.errorMessage.value,
                    onRetry: controller.fetchBookings,
                    isDarkMode: isDarkMode,
                  );
                }

                final filtered = controller.filteredBookings;

                if (filtered.isEmpty) {
                  return _EmptyState(
                    isDarkMode: isDarkMode,
                    hasFilter: controller.selectedFilter.value !=  BookingFilter.all,
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: isDarkMode ? AppColors.bgCard : Colors.white,
                  onRefresh: controller.fetchBookings,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _BookingCard(
                      booking: filtered[index],
                      controller: controller,
                      isDarkMode: isDarkMode,
                      index: index,
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

// ── Filter tab ────────────────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  const _FilterTab({
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDarkMode ? AppColors.bgCard : AppColors.bgGrey),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDarkMode ? AppColors.divider : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : AppColors.textMuted,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ── Skeleton loading card ─────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? AppColors.bgCard : AppColors.bgSurfaceLight,
      highlightColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 148,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.bgCard : AppColors.bgCardLight,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDarkMode, this.hasFilter = false});

  final bool isDarkMode;
  final bool hasFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.bgCard : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                    ),
                    child: const Icon(
                      Iconsax.calendar,
                      color: AppColors.textMuted,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    hasFilter ? 'booking_view_empty_state_filter_title'.tr : 'booking_view_empty_state_no_filter_content'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasFilter
                        ? 'booking_view_empty_state_filter_content'.tr
                        : 'booking_view_empty_state_no_filter_content'.tr,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (!hasFilter) ...[
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => AppState.currentIndex.value = 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.80),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.home, color: Colors.black, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'booking_view_browse_properties'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .scale(begin: const Offset(0.9, 0.9)),
    );
  }
}

// ── Error state ───────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.isDarkMode,
  });

  final String message;
  final VoidCallback onRetry;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: isDarkMode ? AppColors.bgCard : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isDarkMode
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 14,
                              ),
                            ],
                    ),
                    child: const Icon(
                      Icons.wifi_off_rounded,
                      color: AppColors.textMuted,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'booking_view_error_state_title'.tr,
                    style: TextStyle(
                      color: isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'booking_view_error_state_content'.tr,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 22),
                  GestureDetector(
                    onTap: onRetry,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        'try_again_button'.tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(duration: 400.ms)
              .scale(begin: const Offset(0.92, 0.92)),
    );
  }
}

// ── Booking card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.controller,
    required this.isDarkMode,
    required this.index,
  });

  final BookingModel booking;
  final BookingController controller;
  final bool isDarkMode;
  final int index;

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.bgSurface
                      : AppColors.bgSurfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.divider
                        : AppColors.borderLight,
                  ),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.textMuted,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'delete_booking_button'.tr,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textPrimary
                      : AppColors.textBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                'delete_booking_message'.tr,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.bgSurface
                              : AppColors.bgSurfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.divider
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'keep_button'.tr,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.textPrimary
                                  : AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        controller.deleteBooking(booking);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.dangerColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dangerColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'delete_button'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.bgCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? AppColors.divider : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.dangerColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.dangerColor.withValues(alpha: 0.35),
                  ),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.dangerColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'cancel_booking_button'.tr,
                style: TextStyle(
                  color: isDarkMode
                      ? AppColors.textPrimary
                      : AppColors.textBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'cancel_booking_message'.tr,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.bgSurface
                              : AppColors.bgSurfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.divider
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'keep_button'.tr,
                            style: TextStyle(
                              color: isDarkMode
                                  ? AppColors.textPrimary
                                  : AppColors.textBlack,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        controller.cancelBooking(booking);
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.dangerColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dangerColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'confirm_cancel_button'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final apartment = booking.apartment;

    return Obx(() {
      final status = booking.status.value;
      final accentColor = _statusColor(status);
      final accentBg = _statusBgColor(status);

      return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 14,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left accent bar — colour = booking status
                    Container(width: 5, color: accentColor),

                    // Card body
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Title row ────────────────────────────────────────
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: accentBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Iconsax.calendar,
                                    color: accentColor,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        apartment?.title ?? 'Apartment',
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? AppColors.textPrimary
                                              : AppColors.textBlack,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          height: 1.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: AppColors.textMuted,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              apartment?.address ?? '—',
                                              style: const TextStyle(
                                                color: AppColors.textMuted,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _StatusBadge(status: status),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // ── Date + time pill ──────────────────────────────────
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.bgSurface
                                    : AppColors.bgSurfaceLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Date row
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Iconsax.calendar_1,
                                        color: AppColors.textMuted,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatDate(booking.bookingDate),
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? AppColors.textPrimary
                                              : AppColors.textBlack,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  // Time range row
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Iconsax.clock,
                                        color: AppColors.textMuted,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatTime(booking.bookingDate),
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? AppColors.textPrimary
                                              : AppColors.textBlack,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if (booking.bookingEndTime != null) ...[
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6),
                                          child: Text(
                                            '→',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _formatTime(booking.bookingEndTime!),
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? AppColors.textPrimary
                                                : AppColors.textBlack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ── Cancel button (pending only) ──────────────────────
                            if (status == 'pending') ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () => _showCancelDialog(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.dangerColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppColors.dangerColor.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.close_rounded,
                                          color: AppColors.dangerColor,
                                          size: 13,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'cancel_booking_button'.tr,
                                          style: TextStyle(
                                            color: AppColors.dangerColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            // ── Delete button (cancelled or confirmed) ────────────
                            if (status == 'cancelled' ||
                                status == 'confirmed') ...[
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () => _showDeleteDialog(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? AppColors.bgSurface
                                          : AppColors.bgSurfaceLight,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isDarkMode
                                            ? AppColors.divider
                                            : AppColors.borderLight,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.textMuted,
                                          size: 13,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'delete_button'.tr,
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: 200 + (index * 100)),
            duration: 500.ms,
          )
          .slideY(begin: 0.12, curve: Curves.easeOut);
    });
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final bg = _statusBgColor(status);
    final label = switch (status) {
      'confirmed' => 'status_confirmed'.tr,
      'cancelled' => 'status_cancelled'.tr,
      _ => 'status_pending'.tr,
    };
    final icon = switch (status) {
      'confirmed' => Icons.check_circle_rounded,
      'cancelled' => Icons.cancel_rounded,
      _ => Icons.access_time_rounded,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 11),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
