import 'dart:developer';

import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class EditPersonalInfoController extends GetxController {
  void saveProfile();
  void selectEmploymentStatus(String status);
}

class EditPersonalInfoControllerImp extends EditPersonalInfoController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController jobTitleController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UserController userController = Get.find<UserController>();
  bool isLoading = false;

  // RxString so Obx in the view can react without a full GetBuilder rebuild
  final RxString selectedEmploymentStatus = ''.obs;

  final List<String> employmentOptions = [
    'Employed',
    'Self-employed',
    'Student',
    'Unemployed',
    'Retired',
  ];


  /// True only for statuses that require a job title.
  bool get showJobTitle =>
      selectedEmploymentStatus.value == 'Employed' ||
      selectedEmploymentStatus.value == 'Self-employed';

  void getPersonInformations() {
    nameController.text = userController.displayName;
    phoneController.text = userController.phoneNumber;
    jobTitleController.text = userController.jobTitle;
    selectedEmploymentStatus.value = userController.employmentStatus;
  }

  @override
  void onInit() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    jobTitleController = TextEditingController();
    getPersonInformations();
    super.onInit();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    jobTitleController.dispose();
    super.dispose();
  }

  @override
  void selectEmploymentStatus(String status) {
    selectedEmploymentStatus.value = status;
    update(); // still needed so GetBuilder rebuilds the chip highlight
  }

  @override
  void saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading = true;
    update();

    final bool isChanged =
        nameController.text != userController.displayName ||
        phoneController.text != userController.phoneNumber ||
        selectedEmploymentStatus.value != userController.employmentStatus ||
        (showJobTitle && jobTitleController.text != userController.jobTitle);

    if (!isChanged) {
      Get.snackbar('warning_title'.tr, 'no_changes_warning'.tr);
      isLoading = false;
      update();
      return;
    }

    try {
      await userController.updateUserProfile(
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        employmentStatus: selectedEmploymentStatus.value,
        // Don't persist a job title for statuses that don't need one
        jobTitle: showJobTitle ? jobTitleController.text.trim() : '',
      );
    } catch (e) {
      log('saveProfile error: $e');
    }

    isLoading = false;
    update();
    Get.back();
  }
}
