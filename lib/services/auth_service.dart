import 'package:amflix/pages/first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  static Future<void> logout(BuildContext context) async {
    try {
      // logout Google (jika login pakai Google)
      await _googleSignIn.signOut();

      // logout Firebase (email/password & google)
      await FirebaseAuth.instance.signOut();

      // clear navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const First()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }
}
