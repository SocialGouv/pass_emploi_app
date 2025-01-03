import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/location.dart';

class LocalisationPersistRepository {
  final FlutterSecureStorage _preferences;

  LocalisationPersistRepository(this._preferences);

  static const _key = 'localisationPersist';

  Future<void> save(Location? location) async {
    final locationString = location != null ? json.encode(location.toJson()) : null;
    await _preferences.write(key: _key, value: locationString);
  }

  Future<Location?> get() async {
    final result = await _preferences.read(key: _key);
    return result == null ? null : Location.fromJson(json.decode(result));
  }
}
