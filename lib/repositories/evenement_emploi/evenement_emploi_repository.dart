import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/models/secteur_activite.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';

class EvenementEmploiRepository
    extends RechercheRepository<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche, EvenementEmploi> {
  final Dio _httpClient;
  final SecteurActiviteQueryMapper _secteurActiviteQueryMapper;
  final Crashlytics? _crashlytics;

  EvenementEmploiRepository(this._httpClient, this._secteurActiviteQueryMapper, [this._crashlytics]);

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
    final secteur = request.criteres.secteurActivite;
    return {
      'codePostal': request.criteres.location.codePostal ?? request.criteres.location.code,
      if (secteur != null) 'secteurActivite': _secteurActiviteQueryMapper.getQueryParamValue(secteur),
    };
  }
}

class SecteurActiviteQueryMapper {
  String getQueryParamValue(SecteurActivite secteurActivite) {
    return switch (secteurActivite) {
      SecteurActivite.agriculture => 'A',
      SecteurActivite.art => 'B',
      SecteurActivite.banque => 'C',
      SecteurActivite.commerce => 'D',
      SecteurActivite.communication => 'E',
      SecteurActivite.batiment => 'F',
      SecteurActivite.tourisme => 'G',
      SecteurActivite.industrie => 'H',
      SecteurActivite.installation => 'I',
      SecteurActivite.sante => 'J',
      SecteurActivite.services => 'K',
      SecteurActivite.spectacle => 'L',
      SecteurActivite.support => 'M',
      SecteurActivite.transport => 'N',
    };
  }
}
