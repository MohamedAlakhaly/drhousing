import 'dart:developer';

import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/models/static/booking_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

enum BookingFilter { all, pending, cancelled, confirmed }

class BookingController extends GetxController {
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<BookingFilter> selectedFilter = BookingFilter.all.obs;
  
  
  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  // Tabs: All | Pending | Cancelled | Completed (confirmed)
  List<BookingModel> get filteredBookings => switch (selectedFilter.value) {
  BookingFilter.pending   => bookings.where((b) => b.status.value == 'pending').toList(),
  BookingFilter.cancelled => bookings.where((b) => b.status.value == 'cancelled').toList(),
  BookingFilter.confirmed => bookings.where((b) => b.status.value == 'confirmed').toList(),
  BookingFilter.all       => bookings.toList(),
};

  // ── Fetch all bookings joined with apartment details ─────────────────────
  Future<void> fetchBookings() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _supabase
          .from('bookings')
          .select('*, apartments(*)')
          .eq('user_id', uid)
          .order('booking_end_time', ascending: false);

      bookings.value = (response as List)
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      errorMessage.value = e.message;
      log('BookingController.fetchBookings [Postgrest]: ${e.message}');
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      log('BookingController.fetchBookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Cancel a pending booking (optimistic UI + rollback) ──────────────────
  Future<void> cancelBooking(BookingModel booking) async {
    HapticFeedback.mediumImpact();

    final previousStatus = booking.status.value;
    booking.status.value = 'cancelled';
    bookings.refresh();

    // Sync bookingStatus on the ApartmentController copy
    _syncApartmentBookingStatus(booking.apartmentId, '');

    try {
      await _supabase
          .from('bookings')
          .update({'status': 'cancelled'})
          .eq('id', booking.id);
    } on PostgrestException catch (e) {
      booking.status.value = previousStatus;
      bookings.refresh();
      _syncApartmentBookingStatus(booking.apartmentId, previousStatus);
      log('BookingController.cancelBooking [Postgrest]: ${e.message}');
      Get.snackbar(
        'Error',
        'Could not cancel booking. Please try again.',
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: AppColors.dangerColor,
      );
    } catch (e) {
      booking.status.value = previousStatus;
      bookings.refresh();
      _syncApartmentBookingStatus(booking.apartmentId, previousStatus);
      log('BookingController.cancelBooking: $e');
    }
  }

  // ── Delete a cancelled/confirmed booking from history ────────────────────
  Future<void> deleteBooking(BookingModel booking) async {
    HapticFeedback.heavyImpact();

    // Compute what bookingStatus to restore on rollback
    // (confirmed bookings count as active; cancelled ones don't)
    final rollbackStatus =
        booking.status.value == 'confirmed' ? 'confirmed' : '';

    // Optimistic: remove from list immediately
    final originalIndex = bookings.indexOf(booking);
    bookings.remove(booking);

    // Clear bookingStatus locally (confirmed → '' on delete)
    booking.apartment?.bookingStatus.value = '';
    _syncApartmentBookingStatus(booking.apartmentId, '');

    try {
      await _supabase.from('bookings').delete().eq('id', booking.id);
    } on PostgrestException catch (e) {
      // Rollback: re-insert at original position
      if (originalIndex >= 0 && originalIndex <= bookings.length) {
        bookings.insert(originalIndex, booking);
      } else {
        bookings.add(booking);
      }
      booking.apartment?.bookingStatus.value = rollbackStatus;
      _syncApartmentBookingStatus(booking.apartmentId, rollbackStatus);
      log('BookingController.deleteBooking [Postgrest]: ${e.message}');
      Get.snackbar(
        'Error',
        'Could not delete booking. Please try again.',
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: AppColors.dangerColor,
      );
    } catch (e) {
      if (originalIndex >= 0 && originalIndex <= bookings.length) {
        bookings.insert(originalIndex, booking);
      } else {
        bookings.add(booking);
      }
      booking.apartment?.bookingStatus.value = rollbackStatus;
      _syncApartmentBookingStatus(booking.apartmentId, rollbackStatus);
      log('BookingController.deleteBooking: $e');
    }
  }

  // Propagates bookingStatus changes to ApartmentController's list copy
  void _syncApartmentBookingStatus(String apartmentId, String status) {
    try {
      Get.find<ApartmentController>()
          .apartments
          .firstWhereOrNull((a) => a.id == apartmentId)
          ?.bookingStatus
          .value = status;
    } catch (_) {}
  }

  bool get hasError => errorMessage.value.isNotEmpty;
  bool get isEmpty => bookings.isEmpty && !isLoading.value;
}
