import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void showBookingBottomSheet(BuildContext context, ApartmentModel apartment) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BookingSheet(apartment: apartment),
  );
}

class _BookingSheet extends StatefulWidget {
  final ApartmentModel apartment;
  const _BookingSheet({required this.apartment});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  DateTime? selectedDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  bool isLoading = false;

  List<DateTime> get availableDates {
    final now = DateTime.now();
    return List.generate(14, (i) => now.add(Duration(days: i + 1)));
  }

  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  bool get _hasTimeError =>
      _fromTime != null &&
      _toTime != null &&
      _toMinutes(_toTime!) <= _toMinutes(_fromTime!);

  bool get canConfirm =>
      selectedDate != null &&
      _fromTime != null &&
      _toTime != null &&
      !_hasTimeError;

  String _dayName(DateTime date) =>
      ['mon'.tr, 'tue'.tr, 'wed'.tr, 'thu'.tr, 'fri'.tr, 'sat'.tr, 'sun'.tr][date.weekday - 1];

  String _monthName(DateTime date) => [
        'jan'.tr, 'feb'.tr, 'mar'.tr, 'apr'.tr, 'may'.tr, 'jun'.tr,
        'jul'.tr, 'aug'.tr, 'sep'.tr, 'oct'.tr, 'nov'.tr, 'dec'.tr
      ][date.month - 1];

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime({required bool isFrom}) async {
    final isDark = HelperFunctions.isDarkMode(context);
    final primary = HelperFunctions.getPrimary(context);

    final initial = isFrom
        ? (_fromTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (_toTime ?? const TimeOfDay(hour: 11, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: isDark
            ? ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                  primary: primary,
                  onPrimary: Colors.black,
                  surface: AppColors.bgSurface,
                  onSurface: AppColors.textPrimary,
                ),
                dialogTheme: const DialogThemeData(backgroundColor: AppColors.bgDark),
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: AppColors.bgDark,
                  dialHandColor: primary,
                  dialBackgroundColor: AppColors.bgCard,
                  entryModeIconColor: primary,
                  hourMinuteColor: AppColors.bgCard,
                  hourMinuteTextColor: AppColors.textPrimary,
                  dayPeriodColor: AppColors.bgCard,
                  dayPeriodTextColor: primary,
                ),
              )
            : ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: primary,
                  onPrimary: Colors.white,
                  surface: AppColors.bgLight,
                  onSurface: AppColors.textBlack,
                ),
              ),
        child: child!,
      ),
    );

    if (picked != null) {
      HapticFeedback.selectionClick();
      setState(() {
        if (isFrom) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
    }
  }

  Future<void> _confirm() async {
    if (!canConfirm) return;
    setState(() => isLoading = true);

    final bookingStart = DateTime(
      selectedDate!.year, selectedDate!.month, selectedDate!.day,
      _fromTime!.hour, _fromTime!.minute,
    );
    final bookingEnd = DateTime(
      selectedDate!.year, selectedDate!.month, selectedDate!.day,
      _toTime!.hour, _toTime!.minute,
    );

    final ctrl = Get.find<ApartmentController>();
    await ctrl.createBooking(
      apartment: widget.apartment,
      bookingDate: bookingStart,
      bookingEndTime: bookingEnd,
    );

    setState(() => isLoading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = HelperFunctions.isDarkMode(context);
    final primary = HelperFunctions.getPrimary(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDark : AppColors.bgLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drag handle ──────────────────────────────────────
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.divider : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.calendar_today_rounded, color: primary, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'book_a_viewing'.tr,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimary : AppColors.textBlack,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  widget.apartment.title,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Date label ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'select_date_label'.tr,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Horizontal date picker ────────────────────────────
          SizedBox(
            height: 78,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: availableDates.length,
              itemBuilder: (_, i) {
                final date = availableDates[i];
                final isSelected = selectedDate?.day == date.day &&
                    selectedDate?.month == date.month;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => selectedDate = date);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 56,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary
                          : (isDark ? AppColors.bgCard : AppColors.bgCardLight),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? primary
                            : (isDark ? AppColors.divider : AppColors.borderLight),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayName(date),
                          style: TextStyle(
                            color: isSelected ? Colors.black : AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : (isDark ? AppColors.textPrimary : AppColors.textBlack),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _monthName(date),
                          style: TextStyle(
                            color: isSelected ? Colors.black54 : AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ── Time label ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'select_time_label'.tr,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── From / To time pickers ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _TimePickerTile(
                    label: 'booking_from'.tr,
                    time: _fromTime != null ? _formatTime(_fromTime!) : null,
                    hasError: false,
                    onTap: () => _pickTime(isFrom: true),
                    isDark: isDark,
                    primary: primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimePickerTile(
                    label: 'booking_to'.tr,
                    time: _toTime != null ? _formatTime(_toTime!) : null,
                    hasError: _hasTimeError,
                    onTap: () => _pickTime(isFrom: false),
                    isDark: isDark,
                    primary: primary,
                  ),
                ),
              ],
            ),
          ),

          // ── Time error ────────────────────────────────────────
          if (_hasTimeError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
              child: Text(
                'invalid_time_range'.tr,
                style: const TextStyle(
                  color: AppColors.dangerColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(height: 28),

          // ── Confirm button ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GestureDetector(
              onTap: canConfirm && !isLoading ? _confirm : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: canConfirm
                      ? primary
                      : (isDark ? AppColors.bgCard : AppColors.bgSurfaceLight),
                  borderRadius: BorderRadius.circular(16),
                  border: canConfirm
                      ? null
                      : Border.all(color: isDark ? AppColors.divider : AppColors.borderLight),
                  boxShadow: canConfirm
                      ? [BoxShadow(color: primary.withValues(alpha: 0.35), blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 4))]
                      : [],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                        )
                      : Text(
                          canConfirm ? 'confirm_booking'.tr : 'select_date_time'.tr,
                          style: TextStyle(
                            color: canConfirm
                                ? Colors.black
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Time picker tile ───────────────────────────────────────────────────────────
class _TimePickerTile extends StatelessWidget {
  final String label;
  final String? time;
  final bool hasError;
  final VoidCallback onTap;
  final bool isDark;
  final Color primary;

  const _TimePickerTile({
    required this.label,
    required this.time,
    required this.hasError,
    required this.onTap,
    required this.isDark,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError
        ? AppColors.dangerColor
        : (time != null ? primary : (isDark ? AppColors.divider : AppColors.borderLight));
    final bgColor = hasError
        ? AppColors.dangerBg
        : (time != null
            ? primary.withValues(alpha: 0.1)
            : (isDark ? AppColors.bgCard : AppColors.bgCardLight));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: hasError ? AppColors.dangerColor : (time != null ? primary : AppColors.textMuted),
                ),
                const SizedBox(width: 6),
                Text(
                  time ?? '--:-- --',
                  style: TextStyle(
                    color: hasError
                        ? AppColors.dangerColor
                        : (time != null ? primary : AppColors.textMuted),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}