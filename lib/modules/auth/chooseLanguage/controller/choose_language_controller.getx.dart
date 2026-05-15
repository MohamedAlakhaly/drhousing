import 'package:apartment_rentals/core/constant/app_images.dart';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/services/app_services.dart';
import 'package:get/get.dart';

abstract class ChooseLanguageController extends GetxController {}

class ChooseLanguageControllerImp extends ChooseLanguageController {
  AppServices services = Get.find();
  String selectLanguage = 'select language'.tr;
  String currentLanguage = '';

  final List<LangOption> options =  [
    LangOption(
      name: 'العربية',
      nativeName: 'Arabic',
      flag: AppImages.yemen,
      code: 'ar',
    ),
    LangOption(
      name: 'Nederlands',
      nativeName: 'Dutch',
      flag: AppImages.netherlands,
      code: 'nl',
    ),
    LangOption(
      name: 'English',
      nativeName: 'English',
      flag: AppImages.america,
      code: 'en',
    ),
    LangOption(
      name: 'Français',
      nativeName: 'French',
      flag: AppImages.france,
      code: 'fr',
    ),
  ];



  void selectLang(String code) {
    currentLanguage = code;
    update();
  }

  void chooseLanguage() async {
    if (currentLanguage.isEmpty) {
      selectLanguage = 'mandatory language selection'.tr;
      update();
    } else {
      services.sharedPreferences.setString('langCode', currentLanguage);
      services.sharedPreferences.setBool('hasChosenLanguage', true);
      Get.offNamed(AppRoutes.onBoarding);
    }
  }
}

class LangOption {
  final String name;
  final String nativeName;
  final String flag;
  final String code;

  const LangOption({
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.code,
  });
}
