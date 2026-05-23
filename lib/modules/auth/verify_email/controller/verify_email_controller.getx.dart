import 'dart:ui';

import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

abstract class VerifyEmailController extends GetxController {
  void reSendEmail();
  void goToSignIn();
}

class VerifyEmailControllerImp extends VerifyEmailController {
  final RxBool isResending = false.obs;
  final RxInt resendCooldown = 0.obs;

  @override
  void goToSignIn() {
    Get.offAllNamed(AppRoutes.signIn);
  }
  final String email;
  VerifyEmailControllerImp({required this.email});

  @override
  void reSendEmail() async {
    if (resendCooldown.value > 0 || isResending.value) return;

    try {
      isResending.value = true;

      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email, // ← استخدم الإيميل المحفوظ
        emailRedirectTo: kIsWeb
            ? 'https://drhousing.be'
            : 'io.supabase.apartmentrentals://login-callback',
      );

      Get.snackbar(
        'resend_success_title'.tr,
        'resend_success_body'.tr,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFCCFF00),
        duration: const Duration(seconds: 3),
      );

      _startCooldown();
    } on AuthException catch (e) {
      Get.snackbar('errorTitle'.tr, e.message);
    } catch (e) {
      Get.snackbar('errorTitle'.tr, 'resend_failed'.tr);
    } finally {
      isResending.value = false;
    }
  }

  void _startCooldown() {
    resendCooldown.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendCooldown.value > 0) {
        resendCooldown.value--;
        return true;
      }
      return false;
    });
  }

  @override
void onInit() {
  super.onInit();
  _startCooldown();
}
}