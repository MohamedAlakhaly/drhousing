import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class SignUpController extends GetxController {
  void showPassword();
  void goToSignIn();
  void signUp();
}

class SignUpControllerImp extends SignUpController {
  bool obscureText = true;
  bool agreePrivate = false;
  IconData visibilityIcon = Icons.visibility_off_outlined;
  bool isLoading = false;

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void showPassword() {
    obscureText = !obscureText;
    visibilityIcon = obscureText
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    update();
  }

  @override
  void goToSignIn() {
    Get.toNamed(AppRoutes.signIn);
  }

  @override
  void signUp() async {
    if (globalKey.currentState!.validate()) {
      if (agreePrivate) {
        try {
          isLoading = true;
          update();

          await supabase.auth.signUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            data: {
              'full_name': usernameController.text.trim(),
            },
          );

          Get.offAllNamed(AppRoutes.verifyEmail);
          Get.snackbar(
            'account_created_title'.tr,
            'account_created_content'.tr,
          );
        } on AuthException catch (e) {
          _handleAuthError(e);
        } catch (e) {
          Get.snackbar(
            'account_creation_failed_title'.tr,
            'account_creation_failed_content'.tr,
          );
        } finally {
          isLoading = false;
          update();
        }
      } else {
        Get.snackbar('privacy_policy_off_title'.tr, 'privacy_policy_off_content'.tr);
      }
    }
  }

  void _handleAuthError(AuthException e) {
    if (e.message.contains('already registered') ||
        e.message.contains('already been registered')) {
      Get.snackbar('email_already_in_use_title'.tr, 'email_already_in_use_content'.tr);
    } else if (e.message.contains('Password should be at least')) {
      Get.snackbar('weak_password_title'.tr, 'weak_password_content'.tr);
    } else {
      Get.snackbar(
        'account_creation_failed_title'.tr,
        e.message,
      );
    }
  }

  @override
  void onInit() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}