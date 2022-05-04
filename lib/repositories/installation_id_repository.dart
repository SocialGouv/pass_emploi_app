import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

const String _installationIdKey = '_installationId';

class InstallationIdRepository {
  final FlutterSecureStorage _preferences;
  final Lock _lock = Lock();

  InstallationIdRepository(this._preferences);

  Future<String> getInstallationId() async {
    return _lock.synchronized(() async {
      String? installationId = await _preferences.read(key: _installationIdKey);
      if (installationId == null) {
        installationId = Uuid().v4();
        _preferences.write(key: _installationIdKey, value: installationId);
      }
      return installationId;
    });
  }
}
