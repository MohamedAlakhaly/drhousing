import 'package:apartment_rentals/core/services/property_service.dart';
import 'package:apartment_rentals/models/static/property_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertySearchController extends GetxController {
  final _service = PropertyService();

  final searchText = ''.obs;
  final properties = <PropertyModel>[].obs;
  final isLoading = true.obs;

  // Applied filter state
  final priceRange = const RangeValues(500, 5000).obs;
  final selectedBedrooms = Rxn<int>();
  final petsAllowed = false.obs;

  // Temporary (in-modal) filter state — mutated freely while modal is open
  RangeValues tempPriceRange = const RangeValues(500, 5000);
  int? tempBedrooms;
  bool tempPets = false;

  Worker? _debounce;

  @override
  void onInit() {
    super.onInit();
    _debounce = debounce(
      searchText,
      (_) => _fetch(),
      time: const Duration(milliseconds: 400),
    );
    _fetch();
  }

  void updateQuery(String q) => searchText.value = q;

  /// Call before opening the filter modal to seed temp state.
  void initTempFilters() {
    tempPriceRange = priceRange.value;
    tempBedrooms = selectedBedrooms.value;
    tempPets = petsAllowed.value;
  }

  /// Commit temp values, close modal, re-fetch.
  void applyFilters() {
    priceRange.value = tempPriceRange;
    selectedBedrooms.value = tempBedrooms;
    petsAllowed.value = tempPets;
    Get.back();
    _fetch();
  }

  Future<void> _fetch() async {
    isLoading.value = true;
    try {
      properties.value = await _service.searchProperties(
        query: searchText.value,
        minPrice: priceRange.value.start,
        maxPrice: priceRange.value.end,
        bedrooms: selectedBedrooms.value,
      );
    } catch (_) {
      properties.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.dispose();
    super.onClose();
  }
}
