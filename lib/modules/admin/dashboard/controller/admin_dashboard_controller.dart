import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class AdminDashboardController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxInt totalApartments = 0.obs;
  final RxInt totalBookings = 0.obs;
  final RxInt totalUsers = 0.obs;
  final RxInt confirmedBookings = 0.obs;
  final RxInt pendingBookings = 0.obs;

  @override
  void onInit() {
    fetchStats();
    super.onInit();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _supabase.from('apartments').select('id'),
        _supabase.from('bookings').select('id, status'),
        _supabase.from('profiles').select('id'),
      ]);

      final apts = results[0] as List;
      final bookings = results[1] as List;
      final users = results[2] as List;

      totalApartments.value = apts.length;
      totalBookings.value = bookings.length;
      totalUsers.value = users.length;
      confirmedBookings.value =
          bookings.where((b) => b['status'] == 'confirmed').length;
      pendingBookings.value =
          bookings.where((b) => b['status'] == 'pending').length;
    } catch (e) {
      log('AdminDashboardController.fetchStats: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
