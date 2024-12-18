import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DateConsultationNotificationRepository {
  final FlutterSecureStorage _preferences;

  static const _key = 'dateDerniereConsultationNotification';

  DateConsultationNotificationRepository(this._preferences);

  Future<void> save(DateTime date) async {
    await _preferences.write(key: _key, value: date.toIso8601String());
  }

  Future<DateTime?> get() async {
    final result = await _preferences.read(key: _key);
    return result == null ? null : DateTime.parse(result);
  }
}
