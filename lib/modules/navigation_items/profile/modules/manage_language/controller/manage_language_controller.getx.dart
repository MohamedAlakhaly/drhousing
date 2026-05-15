import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/localization/local_controller.getx.dart';
import 'package:apartment_rentals/core/services/app_services.dart';

import 'package:get/get.dart';

abstract class ManageLanguageController extends GetxController {}

class ManageLanguageControllerImp extends ManageLanguageController {
  AppServices services = Get.find();

  //? this variable take a app language code
  String currentLanguage = '';
  //? this variable will hold the current language selected by the user
  String selectedLanguage = '';
  //? this variable the same as currentLanguage but the different it's for a display button win the start page
  String appLanguage = '';

  void getCurrentLanguage() {
    currentLanguage = services.sharedPreferences.getString('langCode')??'en';
    appLanguage = services.sharedPreferences.getString('langCode')??'en';
  }

  void changeLanguage({required String langCode}) {
    services.sharedPreferences.setString('langCode', langCode);
    AppLocalController().changeLocal(langCode);
    Get.back();
    Get.snackbar(
      'success_language_change_message_title'.tr,
      'success_language_change_message_content'.tr,
    );
  }

  List<String> languages = [
    'العربية',
    'Nederlands',
    'English',
    'Français',
    // 'Українська',
    // 'Türkçe',
    // 'Español',
    // 'Kurdî',        
    // 'Soomaali',
    // 'ትግርኛ',
    // 'پښتو',
  ];

  List<String> flags = [
    AppImages.yemen,
    AppImages.netherlands,
    AppImages.america,
    AppImages.france,
    // AppImages.ukraine,
    // AppImages.turkey,
    // AppImages.spain,
    // AppImages.kurdistan,
    // AppImages.somalia,
    // AppImages.eritrea,
    // AppImages.afghanistan,
  ];

  List<String> langCode = [
    'ar',
    'nl',
    'en',
    'fr',
    // 'uk',
    // 'tr',
    // 'es',
    // 'ku',
    // 'so',
    // 'ti',
    // 'ps',
  ];

  @override
  void onInit() {
    getCurrentLanguage();
    super.onInit();
  }
}
