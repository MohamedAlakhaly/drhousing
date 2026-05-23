import 'dart:developer';
import 'package:apartment_rentals/models/static/admin_booking_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class AdminBookingsController extends GetxController {
  final RxList<AdminBookingModel> bookings = <AdminBookingModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedFilter = 'all'.obs;

  static const _filters = [
    'all',
    'pending',
    'confirmed',
    'cancelled',
    'expired',
  ];
  List<String> get filters => _filters;

  List<AdminBookingModel> get filteredBookings {
    if (selectedFilter.value == 'all') return bookings.toList();
    if (selectedFilter.value == 'expired') {
      return bookings.where((b) => b.status.value == 'expired').toList();
    }
    return bookings
        .where((b) => b.status.value == selectedFilter.value)
        .toList();
  }

  @override
  void onInit() {
    fetchBookings();
    super.onInit();
  }

  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;
      
      errorMessage.value = '';

      // ١. جلب الحجوزات مع بيانات الشقة فقط
      final bookingsResponse = await _supabase
          .from('bookings')
          .select(
            '*, apartments!bookings_apartment_id_fkey(translations, title)',
          )
          .order('created_at', ascending: false);

      // ٢. جلب بيانات المستخدمين بشكل منفصل
      final userIds = (bookingsResponse as List)
          .map((b) => b['user_id'] as String)
          .toSet()
          .toList();

      final profilesResponse = await _supabase
          .from('profiles')
          .select('id, full_name, email, phone')
          .inFilter('id', userIds);

      // ٣. عمل Map للبروفايلات
      final profilesMap = {
        for (final p in profilesResponse as List) p['id'] as String: p,
      };

      // ٤. دمج البيانات
      bookings.value = (bookingsResponse).map((json) {
        final userId = json['user_id'] as String;
        final profile = profilesMap[userId] ?? {};
        return AdminBookingModel.fromJson({
          ...json,
          'tenant_name': profile['full_name'] ?? '',
          'tenant_email': profile['email'] ?? '',
          'tenant_phone': profile['phone'] ?? '',
        });
      }).toList();
    } on PostgrestException catch (e) {
      errorMessage.value = e.message;
      log('AdminBookingsController.fetchBookings [Postgrest]: ${e.message}');
    } catch (e) {
      errorMessage.value = 'unexpectedError'.tr;
      log('AdminBookingsController.fetchBookings: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markExpired(AdminBookingModel booking) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': 'expired'})
          .eq('id', booking.id);
      booking.status.value = 'expired';
    } catch (e) {
      log('AdminBookingsController.markExpired: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    }
  }

  Future<void> deleteBooking(AdminBookingModel booking) async {
    try {
      await _supabase.from('bookings').delete().eq('id', booking.id);
      bookings.remove(booking);
      Get.snackbar(
        'admin_booking_deleted_title'.tr,
        'admin_booking_deleted_msg'.tr,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFCCFF00),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      log('AdminBookingsController.deleteBooking: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    }
  }

  Future<void> markComplete(AdminBookingModel booking) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': 'confirmed'})
          .eq('id', booking.id);
      booking.status.value = 'confirmed';
    } catch (e) {
      log('AdminBookingsController.markComplete: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    }
  }
}
