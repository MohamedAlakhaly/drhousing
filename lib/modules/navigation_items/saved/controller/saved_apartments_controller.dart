import 'dart:developer';

import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class SavedApartmentsController extends GetxController {
  final RxList<ApartmentModel> savedApartments = <ApartmentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedApartments();
  }

  // ── Fetch favorites joined with apartment details ─────────────────────────
  Future<void> fetchSavedApartments() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // JOIN: favorites → apartments via Supabase foreign table syntax
      final response = await _supabase
          .from('favorites')
          .select('apartment_id, apartments(*)')
          .eq('user_id', uid);

      savedApartments.value = (response as List)
          .map((row) {
            final apartmentJson = row['apartments'] as Map<String, dynamic>?;
            if (apartmentJson == null) return null;
            // These are always favorites by definition
            return ApartmentModel.fromJson(apartmentJson, isFavorite: true);
          })
          .whereType<ApartmentModel>()
          .toList();
    } on PostgrestException catch (e) {
      errorMessage.value = e.message;
      log('SavedApartmentsController.fetchSavedApartments [Postgrest]: ${e.message}');
    } catch (e) {
      errorMessage.value = 'unexpectedError'.tr;
      log('SavedApartmentsController.fetchSavedApartments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ── Remove a saved apartment (unfavorite) ─────────────────────────────────
  Future<void> unfavorite(ApartmentModel apartment) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    HapticFeedback.lightImpact();

    // Optimistic UI: remove immediately from the saved list
    savedApartments.removeWhere((a) => a.id == apartment.id);

    // Sync with ApartmentController so the heart icon updates on the home tab
    try {
      final homeCtrl = Get.find<ApartmentController>();
      final match = homeCtrl.apartments.firstWhereOrNull(
        (a) => a.id == apartment.id,
      );
      match?.isFavorite.value = false;
    } catch (_) {
      // ApartmentController not yet initialised — no sync needed
    }

    try {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', uid)
          .eq('apartment_id', apartment.id);
    } on PostgrestException catch (e) {
      // Rollback: restore to the list
      savedApartments.add(apartment);
      try {
        Get.find<ApartmentController>()
            .apartments
            .firstWhereOrNull((a) => a.id == apartment.id)
            ?.isFavorite
            .value = true;
      } catch (_) {}
      log('SavedApartmentsController.unfavorite [Postgrest]: ${e.message}');
      Get.snackbar('Error', 'Could not remove from saved. Try again.');
    } catch (e) {
      savedApartments.add(apartment);
      log('SavedApartmentsController.unfavorite: $e');
    }
  }

  bool get isEmpty => savedApartments.isEmpty && !isLoading.value;
  bool get hasError => errorMessage.value.isNotEmpty;
}
