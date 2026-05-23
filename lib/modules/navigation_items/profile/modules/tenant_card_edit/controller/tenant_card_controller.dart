import 'dart:developer';

import 'package:apartment_rentals/models/static/user_preferences_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class TenantCardController extends GetxController {
  // ── Persisted state ───────────────────────────────────────────────────────
  final Rx<UserPreferencesModel?> preferences = Rx<UserPreferencesModel?>(null);

  // ── UI state ──────────────────────────────────────────────────────────────
  RxBool isLoading = false.obs;
  final List<String> maritalOptions = ['Single', 'Married', 'Couple'];

  final RxString selectedMaritalStatus = ''.obs;
  final RxDouble monthlyBudget = 0.0.obs;
  final RxInt occupantsCount = 1.obs;
  final Rx<bool?> hasPets = Rx<bool?>(null);

  bool get isEmpty =>
    selectedMaritalStatus.value.isEmpty &&
    occupantsCount.value == 1 &&
    hasPets.value == null &&
    selectedCities.isEmpty;

  // ── Preferred cities ──────────────────────────────────────────────────────
  static const List<String> belgianCities = [
    'Brussels',
    'Antwerp',
    'Ghent',
    'Charleroi',
    'Liège',
    'Bruges',
    'Namur',
    'Leuven',
    'Mons',
    'Aalst',
    'Mechelen',
    'Hasselt',
    'Kortrijk',
    'Sint-Niklaas',
  ];

  final RxList<String> selectedCities = <String>[].obs;
  final RxString citySearchQuery = ''.obs;

  List<String> get filteredCities {
    final q = citySearchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return belgianCities;
    return belgianCities.where((c) => c.toLowerCase().contains(q)).toList();
  }

  void toggleCity(String city) {
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
    } else {
      selectedCities.add(city);
    }
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchPreferences();
  }

  // ── Data loading ──────────────────────────────────────────────────────────
  Future<void> fetchPreferences() async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      if (uid == null) return;

      final response = await _supabase
          .from('user_preferences')
          .select()
          .eq('id', uid)
          .maybeSingle();

      if (response != null) {
        final model = UserPreferencesModel.fromJson(response);
        preferences.value = model;
        _syncFromModel(model);
        update();
      }
    } catch (e) {
      log('TenantCardController.fetchPreferences: $e');
    }
  }

  void _syncFromModel(UserPreferencesModel model) {
    selectedMaritalStatus.value = model.maritalStatus ?? '';
    monthlyBudget.value = model.budgetMax ?? 0;
    occupantsCount.value = model.numberOfOccupants ?? 1;
    hasPets.value = model.pets;
    selectedCities.assignAll(model.preferredCities);
  }

  // ── Persistence ───────────────────────────────────────────────────────────
  Future<void> updateUserPreferences() async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    isLoading.value = true;

    try {
      final model = UserPreferencesModel(
        id: uid,
        preferredCities: List<String>.from(selectedCities),
        budgetMax: monthlyBudget.value,
        maritalStatus: selectedMaritalStatus.value.isEmpty
            ? null
            : selectedMaritalStatus.value,
        numberOfOccupants: occupantsCount.value,
        pets: hasPets.value,
      );

      await _supabase
          .from('user_preferences')
          .upsert(model.toJson(), onConflict: 'id');

      preferences.value = model;
      Get.back();
    } catch (e) {
      log('TenantCardController.updateUserPreferences: $e');
      Get.snackbar('error_title'.tr, 'save_failed'.tr);
    }

    isLoading.value = false;
  }

  // ── Mutators ──────────────────────────────────────────────────────────────
  void selectMaritalStatus(String status) {
    selectedMaritalStatus.value = status;
  }

  void setMonthlyBudget(double value) {
    monthlyBudget.value = value;
  }

  void incrementOccupants() {
    if (occupantsCount < 10) {
      occupantsCount.value++;
    }
  }

  void decrementOccupants() {
    if (occupantsCount > 1) {
      occupantsCount.value--;
      
    }
  }

  void setPets(bool value) {
    hasPets.value = value;
  }
}
