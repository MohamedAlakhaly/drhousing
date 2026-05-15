import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:get/get.dart';

abstract class VerifyEmailController extends GetxController {
  void reSendEmail();
  void goToSignIn();
}

class VerifyEmailControllerImp extends VerifyEmailController {
  @override
  goToSignIn() {
    Get.offAllNamed(AppRoutes.signIn);
  }

  @override
  reSendEmail() async {
    // try {
    //   await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    //   Get.snackbar(
    //     'verificationEmailSentTitle'.tr,
    //     'verificationEmailSentContent'.tr,
    //   );
    // } on FirebaseException catch (e) {
    //   Get.snackbar(
    //     'accessTemporarilyBlockedTitle'.tr,
    //     'accessTemporarilyBlockedContent'.tr,
    //   );
    //   log(e.message!);
    // }
  }
}
