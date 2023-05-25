import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class EvenementEmploiRepository
    extends RechercheRepository<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche, EvenementEmploi> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  EvenementEmploiRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<EvenementEmploi>?> rechercher({
    required String userId,
    required RechercheRequest<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche> request,
  }) async {
    const url = '/evenements-emploi';
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParameters(request));
      final events = response.asListOfWithKey(
        'results',
        (event) => JsonEvenementEmploi.fromJson(event).toEvenementEmploi(),
      );
      return RechercheResponse(results: events, canLoadMore: false);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, String> _queryParameters(
    RechercheRequest<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche> request,
  ) {
    return {
      'codePostal': request.criteres.location.codePostal ?? request.criteres.location.code,
    };
  }
}
