import 'dart:developer';
import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

// ── Model ──────────────────────────────────────────────────────────────────────
class AdminUserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final bool isPremium;
  final RxBool isBlocked; // ← RxBool بدل bool عادي

  AdminUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    required this.isPremium,
    required bool isBlocked,
  }) : isBlocked = isBlocked.obs;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'tenant',
      isPremium: json['is_premium'] as bool? ?? false,
      isBlocked: json['is_blocked'] as bool? ?? false,
    );
  }
}

// ── Controller ─────────────────────────────────────────────────────────────────
class AdminUsersController extends GetxController {
  final RxList<AdminUserModel> users = <AdminUserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  List<AdminUserModel> get filteredUsers {
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return users.toList();
    return users
        .where((u) =>
            u.fullName.toLowerCase().contains(q) ||
            u.email.toLowerCase().contains(q))
        .toList();
  }

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('profiles')
          .select()
          .order('created_at', ascending: false);
      users.value = (response as List)
          .map((j) => AdminUserModel.fromJson(j))
          .toList();
    } catch (e) {
      log('AdminUsersController.fetchUsers: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleBlock(AdminUserModel user) async {
    final newVal = !user.isBlocked.value;
    // تحديث محلي فوري
    user.isBlocked.value = newVal;

    try {
      await _supabase
          .from('profiles')
          .update({'is_blocked': newVal})
          .eq('id', user.id);
    } catch (e) {
      // rollback لو فشل
      user.isBlocked.value = !newVal;
      log('AdminUsersController.toggleBlock: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    }
  }

  Future<void> changeRole(AdminUserModel user, String newRole) async {
    if (user.role == newRole) {
      Get.back();
      return;
    }
    try {
      await _supabase
          .from('profiles')
          .update({'role': newRole})
          .eq('id', user.id);

      final idx = users.indexWhere((u) => u.id == user.id);
      if (idx != -1) {
        users[idx] = AdminUserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phone: user.phone,
          role: newRole,
          isPremium: user.isPremium,
          isBlocked: user.isBlocked.value,
        );
      }
      Get.back();
    } catch (e) {
      log('AdminUsersController.changeRole: $e');
      Get.snackbar('errorTitle'.tr, 'unexpectedError'.tr);
    }
  }

  Color roleColor(String role) => switch (role) {
        'super_admin' => AppColors.primary,
        'manager' => const Color(0xFF64B5F6),
        _ => AppColors.textMuted,
      };

  String roleLabel(String role) => switch (role) {
        'super_admin' => 'admin_role_super'.tr,
        'manager' => 'admin_role_manager'.tr,
        _ => 'admin_role_tenant'.tr,
      };
}