import 'dart:developer';

import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/modules/auth/logic_view/controller/logic_auth_controller.getx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
abstract class ProfileController extends GetxController {}

class ProfileControllerImp extends ProfileController {
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      Get.snackbar('errorTitle'.tr, 'signOutFailedContent'.tr);
    }
  }

  Future<void> confirmAndDeleteAccount() async {
  final confirmed = await Get.dialog<bool>(
    AlertDialog(
      backgroundColor: AppColors.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.dangerColor.withValues(alpha: 0.3)),
      ),
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.dangerBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.dangerColor, size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            'delete_account_confirm_title'.tr,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Text(
        'delete_account_confirm_body'.tr,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.5),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Get.back(result: false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.bgDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Center(
                    child: Text(
                      'delete_account_cancel'.tr,
                      style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => Get.back(result: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.dangerColor.withValues(alpha: 0.4)),
                  ),
                  child: Center(
                    child: Text(
                      'delete_account_confirm'.tr,
                      style: const TextStyle(color: AppColors.dangerColor, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    final uid = Supabase.instance.client.auth.currentUser?.id;
    if (uid == null) return;

    // loading
    Get.snackbar(
      'delete_account_loading_title'.tr,
      'delete_account_loading_body'.tr,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: AppColors.textMuted,
      duration: const Duration(seconds: 5),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: AppColors.bgCard,
      progressIndicatorValueColor: AlwaysStoppedAnimation(AppColors.dangerColor),
      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.dangerColor),
    );

    final res = await http.post(
      Uri.parse('https://bjrhshhmjjyggzfuogsu.supabase.co/functions/v1/delete-account'),
      headers: {
        'Content-Type': 'application/json',
        'apikey': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqcmhzaGhtamp5Z2d6ZnVvZ3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NTA3ODcsImV4cCI6MjA5MjQyNjc4N30.6zlKDgHvFQIXIrrQZrIT6L1dqoWccz30YowoWi3ikac',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqcmhzaGhtamp5Z2d6ZnVvZ3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NTA3ODcsImV4cCI6MjA5MjQyNjc4N30.6zlKDgHvFQIXIrrQZrIT6L1dqoWccz30YowoWi3ikac',
      },
      body: jsonEncode({'userId': uid}),
    );

    if (res.statusCode != 200) throw Exception(res.body);

    await Supabase.instance.client.auth.signOut();
    Get.find<UserController>().clearUser();

    Get.snackbar(
      'delete_account_success_title'.tr,
      'delete_account_success_body'.tr,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: AppColors.primary,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary),
    );
  } catch (e) {
    log('confirmAndDeleteAccount: $e');
    Get.snackbar(
      'delete_account_error_title'.tr,
      'delete_account_error_body'.tr,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: AppColors.dangerColor,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline_rounded, color: AppColors.dangerColor),
    );
  }
}
}
