import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/session_milo_details.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

class SessionMiloRepository {
  final Dio _httpClient;
  final DetailsJeuneRepository? _jeuneRepository;
  final FirebaseRemoteConfig? _remoteConfig;
  final Crashlytics? _crashlytics;

  SessionMiloRepository(this._httpClient, [this._jeuneRepository, this._remoteConfig, this._crashlytics]);

  Future<List<SessionMilo>?> getList({required String userId, bool? filtrerEstInscrit}) async {
    if (await featureIsActive(userId) == false) return [];

    final param = filtrerEstInscrit != null ? "?filtrerEstInscrit=$filtrerEstInscrit" : "";
    final url = "/jeunes/milo/$userId/sessions$param";

    try {
      final response = await _httpClient.get(url);
      return response.asListOf((session) => SessionMilo.fromJson(session));
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Future<SessionMiloDetails?> getDetails({required String userId, required String sessionId}) async {
    if (await featureIsActive(userId) == false) return null;
    final url = "/jeunes/milo/$userId/sessions/$sessionId";
    try {
      final response = await _httpClient.get(url);
      return SessionMiloDetails.fromJson(response.data);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  /*
   * La feature est active si :
   * - pas de remote config
   * - pas de champ sessions_milo_desactives
   * - un champ sessions_milo_desactives à false
   * - l'ID structure du jeune est dans les early adopters
   */
  Future<bool> featureIsActive(String userId) async {
    if (_remoteConfig == null) return true;

    final bool featureIsActive = !(_remoteConfig.getBool('sessions_milo_desactives'));
    if (featureIsActive) return true;

    final idsStructureEarlyAdopters = _remoteConfig.getString('ids_structure_early_adopter_sessions').split('|');
    final idStructureJeune = (await _jeuneRepository?.fetch(userId))?.structure?.id;

    if (idsStructureEarlyAdopters.contains(idStructureJeune)) return true;

    return false;
  }
}
