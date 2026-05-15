import 'package:apartment_rentals/core/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

abstract class ChangeThemeController extends GetxController {
  void changeToLightMode();
  void changeToDarkMode();
  void changeToSystemMode();
}

class ChangeThemeControllerImp extends ChangeThemeController {
  String themeMode = 'dark';
  bool get isDarkMode => themeMode == 'dark';

  RiveAnimationController? switchTheme;
  AppServices services = Get.find();

  @override
void changeToDarkMode() async {
  if (themeMode == 'dark') return;
  
  // لو النظام داكن وكنا على system — ما نشغل الأنيميشن
  final alreadyDark = themeMode == 'system' &&
      WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  themeMode = 'dark';
  Get.changeThemeMode(ThemeMode.dark);

  if (!alreadyDark) {
    switchTheme!.isActive = true;
    switchTheme = SimpleAnimation('Off');
  }

  await services.sharedPreferences.setString('themeMode', 'dark');
  update();
}

@override
void changeToLightMode() async {
  if (themeMode == 'light') return;

  // لو النظام فاتح وكنا على system — ما نشغل الأنيميشن
  final alreadyLight = themeMode == 'system' &&
      WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.light;

  themeMode = 'light';
  Get.changeThemeMode(ThemeMode.light);

  if (!alreadyLight) {
    switchTheme!.isActive = true;
    switchTheme = SimpleAnimation('On');
  }

  await services.sharedPreferences.setString('themeMode', 'light');
  update();
}

  @override
void changeToSystemMode() async {
  if (themeMode == 'system') return;

  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  final systemIsDark = brightness == Brightness.dark;

  final alreadyMatch =
      (themeMode == 'dark' && systemIsDark) ||
      (themeMode == 'light' && !systemIsDark);

  themeMode = 'system';
  Get.changeThemeMode(ThemeMode.system);

  if (!alreadyMatch) {
    switchTheme!.isActive = true;
    switchTheme = SimpleAnimation(systemIsDark ? 'Off' : 'On');
  }

  await services.sharedPreferences.setString('themeMode', 'system');
  update();
}

  @override
  void onInit() {
    final saved = services.sharedPreferences.getString('themeMode');

    // migrate من الكود القديم
    if (saved == null) {
      final oldBool = services.sharedPreferences.getBool('lightMode');
      themeMode = (oldBool == true) ? 'light' : 'dark';
    } else {
      themeMode = saved;
    }

    // نفس منطق الكود الشغال بالضبط
    switchTheme = SimpleAnimation(isDarkMode ? 'Light' : 'Dark');
    super.onInit();
  }

  @override
  void dispose() {
    switchTheme!.dispose();
    super.dispose();
  }
}