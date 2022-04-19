import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

const String _installationIdKey = '_installationId';

class InstallationIdRepository {
  final FlutterSecureStorage _preferences;

  InstallationIdRepository(this._preferences);

  Future<String> getInstallationId() async {
    String? installationId = await _preferences.read(key: _installationIdKey);
    if (installationId == null) {
      installationId = Uuid().v4();
      _preferences.write(key: _installationIdKey, value: installationId);
    }
    return installationId;
  }
}
