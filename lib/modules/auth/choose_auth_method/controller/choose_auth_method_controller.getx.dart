import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:get/get.dart';

abstract class ChooseAuthMethodController extends GetxController {
  void goToSignIn();
  void goToSignUp();
}

class ChooseAuthMethodControllerImp extends ChooseAuthMethodController {
  @override
  goToSignIn() {
    Get.toNamed(AppRoutes.signIn);
  }

  @override
  goToSignUp() {
    Get.toNamed(AppRoutes.signUp);
  }
}
