import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/modules/auth/logic_view/view/logic_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class SignInController extends GetxController {
  void signIn();
  void goToSignUp();
  void goToForgetPassword();
}

class SignInControllerImp extends SignInController {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool obscureText = true;
  bool isLoading = false;
  IconData visibilityIcon = Icons.visibility_off_outlined;

  @override
  void signIn() async {
    if (globalKey.currentState!.validate()) {
      try {
        isLoading = true;
        update();

        await supabase.auth.signInWithPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        Get.offAll(() => const LogicView());
      } on AuthException catch (e) {
        _handleAuthError(e);
      } catch (e) {
        Get.snackbar(
          'check_email_or_password_title'.tr,
          'check_email_or_password_content'.tr,
        );
      } finally {
        isLoading = false;
        update();
      }
    }
  }

  void _handleAuthError(AuthException e) {
    if (e.message.contains('Invalid login credentials') ||
        e.message.contains('invalid_credentials')) {
      Get.snackbar(
        'check_email_or_password_title'.tr,
        'check_email_or_password_content'.tr,
      );
    } else if (e.message.contains('Email not confirmed')) {
      Get.snackbar(
        'email_not_verify_title'.tr,
        'email_not_verify_content'.tr,
      );
    } else {
      Get.snackbar('email_not_verify_title'.tr, e.message);
    }
  }

  void showPassword() {
    obscureText = !obscureText;
    visibilityIcon = obscureText
        ? Icons.visibility_off_outlined
        : Icons.visibility_outlined;
    update();
  }

  @override
  void goToSignUp() {
    Get.offAllNamed(AppRoutes.signUp);
  }

  @override
  void goToForgetPassword() {
    Get.toNamed(AppRoutes.forgetPassword);
  }

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}