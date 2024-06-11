import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CvmLastReadingRepository {
  static const String _key = 'cvm_last_reading';

  final FlutterSecureStorage _preferences;

  CvmLastReadingRepository(this._preferences);

  Future<void> saveLastJeuneReading(DateTime lastReading) async {
    await _preferences.write(key: _key, value: lastReading.toIso8601String());
  }

  Future<DateTime?> getLastJeuneReading() async {
    final String? lastReading = await _preferences.read(key: _key);
    return lastReading != null ? DateTime.parse(lastReading) : null;
  }
}
