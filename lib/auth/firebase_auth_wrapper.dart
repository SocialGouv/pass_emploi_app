import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthWrapper {
  Future<bool> signInWithCustomToken(String token) async {
    try {
      await FirebaseAuth.instance.signInWithCustomToken(token);
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
