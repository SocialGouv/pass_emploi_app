import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class Crashlytics {
  void setCustomKey(String key, dynamic value);
}

class CrashlyticsWithFirebase extends Crashlytics {
  final FirebaseCrashlytics instance;

  CrashlyticsWithFirebase(this.instance);

  @override
  void setCustomKey(String key, value) {
    instance.setCustomKey(key, value);
  }
}
