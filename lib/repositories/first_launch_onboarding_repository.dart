import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirstLaunchOnboardingRepository {
  final FlutterSecureStorage _preferences;

  static const _key = 'firstLaunchOnboarding';

  FirstLaunchOnboardingRepository(this._preferences);

  Future<void> seen() async {
    await _preferences.write(key: _key, value: "seen");
  }

  Future<bool> showFirstLaunchOnboarding() async {
    final result = await _preferences.read(key: _key);
    if (result == null) return true;
    return false;
  }
}
