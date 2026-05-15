import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunctions {
  //! check is dark mode

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String formatPrice(int price) {
  if (price >= 1000) {
    final thousands = price ~/ 1000;
    final remainder = price % 1000;
    return remainder == 0
        ? '€ $thousands,000'
        : '€ $thousands,${remainder.toString().padLeft(3, '0')}';
  }
  return '€ $price';
}

Future<void> openUserMailApp() async {
    try {
      if (await LaunchApp.isAppInstalled(
        androidPackageName: 'com.google.android.gm',
      )) {
        await LaunchApp.openApp(
          androidPackageName: 'com.google.android.gm',
          iosUrlScheme: 'googlegmail://',
        );
      } else {
        await launchUrl(Uri.parse('mailto:'));
      }
    } catch (e) {
      Get.snackbar(
        'email_failed_to_open_message_title'.tr,
        'email_failed_to_open_message_content'.tr,
      );
    }
  }


  // String formatFirestoreTimestamp(Timestamp timestamp) {
  //   DateTime dateTime = timestamp.toDate();
  //   return DateFormat("MMMM d, y • h:mm a").format(dateTime);
  // }



  //   String formatFirestoreTimestampOnlyDate(Timestamp timestamp) {
  //   DateTime dateTime = timestamp.toDate();
  //   return DateFormat("MMMM d, y").format(dateTime);
  // }

  //   String formatFirestoreTimestampOnlyDateDifferentStyle(Timestamp timestamp) {
  //   DateTime dateTime = timestamp.toDate();
  //   return DateFormat("y-MM-dd").format(dateTime);
  // }

  // String formatFirestoreTimestampOnlyDateWithNormalStyle(
  //     Timestamp timestamp,
  //   ) {
  //     DateTime dateTime = timestamp.toDate();
  //     return DateFormat("dd / MM / y").format(dateTime);
  //   }


  Future<void> launchUrlMethod(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Get.snackbar(
        'Error',
        'Could not launch $urlString',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Iconsax.warning_2, color: Colors.white),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }

  String getInitials(String name) {
  if (name.isEmpty) return "??";

  List<String> nameParts = name.trim().split(RegExp(r'\s+'));
  String initials = "";

  if (nameParts.length >= 2) {
    initials = nameParts[0][0] + nameParts[1][0];
  } else if (nameParts.length == 1) {
    initials = nameParts[0][0];
  }

  return initials.toUpperCase();
}
  
  Future<void> makePhoneCall(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

}
