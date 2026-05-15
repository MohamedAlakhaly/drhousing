import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CompleteProfileController extends GetxController {
  void saveProfile();
}

class CompleteProfileControllerImp extends CompleteProfileController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController jobTitleController;
  late TextEditingController cityController;
  late TextEditingController reasonController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String selectedEmploymentStatus = '';
  final List<String> employmentOptions = [
    'Employed',
    'Self-employed',
    'Student',
    'Unemployed',
    'Retired',
  ];

  String selectedMaritalStatus = '';
  final List<String> maritalOptions = ['Single', 'Married', 'Couple'];

  double monthlyIncome = 3000;
  int occupantsCount = 1;
  bool? isSmoker;
  bool? hasPets;

  // ── Preferred cities ─────────────────────────────────────────
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

  @override
  void onInit() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    jobTitleController = TextEditingController();
    cityController = TextEditingController();
    reasonController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    jobTitleController.dispose();
    cityController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  void selectEmploymentStatus(String status) {
    selectedEmploymentStatus = status;
    update();
  }

  void selectMaritalStatus(String status) {
    selectedMaritalStatus = status;
    update();
  }

  void setMonthlyIncome(double value) {
    monthlyIncome = value;
    update();
  }

  void incrementOccupants() {
    if (occupantsCount < 10) {
      occupantsCount++;
      update();
    }
  }

  void decrementOccupants() {
    if (occupantsCount > 1) {
      occupantsCount--;
      update();
    }
  }

  void setSmoker(bool value) {
    isSmoker = value;
    update();
  }

  void setPets(bool value) {
    hasPets = value;
    update();
  }

  @override
  void saveProfile() {
    if (formKey.currentState!.validate()) {
      // TODO: wire up backend
    }
  }
}
