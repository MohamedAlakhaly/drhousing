import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/modules/admin/users/controller/admin_users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

class AdminUsersView extends StatelessWidget {
  const AdminUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AdminUsersController());

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'admin_users_title'.tr,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'admin_users_subtitle'.tr,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: ctrl.fetchUsers,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Iconsax.refresh,
                        color: AppColors.textMuted,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            // ── Search ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: TextField(
                onChanged: (v) => ctrl.searchQuery.value = v,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'admin_search_users'.tr,
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Iconsax.search_normal, color: AppColors.textMuted, size: 18),
                  filled: true,
                  fillColor: AppColors.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms),

            // ── List ─────────────────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: 6,
                    itemBuilder: (_, i) => Shimmer.fromColors(
                      baseColor: AppColors.bgCard,
                      highlightColor: const Color(0xFF2A2A2A),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );
                }

                final list = ctrl.filteredUsers;

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.people, color: AppColors.textMuted, size: 44),
                        const SizedBox(height: 12),
                        Text('admin_no_users'.tr,
                            style: const TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.bgCard,
                  onRefresh: ctrl.fetchUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: list.length,
                    itemBuilder: (_, i) => _UserRow(
                      user: list[i],
                      controller: ctrl,
                      index: i,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ── User row ───────────────────────────────────────────────────────────────────
class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.controller, required this.index});
  final AdminUserModel user;
  final AdminUsersController controller;
  final int index;

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _UserOptionsSheet(user: user, controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rColor = controller.roleColor(user.role);

    // ── Obx هنا فقط على isBlocked لأنه يتغير ──────────────────────────────
    return Obx(() {
      final blocked = user.isBlocked.value;
      return GestureDetector(
            onTap: () => _showOptions(context),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: blocked
                      ? AppColors.dangerColor.withValues(alpha: 0.3)
                      : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: rColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: rColor.withValues(alpha: 0.4)),
                    ),
                    child: Center(
                      child: Text(
                        user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                        style: TextStyle(color: rColor, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.fullName.isNotEmpty ? user.fullName : 'no_name_label'.tr,
                                style: TextStyle(
                                  color: blocked ? AppColors.textMuted : AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: blocked ? TextDecoration.lineThrough : null,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: rColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: rColor.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                controller.roleLabel(user.role),
                                style: TextStyle(color: rColor, fontSize: 9, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                  blocked
                      ? const Icon(Icons.block_rounded, color: AppColors.dangerColor, size: 16)
                      : const Icon(Icons.more_vert_rounded, color: AppColors.textDim, size: 18),
                ],
              ),
            ),
          )
          .animate()
          .fadeIn(delay: Duration(milliseconds: 80 + (index * 50)), duration: 350.ms)
          .slideY(begin: 0.06, curve: Curves.easeOut);
    });
  }
}

// ── Options bottom sheet ───────────────────────────────────────────────────────
class _UserOptionsSheet extends StatelessWidget {
  const _UserOptionsSheet({required this.user, required this.controller});
  final AdminUserModel user;
  final AdminUsersController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user.fullName,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(user.email, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),

          // Change role
          Text(
            'admin_change_role'.tr,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8),
          ),
          const SizedBox(height: 10),
          Row(
            children: ['tenant', 'manager', 'super_admin'].map((role) {
              final selected = user.role == role;
              final rColor = controller.roleColor(role);
              return GestureDetector(
                onTap: () => controller.changeRole(user, role),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected ? rColor.withValues(alpha: 0.12) : AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? rColor.withValues(alpha: 0.6) : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    controller.roleLabel(role),
                    style: TextStyle(
                      color: selected ? rColor : AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Block toggle — Obx لأن isBlocked يتغير
          Obx(() {
            final blocked = user.isBlocked.value;
            return GestureDetector(
              onTap: () {
                Get.back();
                controller.toggleBlock(user);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: blocked ? AppColors.primaryBg : AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: blocked
                        ? AppColors.primary.withValues(alpha: 0.4)
                        : AppColors.dangerColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      blocked ? Icons.lock_open_rounded : Icons.block_rounded,
                      color: blocked ? AppColors.primary : AppColors.dangerColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      blocked ? 'admin_unblock_user'.tr : 'admin_block_user'.tr,
                      style: TextStyle(
                        color: blocked ? AppColors.primary : AppColors.dangerColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}