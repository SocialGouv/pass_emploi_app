import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_externe.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';

//TODO: mode demo json

class EvenementsExternesRepository extends RechercheRepository<EvenementsExternesCriteresRecherche,
    EvenementsExternesFiltresRecherche, EvenementExterne> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  EvenementsExternesRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<EvenementExterne>?> rechercher({
    required String userId,
    required RechercheRequest<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche> request,
  }) async {
    const url = "/todo"; //TODO: url repository à voir avec le back
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParameters(request));
      final events = (response.data as List).map((event) => EvenementExterne.fromJson(event)).toList();
      return RechercheResponse(results: events, canLoadMore: false);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, String> _queryParameters(
    RechercheRequest<EvenementsExternesCriteresRecherche, EvenementsExternesFiltresRecherche> request,
  ) {
    //TODO: queryParameters à voir avec le back pour location
    return {
      'lat': request.criteres.location.latitude.toString(),
      'lon': request.criteres.location.longitude.toString(),
    };
  }
}
