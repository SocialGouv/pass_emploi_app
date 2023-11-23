import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/alerte/service_civique_alerte.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_alerte/post_service_civique_alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_repository.dart';

class ServiceCiviqueAlerteRepository extends AlerteRepository<ServiceCiviqueAlerte> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ServiceCiviqueAlerteRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<bool> postAlerte(String userId, ServiceCiviqueAlerte alerte, String title) async {
    final url = "/jeunes/$userId/recherches/services-civique";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostServiceCiviqueAlerte(
            titre: title,
            localisation: alerte.ville,
            lat: alerte.location?.latitude,
            lon: alerte.location?.longitude,
            distance: alerte.filtres.distance,
            dateDeDebutMinimum: alerte.dateDeDebut?.toIso8601String(),
            domaine: alerte.domaine?.tag,
          ),
        ),
      );
      return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return false;
  }
}
