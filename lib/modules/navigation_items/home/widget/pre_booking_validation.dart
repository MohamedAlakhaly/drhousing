import 'package:apartment_rentals/core/constant/app_colors.dart';
import 'package:apartment_rentals/core/constant/app_state.dart';
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/models/static/apartment_model.dart';
import 'package:apartment_rentals/modules/navigation_items/home/widget/booking_bottom_sheet.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/edit_personal_info/view/edit_personal_info_view.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/controller/tenant_card_controller.dart';
import 'package:apartment_rentals/modules/navigation_items/profile/modules/tenant_card_edit/view/tenant_card_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _bg = Color(0xFF121212);
const _card = Color(0xFF1E1E1E);
const _neon = Color(0xFFCCFF00);
const _neonDim = Color(0x33CCFF00);
const _textPrimary = Color(0xFFF5F5F5);
const _textMuted = Color(0xFF888888);
const _divider = Color(0xFF2E2E2E);
const _danger = Color(0xFFE24B4A);
const _dangerDim = Color(0x1AE24B4A);
const _amber = Color(0xFFFFA726);
const _amberDim = Color(0x1AFFA726);

// ── Entry point — runs all 3 checks in sequence ───────────────────────────────

Future<void> showBookingWithValidation(
  BuildContext context,
  ApartmentModel apartment,
) async {
  // ── Check 1: User profile completeness ──────────────────────────────────
  final userCtrl = Get.find<UserController>();
  final missingProfile = <String>[];
  if (userCtrl.displayName.trim().isEmpty) missingProfile.add('full_name'.tr);
  if (userCtrl.phoneNumber.trim().isEmpty) missingProfile.add('phone_number_label'.tr);
  if (userCtrl.employmentStatus.trim().isEmpty) missingProfile.add('employment_status_label'.tr);

  if (missingProfile.isNotEmpty) {
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileIncompleteSheet(missingFields: missingProfile),
    );
    return;
  }

  // ── Check 2: Tenant card completeness ────────────────────────────────────
  final tenantCtrl = Get.find<TenantCardController>();
  final missingTenant = <String>[];
  if (tenantCtrl.selectedMaritalStatus.value.trim().isEmpty) {
    missingTenant.add('marital_status_label'.tr);
  }
  if (tenantCtrl.occupantsCount.value == 0) {
    missingTenant.add('number_of_occupants'.tr);
  }
  if (tenantCtrl.monthlyBudget.value == 0) {
    missingTenant.add('max_monthly_rent'.tr);
  }

  if (missingTenant.isNotEmpty) {
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TenantCardIncompleteSheet(missingFields: missingTenant),
    );
    return;
  }

  // ── Check 3: Active booking exists ───────────────────────────────────────
  final supabase = Supabase.instance.client;
  final uid = supabase.auth.currentUser?.id;
  if (uid != null) {
    final rows = await supabase
        .from('bookings')
        .select('id, status, apartments(title)')
        .eq('user_id', uid)
        .inFilter('status', ['pending', 'confirmed'])
        .limit(1);

    if ((rows as List).isNotEmpty) {
      if (!context.mounted) return;
      final row = rows.first as Map<String, dynamic>;
      final aptTitle =
          (row['apartments'] as Map<String, dynamic>?)?['title'] as String? ??
          '—';
      final bookingStatus = row['status'] as String? ?? 'pending';
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _ActiveBookingSheet(
          apartmentTitle: aptTitle,
          bookingStatus: bookingStatus,
        ),
      );
      return;
    }
  }

  // ── All checks pass ──────────────────────────────────────────────────────
  if (!context.mounted) return;
  showBookingBottomSheet(context, apartment);
}

// ── Shared helpers ────────────────────────────────────────────────────────────

Widget _handle() => Center(
  child: Container(
    margin: const EdgeInsets.only(top: 12, bottom: 24),
    width: 40,
    height: 4,
    decoration: BoxDecoration(
      color: _divider,
      borderRadius: BorderRadius.circular(2),
    ),
  ),
);

Widget _missingRow(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: Row(
    children: [
      Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(color: _dangerDim, shape: BoxShape.circle),
        child: const Icon(Icons.close_rounded, color: _danger, size: 13),
      ),
      const SizedBox(width: 10),
      Text(
        label,
        style: const TextStyle(
          color: _textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  ),
);

Widget _primaryBtn(String label, VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: _neon,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: _neon.withValues(alpha: 0.28),
          blurRadius: 18,
          spreadRadius: 1,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ),
);

Widget _secondaryBtn(String label, VoidCallback onTap) => GestureDetector(
  onTap: onTap,
  child: Center(
    child: Text(
      label,
      style: const TextStyle(
        color: _textMuted,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
);

// ── Sheet 1 — Profile incomplete ──────────────────────────────────────────────

class _ProfileIncompleteSheet extends StatelessWidget {
  final List<String> missingFields;
  const _ProfileIncompleteSheet({required this.missingFields});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),

          // Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _neonDim,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: _neon,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'complete_profile_first'.tr,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'complete_profile_first_message'.tr,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          ...missingFields.map(_missingRow),
          const SizedBox(height: 24),

          _primaryBtn('complete_profile_btn'.tr, () {
            Navigator.pop(context);
            Get.to(() => const EditPersonalInfoView());
          }),
          const SizedBox(height: 12),

          _secondaryBtn('maybe_later'.tr, () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// ── Sheet 2 — Tenant card incomplete ─────────────────────────────────────────

class _TenantCardIncompleteSheet extends StatelessWidget {
  final List<String> missingFields;
  const _TenantCardIncompleteSheet({required this.missingFields});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _neonDim,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.badge_outlined,
              color: _neon,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'complete_tenant_card'.tr,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'complete_tenant_card_first_message'.tr,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          ...missingFields.map(_missingRow),
          const SizedBox(height: 24),

          _primaryBtn('edit_tenant_card_btn'.tr, () {
            Navigator.pop(context);
            Get.to(() => const TenantCardEditView());
          }),
          const SizedBox(height: 12),

          _secondaryBtn('maybe_later'.tr, () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

// ── Sheet 3 — Active booking exists ──────────────────────────────────────────

class _ActiveBookingSheet extends StatelessWidget {
  final String apartmentTitle;
  final String bookingStatus;
  const _ActiveBookingSheet({
    required this.apartmentTitle,
    required this.bookingStatus,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        bookingStatus == 'confirmed' ? AppColors.primary : _amber;
    final statusBg =
        bookingStatus == 'confirmed' ? AppColors.primaryBg : _amberDim;
    final statusLabel =
        bookingStatus[0].toUpperCase() + bookingStatus.substring(1);

    return Container(
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),

          // Lock icon — amber tint
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _amberDim,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: _amber,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'active_booking_exists'.tr,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'active_booking_exists_message'.tr,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Active booking info card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _divider),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.home_outlined, color: statusColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    apartmentTitle,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _primaryBtn('view_my_bookings'.tr, () {
            context.mounted ? Navigator.pop(context) : null;
            
            AppState.currentIndex.value = 2;
          }),
          const SizedBox(height: 12),

          _secondaryBtn('cancelButton'.tr, () => Get.back()),
        ],
      ),
    );
  }
}
