import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeveloperOptionRepository {
  final FlutterSecureStorage _preferences;

  DeveloperOptionRepository(this._preferences);

  Future<void> deleteAllPrefs() async => await _preferences.deleteAll();
}
