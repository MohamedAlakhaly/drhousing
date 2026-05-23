import 'dart:developer';

import 'package:apartment_rentals/modules/auth/logic_view/view/logic_view.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class GoogleAuthService {
  static const _webClientId =
      '700482179982-5vlkjnsubp12nbh1lglcljifcg44dmn0.apps.googleusercontent.com';

  /// Call once at app startup, after Supabase.initialize().
  static Future<void> initialize() async {
    await GoogleSignIn.instance.initialize(serverClientId: _webClientId);
  }

  static Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        Get.snackbar('socialAuthErrorTitle'.tr, 'socialAuthErrorContent'.tr);
        return;
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = response.user;
      if (user == null) return;

      await _saveProfileToDatabase(
        uid: user.id,
        fullName: googleUser.displayName ?? '',
        email: googleUser.email,
        // avatarUrl: googleUser.photoUrl ?? '',
      );

      Get.offAll(() => const LogicView());
    } catch (e) {
      log(e.toString());
      Get.snackbar('socialAuthErrorTitle'.tr, 'socialAuthErrorContent'.tr);
    }
  }

  // في GoogleAuthService أضف دالة منفصلة للويب
static Future<void> signInWithGoogleWeb() async {
   final redirectTo = kIsWeb
      ? (kDebugMode
          ? 'http://localhost:5000'      // development
          : 'https://drhousing.be')      // production
      : 'io.supabase.apartmentrentals://login-callback';
  await supabase.auth.signInWithOAuth(
    OAuthProvider.google,
    redirectTo: redirectTo,
    queryParams: {
      'prompt': 'select_account',
      'access_type': 'offline',
    },
  );
}


  static Future<void> _saveProfileToDatabase({
    required String uid,
    required String fullName,
    required String email,
    // required String avatarUrl,
  }) async {
    await supabase.from('profiles').upsert(
      {
        'id': uid,
        'full_name': fullName,
        'email': email,
        // 'avatar_url': avatarUrl,
        'is_premium': false,
      },
      onConflict: 'id',
      ignoreDuplicates: true,
    );
  }

  static Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await supabase.auth.signOut();
  }
}
