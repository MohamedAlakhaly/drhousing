import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class ResetPasswordController extends GetxController {
  void resetPassword();
  void showPassword();
  void showConfirmPassword();
}

class ResetPasswordControllerImp extends ResetPasswordController {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool obscureText = true;
  bool obscureConfirmText = true;
  RxBool isLoading = false.obs;

  @override
  void resetPassword() async {
    if (!globalKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      await supabase.auth.updateUser(
        UserAttributes(password: passwordController.text.trim()),
      );

      Get.offAllNamed(AppRoutes.signIn);
      Get.snackbar('successTitle'.tr, 'passwordResetSuccessContent'.tr);
    } on AuthException catch (e) {
      Get.snackbar('errorTitle'.tr, e.message);
    } catch (e) {
      Get.snackbar(
        'problemConnectingToServerTitle'.tr,
        'problemConnectingToServerContent'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void showPassword() {
    obscureText = !obscureText;
    update();
  }

  @override
  void showConfirmPassword() {
    obscureConfirmText = !obscureConfirmText;
    update();
  }

  @override
  void onInit() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}