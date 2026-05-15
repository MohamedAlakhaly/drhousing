import 'package:apartment_rentals/core/localization/language/arabic.dart';
import 'package:apartment_rentals/core/localization/language/dutch.dart';
import 'package:apartment_rentals/core/localization/language/english.dart';
import 'package:apartment_rentals/core/localization/language/french.dart';
import 'package:get/get.dart';


class MyLocal implements Translations{
  @override
  Map<String, Map<String, String>> get keys => {
    'ar':arabic,
    'en':english,
    // 'fr':french,
    // 'nl':dutch,
    // 'so':somali,
    // 'ti':tigrinya,
    // 'ps':pashto,
    // 'tr':turkish,
    // 'uk':ukrainian,
    // 'es':espanol,
    // 'ku':kurdish
  };

} 