import 'package:apartment_rentals/modules/auth/logic_view/controller/logic_auth_controller.getx.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class SplashController extends GetxController {}

class SplashControllerImp extends SplashController {
  @override
  void onInit() {
    if (kIsWeb) {
      _navigate();
    } else {
      Future.delayed(const Duration(seconds: 2), _navigate);
    }
    super.onInit();
  }

  void _navigate() {
    Get.put(LogicAuthControllerImp());
  }
}
// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/MohamedAlakhaly/drhousing.git
// git push -u origin main