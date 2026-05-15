import 'dart:developer';
import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/services/app_services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class LogicAuthController extends GetxController {
  void initApp();
}

class LogicAuthControllerImp extends LogicAuthController {
  AppServices services = Get.find<AppServices>();
  bool isNavigating = false;

  @override
  void initApp() async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final response = await supabase.auth.refreshSession();
      final currentSession = response.session;
      log('currentSession: $currentSession');

      if (currentSession != null) {
        await Get.find<UserController>().fetchUserData();
        _navigateAfterAuth();
      } else {
        _navigateToAuth();
      }
    } catch (e) {
      log('Session invalid: $e');
      await supabase.auth.signOut();
      _navigateToAuth();
    }

    supabase.auth.onAuthStateChange.listen((data) async {
      if (isNavigating) return;

      final event = data.event;
      final session = data.session;
      log('event: $event');

      if (event == AuthChangeEvent.signedOut) {
        isNavigating = true;
        Get.find<UserController>().clearUser();
        _navigateToAuth();
        await Future.delayed(const Duration(milliseconds: 500));
        isNavigating = false;
        return;
      }

      if (event == AuthChangeEvent.passwordRecovery) {
        isNavigating = true;
        await Future.delayed(const Duration(milliseconds: 300));
        Get.offAllNamed(AppRoutes.resetPassword);
        isNavigating = false;
        return;
      }

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.initialSession) {
        isNavigating = true;
        await Get.find<UserController>().fetchUserData();
        await Future.delayed(const Duration(milliseconds: 300));
        _navigateAfterAuth();
        isNavigating = false;
      }
    });
  }

  // ── تحقق من isBlocked قبل التوجيه ────────────────────────────────────────
  void _navigateAfterAuth() {
    final userCtrl = Get.find<UserController>();
    final isBlocked = userCtrl.user.value?.isBlocked ?? false;

    if (isBlocked) {
      Get.offAllNamed(AppRoutes.blocked);
    } else {
      Get.offAllNamed(AppRoutes.mainView);
    }
  }

  void _navigateToAuth() {
    final hasChosenLanguage =
        services.sharedPreferences.getBool('hasChosenLanguage') ?? false;
    Get.offAllNamed(
      hasChosenLanguage ? AppRoutes.chooseAuthMethod : AppRoutes.chooseLanguage,
    );
  }

  @override
  void onInit() {
    initApp();
    super.onInit();
  }
}