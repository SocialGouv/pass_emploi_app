import 'package:firebase_remote_config/firebase_remote_config.dart';

class CvmRemoteConfig {
  final FirebaseRemoteConfig? _firebaseRemoteConfig;

  CvmRemoteConfig(this._firebaseRemoteConfig);

  bool useCvm() {
    if (_firebaseRemoteConfig == null) return false;
    return _firebaseRemoteConfig.getBool('use_cvm');
  }

  List<String> getIdsConseillerCvmEarlyAdopters() {
    if (_firebaseRemoteConfig == null) return [];
    return _firebaseRemoteConfig.getString('ids_conseiller_cvm_early_adopters').split(',');
  }
}
