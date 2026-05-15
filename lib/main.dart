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
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialService();
  await Supabase.initialize(
    url: 'https://bjrhshhmjjyggzfuogsu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqcmhzaGhtamp5Z2d6ZnVvZ3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NTA3ODcsImV4cCI6MjA5MjQyNjc4N30.6zlKDgHvFQIXIrrQZrIT6L1dqoWccz30YowoWi3ikac',
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );
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
    bool isLight = services.sharedPreferences.getBool('lightMode') ?? false;
    Get.put(AppLocalController());
    String? langCode =
        services.sharedPreferences.getString('langCode') ??
        Get.deviceLocale?.languageCode ??
        'en';
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      // home: OnBoardingView(),
      unknownRoute: GetPage(name: '/notfound', page: () => const LogicView()),
      // أضف هذا
      routingCallback: (routing) {
        // تجاهل الـ OAuth error routes
        if (routing?.current.startsWith('/error=') == true ||
            routing?.current.startsWith('/?code=') == true) {
          return;
        }
      },
      locale: Locale(langCode.toLowerCase()),
      translations: MyLocal(),
      fallbackLocale: Locale('en'),
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('fr'),
      //   Locale('ar'),
      //   Locale('en'),
      //   // Locale('ku',''),
      //   // Locale('so'),
      //   Locale('tr'),
      //   // Locale('ti',''),
      //   Locale('nl'),
      //   Locale('uk'),
      //   Locale('ps'),
      //   Locale('es'),
      // ],
      getPages: getPages,
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      themeMode: ThemeMode.system,
    );
  }
}
