import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/services/app_services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class ForgetPasswordController extends GetxController {
  void sendEmail();
}

class ForgetPasswordControllerImp extends ForgetPasswordController {
  late TextEditingController emailController;
  AppServices services = Get.find<AppServices>();
  RxBool isLoading = false.obs;

  @override
  void sendEmail() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('error_title'.tr, 'please_enter_email'.tr);
      return;
    }

    try {
      isLoading.value = true;

      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
      );

      Get.offAllNamed(AppRoutes.successSendEmail);
    } on AuthException catch (e) {
      Get.snackbar(
        'error_sending_link_to_change_password_title'.tr,
        'error_sending_link_to_change_password_content'.tr,
      );
    } catch (e) {
      Get.snackbar(
        'problem_connecting_to_server_title'.tr,
        'problem_connecting_to_server_content'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}