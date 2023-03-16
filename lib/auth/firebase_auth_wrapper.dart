import 'package:firebase_auth/firebase_auth.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/utils/log.dart';

class FirebaseAuthWrapper {
  final Crashlytics? _crashlytics;

  FirebaseAuthWrapper([this._crashlytics]);

  Future<bool> signInWithCustomToken(String token) async {
    try {
      await FirebaseAuth.instance.signInWithCustomToken(token);
      return true;
    } catch (e, stack) {
      Log.w(e.toString());
      _crashlytics?.recordNonNetworkException(e, stack);
    }
    return false;
  }

  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
