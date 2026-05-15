import 'dart:developer';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class ApartmentController extends GetxController {
  final RxList<ApartmentModel> apartments = <ApartmentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ── Search & Filter ──────────────────────────────────────────
  final RxString searchQuery = ''.obs;
  final RxDouble maxPrice = 5000.0.obs;
  final RxInt bedsFilter = 0.obs; // 0 = All, -1 = 4+
  final RxList<String> amenitiesFilter = <String>[].obs;

  // ── Fetch apartments + favorites + bookings ──────────────────
  Future<void> fetchApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final apartmentsData = await _supabase
          .from('apartments')
          .select()
          .order('created_at', ascending: false);

      final favoriteIds = await _fetchFavoriteIds();
      final bookingStatuses = await _fetchBookingStatuses();

      apartments.value = (apartmentsData as List).map((json) {
        final id = json['id'] as String;
        return ApartmentModel.fromJson(
          json,
          isFavorite: favoriteIds.contains(id),
          bookingStatus: bookingStatuses[id] ?? '',
        );
      }).toList();
    } on PostgrestException catch (e) {
      errorMessage.value = e.message;
      log('ApartmentController.fetchApartments [Postgrest]: ${e.message}');
    } catch (e) {
      errorMessage.value = 'unexpectedError'.tr;
      log('ApartmentController.fetchApartments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Fetch favorite IDs ───────────────────────────────────────
  Future<Set<String>> _fetchFavoriteIds() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return {};
    final response = await _supabase
        .from('favorites')
        .select('apartment_id')
        .eq('user_id', uid);
    return (response as List)
        .map((row) => row['apartment_id'] as String)
        .toSet();
  }

  // ── Fetch active booking statuses ────────────────────────────
  Future<Map<String, String>> _fetchBookingStatuses() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return {};
    final response = await _supabase
        .from('bookings')
        .select('apartment_id, status')
        .eq('user_id', uid)
        .inFilter('status', ['pending', 'confirmed']);
    return {
      for (final row in response as List)
        row['apartment_id'] as String: row['status'] as String,
    };
  }

  // ── Toggle favorite ──────────────────────────────────────────
  Future<void> toggleFavorite(ApartmentModel apartment) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    final previousState = apartment.isFavorite.value;
    apartment.isFavorite.value = !previousState;
    HapticFeedback.lightImpact();

    try {
      if (apartment.isFavorite.value) {
        await _supabase.from('favorites').insert({
          'user_id': uid,
          'apartment_id': apartment.id,
        });
      } else {
        await _supabase
            .from('favorites')
            .delete()
            .eq('user_id', uid)
            .eq('apartment_id', apartment.id);
      }
    } on PostgrestException catch (e) {
      apartment.isFavorite.value = previousState;
      log('ApartmentController.toggleFavorite [Postgrest]: ${e.message}');
      Get.snackbar('errorTitle'.tr, 'favoriteErrorContent'.tr);
    } catch (e) {
      apartment.isFavorite.value = previousState;
      log('ApartmentController.toggleFavorite: $e');
      Get.snackbar('errorTitle'.tr, 'favoriteErrorContent'.tr);
    }
  }

  // ── Create booking ───────────────────────────────────────────
  Future<void> createBooking({
    required ApartmentModel apartment,
    required DateTime bookingDate,
    DateTime? bookingEndTime,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    try {
      await _supabase.from('bookings').insert({
        'user_id': uid,
        'apartment_id': apartment.id,
  'available_from': bookingDate.toIso8601String(),
        if (bookingEndTime != null)
    'available_to': bookingEndTime.toIso8601String(),
        'status': 'pending',
      });

      apartment.bookingStatus.value = 'pending';
      HapticFeedback.heavyImpact();

      Get.snackbar(
        'bookingSuccessTitle'.tr,
        'bookingSuccessContent'.tr,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFCCFF00),
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFFCCFF00)),
        duration: const Duration(seconds: 3),
      );
    } on PostgrestException catch (e) {
      log('ApartmentController.createBooking [Postgrest]: ${e.message}');
      if (e.code == '23505') {
        Get.snackbar('alreadyBookedTitle'.tr, 'alreadyBookedContent'.tr);
      } else {
        Get.snackbar('errorTitle'.tr, 'bookingErrorContent'.tr);
      }
    } catch (e) {
      log('ApartmentController.createBooking: $e');
      Get.snackbar('errorTitle'.tr, 'bookingErrorContent'.tr);
    }
  }

  // ── Filtered list ────────────────────────────────────────────
  List<ApartmentModel> get filteredApartments {
    final query = searchQuery.value.toLowerCase().trim();
    final maxP = maxPrice.value;
    final beds = bedsFilter.value;
    final amenities = amenitiesFilter.toList();

    return apartments.where((a) {
      // Search — يبحث في localizedTitle لدعم اللغات
      if (query.isNotEmpty &&
          !a.localizedTitle.toLowerCase().contains(query) &&
          !a.address.toLowerCase().contains(query)) {
        return false;
      }

      if (a.price > maxP) return false;

      if (beds == -1) {
        if (a.bedCount < 4) return false;
      } else if (beds > 0) {
        if (a.bedCount != beds) return false;
      }

      if (amenities.isNotEmpty) {
        for (final amenity in amenities) {
          switch (amenity) {
            case 'Parking':
              if (!a.hasParking) return false;
            case 'Pets':
              if (!a.hasPets) return false;
            case 'Balcony':
              if (!a.hasBalcony) return false;
            case 'Elevator':
              if (!a.hasElevator) return false;
            case 'Laundry':
              if (!a.hasLaundry) return false;
          }
        }
      }

      return true;
    }).toList();
  }

  void resetFilters() {
    searchQuery.value = '';
    maxPrice.value = 5000.0;
    bedsFilter.value = 0;
    amenitiesFilter.clear();
  }

  bool get isFiltered =>
      searchQuery.value.isNotEmpty ||
      maxPrice.value < 5000.0 ||
      bedsFilter.value != 0 ||
      amenitiesFilter.isNotEmpty;

  bool get hasError => errorMessage.value.isNotEmpty;
  bool get isEmpty => apartments.isEmpty && !isLoading.value;
  List<ApartmentModel> get favoriteApartments =>
      apartments.where((a) => a.isFavorite.value).toList();

  @override
  Future<void> refresh() => fetchApartments();

  @override
  void onInit() {
    fetchApartments();
    super.onInit();
  }
}