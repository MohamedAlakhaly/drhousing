import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLocalController extends GetxController {
  void changeLocal(String langCode) {
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
  }
}
