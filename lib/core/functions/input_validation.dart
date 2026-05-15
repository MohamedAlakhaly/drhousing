import 'package:get/get.dart';

inputValidation(int max, int min, String val, String type) {
  if (type == 'username') {
    if (!GetUtils.isUsername(val)) {
      return 'usernameValid'.tr;
    }
  }

  if (type == 'email') {
    if (!GetUtils.isEmail(val)) {
      return 'emailValid'.tr;
    }
  }


  if (val.length > max) {
    return '${'maxlengthValid'.tr} $max';
    
  }

  if (val.length < min) {
    return '${'minlengthValid'.tr} $min';
  }

  if (val.isEmpty) {
    return 'emptyValid'.tr;
  }
}
