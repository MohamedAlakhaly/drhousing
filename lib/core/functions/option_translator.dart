import 'package:get/get.dart';

class OptionTranslator {
  static const List<String> employmentOptions = [
    'Employed',
    'Self-employed',
    'Student',
    'Unemployed',
    'Retired',
  ];

  static const List<String> maritalOptions = [
    'Single',
    'Married',
    'Couple',
  ];

  static String translateEmployment(String key) {
    final map = {
      'Employed': 'employment_employed'.tr,
      'Self-employed': 'employment_self_employed'.tr,
      'Student': 'employment_student'.tr,
      'Unemployed': 'employment_unemployed'.tr,
      'Retired': 'employment_retired'.tr,
    };
    return map[key] ?? key;
  }

  static String translateMarital(String key) {
    final map = {
      'Single': 'marital_single'.tr,
      'Married': 'marital_married'.tr,
      'Couple': 'marital_couple'.tr,
    };
    return map[key] ?? key;
  }

  static const List<String> amenityKeys = [
    'Parking',
    'Pets',
    'Balcony',
    'Elevator',
    'Laundry',
  ];

  static String translateAmenity(String key) {
    final map = {
      'Parking': 'amenity_parking'.tr,
      'Pets': 'amenity_pets'.tr,
      'Balcony': 'amenity_balcony'.tr,
      'Elevator': 'amenity_elevator'.tr,
      'Laundry': 'amenity_laundry'.tr,
    };
    return map[key] ?? key;
  }
}
