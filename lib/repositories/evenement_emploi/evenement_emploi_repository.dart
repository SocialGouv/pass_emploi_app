import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/evenement_emploi/evenement_emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_modalite.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_type.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class EvenementEmploiRepository
    extends RechercheRepository<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche, EvenementEmploi> {
  static const PAGE_SIZE = 20;

  final Dio _httpClient;
  final SecteurActiviteQueryMapper _secteurActiviteQueryMapper;
  final EvenementEmploiTypeQueryMapper _typeQueryMapper;
  final Crashlytics? _crashlytics;

  EvenementEmploiRepository(
    this._httpClient,
    this._secteurActiviteQueryMapper,
    this._typeQueryMapper, [
    this._crashlytics,
  ]);

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
      return RechercheResponse(results: events, canLoadMore: events.length == PAGE_SIZE);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, String> _queryParameters(
    RechercheRequest<EvenementEmploiCriteresRecherche, EvenementEmploiFiltresRecherche> request,
  ) {
    final secteur = request.criteres.secteurActivite;
    final type = request.filtres.type;
    final modaliteQueryParamValue = _modaliteQueryParamValue(request.filtres.modalites);
    return {
      'page': '${request.page}',
      'limit': '$PAGE_SIZE',
      'codePostal': request.criteres.location.codePostal ?? request.criteres.location.code,
      if (secteur != null) 'secteurActivite': _secteurActiviteQueryMapper.getQueryParamValue(secteur),
      if (type != null) 'typeEvenement': _typeQueryMapper.getQueryParamValue(type),
      if (modaliteQueryParamValue != null) 'modalite': modaliteQueryParamValue,
      if (request.filtres.dateDebut != null) 'dateDebut': request.filtres.dateDebut!.toStartOfDay().toIso8601String(),
      if (request.filtres.dateFin != null) 'dateFin': request.filtres.dateFin!.toEndOfDay().toIso8601String(),
    };
  }

  String? _modaliteQueryParamValue(List<EvenementEmploiModalite>? modalites) {
    return switch (modalites) {
      [EvenementEmploiModalite.enPhysique] => 'ENPHY',
      [EvenementEmploiModalite.aDistance] => 'ADIST',
      _ => null,
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

class EvenementEmploiTypeQueryMapper {
  String getQueryParamValue(EvenementEmploiType type) {
    return switch (type) {
      EvenementEmploiType.reunionInformation => '13',
      EvenementEmploiType.forum => '14',
      EvenementEmploiType.conference => '15',
      EvenementEmploiType.atelier => '16',
      EvenementEmploiType.salonEnLigne => '17',
      EvenementEmploiType.jobDating => '18',
      EvenementEmploiType.visiteEntreprise => '31',
      EvenementEmploiType.portesOuvertes => '32',
    };
  }
}
