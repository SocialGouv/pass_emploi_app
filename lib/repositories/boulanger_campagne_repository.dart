import 'package:clock/clock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BoulangerCampagneRepository {
  final FlutterSecureStorage _preferences;
  final Clock? clock;

  static const _key = 'boulangerCampagne';

  BoulangerCampagneRepository(this._preferences, {this.clock});

  Future<void> save() async {
    await _preferences.write(key: _key, value: 'true');
  }

  Future<bool> get() async {
    final now = clock?.now() ?? DateTime.now();
    if (now.isAfter(DateTime(2025, 9, 15))) {
      return false;
    }
    final result = await _preferences.read(key: _key);
    return result == null ? true : false;
  }
}
