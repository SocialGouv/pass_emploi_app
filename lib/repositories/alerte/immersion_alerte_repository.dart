import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/alerte/immersion_alerte.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_alerte/post_immersion_alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_repository.dart';

class ImmersionAlerteRepository extends AlerteRepository<ImmersionAlerte> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ImmersionAlerteRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<bool> postAlerte(String userId, ImmersionAlerte alerte, String title) async {
    final url = "/jeunes/$userId/recherches/immersions";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostImmersionAlerte(
            title: title,
            metier: alerte.metier,
            localisation: alerte.ville,
            codeRome: alerte.codeRome,
            lat: alerte.location.latitude,
            lon: alerte.location.longitude,
            distance: alerte.filtres.distance,
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
