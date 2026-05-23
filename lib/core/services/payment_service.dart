import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:apartment_rentals/core/controllers/user_controller.dart';
import 'package:apartment_rentals/core/widgets/paywall_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:apartment_rentals/core/services/web_redirect_stub.dart'
    if (dart.library.html) 'package:apartment_rentals/core/services/web_redirect.dart';
final _supabase = Supabase.instance.client;

const _supabaseUrl = 'https://bjrhshhmjjyggzfuogsu.supabase.co';
const _anonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJqcmhzaGhtamp5Z2d6ZnVvZ3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY4NTA3ODcsImV4cCI6MjA5MjQyNjc4N30.6zlKDgHvFQIXIrrQZrIT6L1dqoWccz30YowoWi3ikac';

class PaymentService {
  PaymentService._();

  static Future<void> startPremiumCheckout() async {
    try {
      final uid = _supabase.auth.currentUser?.id;
      final email = _supabase.auth.currentUser?.email ?? '';
      if (uid == null) return;

      final response = await http.post(
        Uri.parse('$_supabaseUrl/functions/v1/create-checkout'),
        headers: {
          'Content-Type': 'application/json',
          'apikey': _anonKey,
          'Authorization': 'Bearer $_anonKey',
        },
        body: jsonEncode({'userId': uid, 'userEmail': email}),
      );

      log('Payment response status: ${response.statusCode}');
      log('Payment response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Error: ${response.body}');
      }

      final data = jsonDecode(response.body);
      final url = data['url'] as String?;
      if (url == null) throw Exception('No checkout URL returned');

      if (kIsWeb) {
        assignUrl(url);
      } else {
        await launchUrl(
          Uri.parse(url),
          mode: defaultTargetPlatform == TargetPlatform.iOS
              ? LaunchMode.inAppWebView
              : LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      log('PaymentService.startPremiumCheckout: $e');
      Get.snackbar(
        'Payment Error',
        'Could not open checkout. Please try again.',
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFe24b4a),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    await Get.find<UserController>().fetchUserData();
    if (Get.find<UserController>().isPremium) {
      Get.back();
      Get.snackbar(
        '🎉 Welcome to Premium!',
        'You now have full access to Dr Housing.',
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFCCFF00),
        duration: const Duration(seconds: 3),
      );
    }
  }

  static void requirePremium(BuildContext context, VoidCallback onAllowed) {
    final isPremium = Get.find<UserController>().isPremium;
    if (isPremium) {
      onAllowed();
    } else {
      showPaywallBottomSheet(context);
    }
  }
}
