import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/login_mode.dart';

class PreferredLoginModeRepository {
  final FlutterSecureStorage _preferences;

  static const _key = 'preferredLoginMode';

  PreferredLoginModeRepository(this._preferences);

  Future<void> save(LoginMode loginMode) async {
    await _preferences.write(key: _key, value: loginMode.value);
  }

  Future<LoginMode?> getPreferredMode() async {
    final result = await _preferences.read(key: _key);
    if (result == null) return null;
    return LoginMode.fromString(result);
  }
}
