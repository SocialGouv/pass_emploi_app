import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/models/remote_campagne_accueil.dart';
import 'package:pass_emploi_app/repositories/remote_config_repository.dart';

class RemoteCampagneAccueilRepository {
  final RemoteConfigRepository _repository;
  final FlutterSecureStorage _preferences;

  RemoteCampagneAccueilRepository(
    RemoteConfigRepository repository,
    FlutterSecureStorage preferences,
  )   : _repository = repository,
        _preferences = preferences;

  static const String _key = 'campagne-accueil';

  Future<List<RemoteCampagneAccueil>> getCampagnes() async {
    final dismissedCampagnes = await getDismissedCampagnes();
    final campagnes = _repository.campagnesAccueil();
    final List<RemoteCampagneAccueil> campagnesToShow = [];
    for (final campagne in campagnes) {
      if (!dismissedCampagnes.containsKey(campagne.id)) {
        campagnesToShow.add(campagne);
      }
    }
    return campagnesToShow;
  }

  Future<void> dismissCampagne(String campagneId) async {
    final dismissedCampagnes = await getDismissedCampagnes();
    dismissedCampagnes[campagneId] = DateTime.now().millisecondsSinceEpoch;
    final jsonEncoded = jsonEncode(dismissedCampagnes);
    await _preferences.write(key: _key, value: jsonEncoded);
  }

  Future<Map<String, dynamic>> getDismissedCampagnes() async {
    final String? dismissedCampagnes = await _preferences.read(key: _key);
    if (dismissedCampagnes == null) return {};
    final json = jsonDecode(dismissedCampagnes) as Map<String, dynamic>;
    return json;
  }
}
