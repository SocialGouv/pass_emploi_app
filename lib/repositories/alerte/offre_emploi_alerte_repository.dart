import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/alerte/offre_emploi_alerte.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_alerte/post_offre_emploi_alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_repository.dart';

class OffreEmploiAlerteRepository extends AlerteRepository<OffreEmploiAlerte> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  OffreEmploiAlerteRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<bool> postAlerte(String userId, OffreEmploiAlerte alerte, String title) async {
    final url = "/jeunes/$userId/recherches/offres-emploi";
    try {
      await _httpClient.post(
        url,
        data: customJsonEncode(
          PostOffreEmploiAlerte(
            title: title,
            metier: alerte.metier,
            localisation: alerte.location,
            keywords: alerte.keyword,
            isAlternance: alerte.onlyAlternance,
            debutantOnly: alerte.filters.debutantOnly,
            experience: alerte.filters.experience,
            contrat: alerte.filters.contrat,
            duration: alerte.filters.duree,
            rayon: alerte.filters.distance,
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
