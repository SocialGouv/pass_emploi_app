import 'package:firebase_remote_config/firebase_remote_config.dart';

class MaxLivingTimeRemoteConfig {
  final FirebaseRemoteConfig? _firebaseRemoteConfig;

  MaxLivingTimeRemoteConfig(this._firebaseRemoteConfig);

  int? maxLivingTimeInSecondsForMilo() {
    if (_firebaseRemoteConfig == null) return null;

    final value = _firebaseRemoteConfig.getInt("app_milo_max_living_time_in_seconds");
    return value > 0 ? value : null;
  }
}
