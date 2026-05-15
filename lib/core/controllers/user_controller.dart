import 'dart:developer';

import 'package:apartment_rentals/models/static/auth/user_model.module.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class UserController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  bool get isLoggedIn => user.value != null;
  String get displayName => user.value?.fullName ?? '';
  String get phoneNumber => user.value?.phone ?? '';
  String get employmentStatus => user.value?.employmentStatus ?? '';
  String get jobTitle => user.value?.jobTitle ?? '';
  String get email => user.value?.email ?? '';

  // ── Premium ────────────────────────────────────────────────────────
bool get isPremium => user.value?.isPremium ?? false;
  DateTime? get premiumActivatedAt => user.value?.premiumActivatedAt;
  DateTime? get premiumExpiresAt => user.value?.premiumExpiresAt;
  int get premiumDaysRemaining => user.value?.daysRemaining ?? 0;
  bool get isPremiumExpired => user.value?.isPremiumExpired ?? false;

  // ── Role ───────────────────────────────────────────────────────────
  String get role => user.value?.role ?? 'tenant';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isManager => role == 'manager' || role == 'super_admin';

  // ── Formatted dates ────────────────────────────────────────────────
String get formattedActivationDate {
  final date = premiumActivatedAt;
  if (date == null) return 'N/A';
  final locale = Get.locale?.languageCode ?? 'en';
  return DateFormat('MMMM d, yyyy', locale).format(date.toLocal());
}

String get formattedExpiryDate {
  final date = premiumExpiresAt;
  if (date == null) return 'N/A';
  final locale = Get.locale?.languageCode ?? 'en';
  return DateFormat('MMMM d, yyyy', locale).format(date.toLocal());
}

  Future<void> fetchUserData() async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      if (uid == null) return;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', uid)
          .single();

      user.value = UserModel.fromJson(response);
    } catch (e) {
      log('UserController.fetchUserData: $e');
    }
  }

  Future<void> updateUserProfile({
    String? fullName,
    String? phone,
    String? jobTitle,
    String? employmentStatus,
  }) async {
    final uid = _supabase.auth.currentUser?.id;
    if (uid == null) return;

    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (phone != null) updates['phone'] = phone;
    if (jobTitle != null) updates['job_title'] = jobTitle;
    if (employmentStatus != null) updates['employment_status'] = employmentStatus;
    if (updates.isEmpty) return;

    try {
      await _supabase.from('profiles').update(updates).eq('id', uid);

      user.value = user.value?.copyWith(
        fullName: fullName,
        phone: phone,
        jobTitle: jobTitle,
        employmentStatus: employmentStatus,
      );
    } catch (e) {
      log('UserController.updateUserProfile: $e');
      rethrow;
    }
  }

  void clearUser() {
    user.value = null;
  }
}