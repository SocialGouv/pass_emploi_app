import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/alerte/evenement_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_json_extractor.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_response.dart';

class RecherchesRecentesRepository {
  static const recentSearchesKey = 'recent_searches';
  final FlutterSecureStorage _preferences;

  RecherchesRecentesRepository(this._preferences);

  Future<List<Alerte>> get() async {
    final String? recentSearchesJsonString = await _preferences.read(key: recentSearchesKey);
    if (recentSearchesJsonString == null) {
      return [];
    }
    final json = jsonDecode(recentSearchesJsonString);
    final list = (json as List).map((search) => AlerteResponse.fromJson(search)).toList();
    return list.map((e) => AlerteJsonExtractor().extract(e)).whereNotNull().toList();
  }

  Future<void> save(List<Alerte> alertes) async {
    final json =
        alertes.map((alerte) => alerte.toAlerteResponse()).whereNotNull().map((response) => response.toJson()).toList();
    await _preferences.write(key: recentSearchesKey, value: jsonEncode(json));
  }
}

extension _AlerteExt on Alerte {
  AlerteResponse? toAlerteResponse() {
    final alerte = this;
    if (alerte is OffreEmploiAlerte) return alerte.toAlerteResponse();
    if (alerte is ImmersionAlerte) return alerte.toAlerteResponse();
    if (alerte is ServiceCiviqueAlerte) return alerte.toAlerteResponse();
    if (alerte is EvenementEmploiAlerte) return alerte.toAlerteResponse();
    return null;
  }
}
