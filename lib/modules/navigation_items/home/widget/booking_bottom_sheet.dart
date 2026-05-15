import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// ── Colors ────────────────────────────────────────────────────
const _bg = Color(0xFF121212);
const _surface = Color(0xFF1E1E1E);
const _card = Color(0xFF2A2A2A);
const _neon = Color(0xFFCCFF00);
const _neonDim = Color(0x33CCFF00);
const _textPrimary = Color(0xFFF5F5F5);
const _textMuted = Color(0xFF888888);
const _divider = Color(0xFF2E2E2E);
const _danger = Color(0xFFE24B4A);

// ── Entry point ───────────────────────────────────────────────
void showBookingBottomSheet(BuildContext context, ApartmentModel apartment) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BookingSheet(apartment: apartment),
  );
}

// ── Sheet widget ──────────────────────────────────────────────
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
    final initial = isFrom
        ? (_fromTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (_toTime ?? const TimeOfDay(hour: 11, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _neon,
            onPrimary: Colors.black,
            surface: _surface,
            onSurface: _textPrimary,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: _bg),
          timePickerTheme: const TimePickerThemeData(
            backgroundColor: _bg,
            dialHandColor: _neon,
            dialBackgroundColor: _card,
            entryModeIconColor: _neon,
            hourMinuteColor: _card,
            hourMinuteTextColor: _textPrimary,
            dayPeriodColor: _card,
            dayPeriodTextColor: _neon,
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
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      _fromTime!.hour,
      _fromTime!.minute,
    );

    final bookingEnd = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      _toTime!.hour,
      _toTime!.minute,
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
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                color: _divider,
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
                        color: _neonDim,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        color: _neon,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'book_a_viewing'.tr,
                      style: const TextStyle(
                        color: _textPrimary,
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
                  style: const TextStyle(
                    color: _textMuted,
                    fontSize: 13,
                  ),
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
                color: _textMuted,
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
                      color: isSelected ? _neon : _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? _neon : _divider,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _dayName(date),
                          style: TextStyle(
                            color: isSelected ? Colors.black : _textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected ? Colors.black : _textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _monthName(date),
                          style: TextStyle(
                            color: isSelected ? Colors.black54 : _textMuted,
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
                color: _textMuted,
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
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TimePickerTile(
                    label: 'booking_to'.tr,
                    time: _toTime != null ? _formatTime(_toTime!) : null,
                    hasError: _hasTimeError,
                    onTap: () => _pickTime(isFrom: false),
                  ),
                ),
              ],
            ),
          ),

          // ── Inline time error ─────────────────────────────────
          if (_hasTimeError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
              child: Text(
                'invalid_time_range'.tr,
                style: const TextStyle(
                  color: _danger,
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
                  color: canConfirm ? _neon : _card,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: canConfirm
                      ? [
                          BoxShadow(
                            color: _neon.withValues(alpha: 0.35),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          canConfirm
                              ? 'confirm_booking'.tr
                              : 'select_date_time'.tr,
                          style: TextStyle(
                            color: canConfirm ? Colors.black : _textMuted,
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

// ── Time picker tile ──────────────────────────────────────────
class _TimePickerTile extends StatelessWidget {
  final String label;
  final String? time;
  final bool hasError;
  final VoidCallback onTap;

  const _TimePickerTile({
    required this.label,
    required this.time,
    required this.hasError,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = hasError ? _danger : (time != null ? _neon : _divider);
    final bgColor = hasError
        ? const Color(0x1AE24B4A)
        : (time != null ? _neonDim : _card);

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
                color: _textMuted,
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
                  color: hasError ? _danger : (time != null ? _neon : _textMuted),
                ),
                const SizedBox(width: 6),
                Text(
                  time ?? '--:-- --',
                  style: TextStyle(
                    color: hasError
                        ? _danger
                        : (time != null ? _neon : _textMuted),
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
