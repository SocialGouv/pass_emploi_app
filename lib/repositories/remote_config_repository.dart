import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/cgu.dart';
import 'package:pass_emploi_app/models/feedback_for_feature.dart';

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

  Map<Accompagnement, bool> cvmActivationByAccompagnement() {
    if (_firebaseRemoteConfig == null) return {};
    final String cvmAsString = _firebaseRemoteConfig.getString('cvm');
    // Despite Remote config documentation, Firebase returns "null" string value when key is not found
    if (cvmAsString.isEmpty || cvmAsString == "null") return {};
    final cvmAsJson = json.decode(cvmAsString);
    return {
      Accompagnement.cej: cvmAsJson['cej'] as bool,
      Accompagnement.rsaFranceTravail: cvmAsJson['rsaFranceTravail'] as bool,
      Accompagnement.rsaConseilsDepartementaux: cvmAsJson['rsaConseilsDepartementaux'] as bool,
      Accompagnement.aij: cvmAsJson['aij'] as bool,
    };
  }

  bool withCje() {
    if (_firebaseRemoteConfig == null) return false;
    return _firebaseRemoteConfig.getBool('with_cje');
  }

  List<String> getIdsConseillerCvmEarlyAdopters() {
    if (_firebaseRemoteConfig == null) return [];
    return _firebaseRemoteConfig.getString('ids_conseiller_cvm_early_adopters').split(',');
  }

  Cgu? getCgu() {
    if (_firebaseRemoteConfig == null) return null;
    final String cguAsString = _firebaseRemoteConfig.getString('cgu');
    // Despite Remote config documentation, Firebase returns "null" string value when key is not found
    if (cguAsString.isEmpty || cguAsString == "null") return null;
    return Cgu.fromJson(json.decode(cguAsString));
  }

  FeedbackForFeature? inAppFeedbackForFeature(String feature) {
    if (_firebaseRemoteConfig == null) return null;
    final String inAppFeedbackAsString = _firebaseRemoteConfig.getString('in_app_feedback_for_feature');
    // Despite Remote config documentation, Firebase returns "null" string value when key is not found
    if (inAppFeedbackAsString.isEmpty || inAppFeedbackAsString == "null") return null;
    final inAppFeedbackAsJson = json.decode(inAppFeedbackAsString);
    final feedbackForFeatureAsJson = inAppFeedbackAsJson[feature];
    return feedbackForFeatureAsJson != null ? FeedbackForFeature.fromJson(feedbackForFeatureAsJson) : null;
  }
}
