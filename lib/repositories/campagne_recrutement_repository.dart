import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/remote_config/campagne_recrutement_config.dart';

class CampagneRecrutementRepository {
  CampagneRecrutementRepository(this._preferences, this.campagneConfig);

  final CampagneRecrutementConfig campagneConfig;
  final FlutterSecureStorage _preferences;

  static const String _key = 'campagne-recrutement';

  Future<void> setCampagneRecrutementInitialRead() async {
    await _preferences.write(key: _key, value: 'read');
  }

  Future<void> dismissCampagneRecrutement() async {
    await _preferences.write(key: _key, value: campagneConfig.lastCampagneId());
  }

  Future<bool?> shouldShowCampagneRecrutement() async {
    try {
      final String? lastCampagneId = await _preferences.read(key: _key);
      if (lastCampagneId == null) {
        setCampagneRecrutementInitialRead();
        return false;
      }
      return lastCampagneId != campagneConfig.lastCampagneId();
    } catch (e) {
      return null;
    }
  }
}
