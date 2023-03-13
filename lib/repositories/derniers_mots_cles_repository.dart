import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DerniersMotsClesRepository {
  static const derniersMotsClesKey = 'derniers_mots_cles';
  final FlutterSecureStorage _preferences;
  DerniersMotsClesRepository(this._preferences);

  Future<List<String>> getDerniersMotsCles() async {
    final String? motsClesString = await _preferences.read(key: derniersMotsClesKey);
    if (motsClesString == null) return [];
    final json = jsonDecode(motsClesString);
    return (json as List).map((e) => e as String).toList();
  }
}
