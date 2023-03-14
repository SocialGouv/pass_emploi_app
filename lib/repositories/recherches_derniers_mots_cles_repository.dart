import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RecherchesDerniersMotsClesRepository {
  static const derniersMotsClesKey = 'derniers_mots_cles';
  final FlutterSecureStorage _preferences;
  RecherchesDerniersMotsClesRepository(this._preferences);

  Future<List<String>> getDerniersMotsCles() async {
    final String? motsClesString = await _preferences.read(key: derniersMotsClesKey);
    if (motsClesString == null) return [];
    final json = jsonDecode(motsClesString);
    return (json as List).map((e) => e as String).toList();
  }

  Future<void> saveDernierMotsCles(List<String> derniersMotsCles) async {
    await _preferences.write(key: derniersMotsClesKey, value: jsonEncode(derniersMotsCles));
  }
}
