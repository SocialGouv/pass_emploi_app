import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class CampagneRecrutementConfig {
  String? lastCampagneId();
}

class CampagneRecrutementRemoteConfig implements CampagneRecrutementConfig {
  final FirebaseRemoteConfig? _firebaseRemoteConfig;

  CampagneRecrutementRemoteConfig(this._firebaseRemoteConfig);

  @override
  String? lastCampagneId() {
    if (_firebaseRemoteConfig == null) return null;

    // millisecond since epoch
    final value = _firebaseRemoteConfig.getInt("campagne_recrutement_date_fin");
    return value > DateTime.now().millisecondsSinceEpoch ? value.toString() : null;
  }
}
