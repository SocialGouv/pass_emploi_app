import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigRepository {
  final FirebaseRemoteConfig? _firebaseRemoteConfig;

  RemoteConfigRepository(this._firebaseRemoteConfig);

  int? maxLivingTimeInSecondsForMilo() {
    if (_firebaseRemoteConfig == null) return null;

    final value = _firebaseRemoteConfig.getInt("app_milo_max_living_time_in_seconds");
    return value > 0 ? value : null;
  }

  int monSuiviPoleEmploiStartDateInMonths() {
    if (_firebaseRemoteConfig == null) return 0;
    return _firebaseRemoteConfig.getInt("mon_suivi_ft_start_date_in_months");
  }

  String? lastCampagneRecrutementId() {
    if (_firebaseRemoteConfig == null) return null;

    // millisecond since epoch
    final value = _firebaseRemoteConfig.getInt("campagne_recrutement_date_fin");
    return value > DateTime.now().millisecondsSinceEpoch ? value.toString() : null;
  }

  bool useCvm() {
    if (_firebaseRemoteConfig == null) return false;
    return _firebaseRemoteConfig.getBool('use_cvm');
  }

  List<String> getIdsConseillerCvmEarlyAdopters() {
    if (_firebaseRemoteConfig == null) return [];
    return _firebaseRemoteConfig.getString('ids_conseiller_cvm_early_adopters').split(',');
  }

  bool usePj() {
    if (_firebaseRemoteConfig == null) return false;
    return _firebaseRemoteConfig.getBool('use_pj');
  }

  List<String> getIdsMiloPjEarlyAdopters() {
    if (_firebaseRemoteConfig == null) return [];
    return _firebaseRemoteConfig.getString('ids_milo_pj_early_adopters').split(',');
  }
}
