import 'package:apartment_rentals/core/constant/app_routes.dart';
import 'package:apartment_rentals/core/localization/local.dart';
import 'package:apartment_rentals/core/functions/social_method.dart';
import 'package:apartment_rentals/modules/auth/logic_view/view/logic_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apartment_rentals/core/localization/local_controller.getx.dart';
import 'package:apartment_rentals/core/services/app_services.dart';
import 'package:apartment_rentals/routes.dart';
import 'package:apartment_rentals/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bjrhshhmjjyggzfuogsu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqcmhzaGhtamp5Z2d6ZnVvZ3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NTA3ODcsImV4cCI6MjA5MjQyNjc4N30.6zlKDgHvFQIXIrrQZrIT6L1dqoWccz30YowoWi3ikac',
    authOptions: FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
  );
  await initialService();
  if (!kIsWeb) {
    await GoogleAuthService.initialize();
  }

  await initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppServices services = Get.find();
    Get.put(AppLocalController());
    String? langCode =
        services.sharedPreferences.getString('langCode') ??
        Get.deviceLocale?.languageCode ??
        'en';
    
    return GetMaterialApp(
      title: 'Dr Housing',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,

      unknownRoute: GetPage(name: '/notfound', page: () => const LogicView()),

      routingCallback: (routing) {
        if (routing?.current.startsWith('/error=') == true ||
            routing?.current.startsWith('/?code=') == true) {
          return;
        }
      },
      locale: Locale(langCode.toLowerCase()),
      translations: MyLocal(),
      fallbackLocale: Locale('en'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
        Locale('nl'),
      ],
      getPages: getPages,
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      themeMode: () {
        final saved = services.sharedPreferences.getString('themeMode');
        if (saved == 'light') return ThemeMode.light;
        if (saved == 'dark') return ThemeMode.dark;
        return ThemeMode.system;
      }(),
    );
  }
}
