import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenements_externes/evenements_externes_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_externe.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';


// TODO: 1655 - delete comments
/*
Entrée
// Code postal (obligatoire)
Secteur d'activité : de A à N… (optionnel)


{
    pagination: {
      page: 1,
      limit: 20, // 20 limite max
      total: 1
    },
    results: [
      {
        id: '11111',
        ville: 'Paris',
        codePostal: '75012',
        type: 'Atelier', String
        heureDebut: '07:00:00',
        heureFin: '09:00:00',
        dateEvenement: '2023-05-17T07:00:00.000+00:00',
        titre: 'Atelier du travail',
        modalites: [
          "en physique","a distance"
        ]
    ]
  }

 */
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
    const url = '/evenements-emploi';
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParameters(request));
      final events = response.asListOfWithKey('results', (event) => EvenementExterne.fromJson(event));
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
      'codePostal': request.criteres.location.codePostal ?? request.criteres.location.code,
    };
  }
}
