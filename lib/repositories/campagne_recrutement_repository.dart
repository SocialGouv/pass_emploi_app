import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';

class CampagneRecrutementRepository {
  final RemoteConfigRepository _repository;
  final FlutterSecureStorage _preferences;

  CampagneRecrutementRepository(this._repository, this._preferences);

  static const String _key = 'campagne-recrutement';

  Future<void> setCampagneRecrutementInitialRead() async {
    await _preferences.write(key: _key, value: 'read');
  }

  Future<void> dismissCampagneRecrutement() async {
    await _preferences.write(key: _key, value: _repository.lastCampagneRecrutementId());
  }

  Future<bool> isFirstLaunch() async {
    final String? lastCampagneId = await _preferences.read(key: _key);
    return lastCampagneId == null;
  }

  Future<bool> shouldShowCampagneRecrutement() async {
    final String? lastCampagneId = await _preferences.read(key: _key);
    final String? remoteCampagneId = _repository.lastCampagneRecrutementId();
    return remoteCampagneId != null && lastCampagneId != remoteCampagneId;
  }
}
