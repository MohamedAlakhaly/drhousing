import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:get/get.dart';

abstract class SuccessSendEmailController extends GetxController {
  void goToSignIn();
}

class SuccessSendEmailControllerImp extends SuccessSendEmailController {
  
  @override
  void goToSignIn() {
    Get.offAllNamed(AppRoutes.signIn);
  }
}
