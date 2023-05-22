import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

//Todo: tests repo

class EvenementsExternesRepository
    extends RechercheRepository<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche, Rendezvous> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  EvenementsExternesRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<Rendezvous>?> rechercher({
    required String userId,
    required RechercheRequest<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche> request,
  }) async {
    if (1 == 1) {
      //TODO: fake
      final events = await gettt(userId, DateTime.now()) ?? [];
      return RechercheResponse(results: events, canLoadMore: false);
    }

    const url = "/offres-immersion"; //Todo: url repository
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParameters(request));
      final events = (response.data as List).map((event) => JsonRendezvous.fromJson(event).toRendezvous()).toList();
      return RechercheResponse(results: events, canLoadMore: false);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, String> _queryParameters(
    RechercheRequest<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche> request,
  ) {
    return {
      'lat': request.criteres.location.latitude.toString(),
      'lon': request.criteres.location.longitude.toString(),
    };
  }

  ///

  Future<List<Rendezvous>?> gettt(String userId, DateTime maintenant) async {
    final date = Uri.encodeComponent(maintenant.toIso8601WithOffsetDateTime());
    final url = "/jeunes/$userId/animations-collectives?maintenant=$date";
    try {
      final response = await _httpClient.get(url);
      return (response.data as List).map((event) => JsonRendezvous.fromJson(event).toRendezvous()).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }
}
