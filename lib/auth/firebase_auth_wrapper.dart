import 'package:firebase_auth/firebase_auth.dart';
import 'package:pass_emploi_app/utils/log.dart';

class FirebaseAuthWrapper {
  Future<bool> signInWithCustomToken(String token) async {
    try {
      await FirebaseAuth.instance.signInWithCustomToken(token);
      return true;
    } catch (e) {
      Log.w(e.toString());
    }
    return false;
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
