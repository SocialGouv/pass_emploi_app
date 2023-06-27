import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/network/dio_ext.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';

class OffreEmploiRepository extends RechercheRepository<EmploiCriteresRecherche, EmploiFiltresRecherche, OffreEmploi> {
  static const PAGE_SIZE = 50;

  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  OffreEmploiRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<OffreEmploi>?> rechercher({
    required String userId,
    required RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  }) async {
    const url = '/offres-emploi';
    try {
      final response = await _httpClient.get(
        url,
        queryParameters: _queryParams(request),
        // required to send query parameters as expected by backend
        // e.g.foo=value&foo=another_value rather foo=value,another_value
        options: Options(listFormat: ListFormat.multi),
      );
      final list = response.asListOfWithKey('results', (json) => OffreEmploi.fromJson(json));
      return RechercheResponse(canLoadMore: list.length == PAGE_SIZE, results: list);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, dynamic> _queryParams(RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request) {
    return {
      ..._alternanceQueryParams(request),
      ..._experienceQueryParam(request),
      ..._contratQueryParam(request),
      ..._dureeQueryParam(request),
      'page': request.page.toString(),
      'limit': PAGE_SIZE.toString(),
      if (request.criteres.keyword.isNotEmpty) 'q': request.criteres.keyword,
      if (request.criteres.location?.type == LocationType.DEPARTMENT) 'departement': request.criteres.location!.code,
      if (request.criteres.location?.type == LocationType.COMMUNE) 'commune': request.criteres.location!.code,
      if (request.filtres.distance != null) 'rayon': request.filtres.distance.toString(),
      if (request.filtres.debutantOnly != null) 'debutantAccepte': request.filtres.debutantOnly.toString(),
    };
  }

  Map<String, dynamic> _experienceQueryParam(
    RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request
  ) {
    final experiences = request.filtres.experience;
    if (experiences == null || experiences.isEmpty) return {};
    return {'experience': experiences.map(FiltresRequest.experienceToUrlParameter).toList()};
  }

  Map<String, dynamic> _contratQueryParam(
    RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  ) {
    final contrats = request.filtres.contrat;
    if (contrats == null || contrats.isEmpty) return {};
    return {'contrat': contrats.map(FiltresRequest.contratToUrlParameter).toList()};
  }

  Map<String, dynamic> _dureeQueryParam(
    RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  ) {
    final durees = request.filtres.duree;
    if (durees == null || durees.isEmpty) return {};
    return {'duree': durees.map(FiltresRequest.dureeToUrlParameter).toList()};
  }

  Map<String, String> _alternanceQueryParams(
    RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche> request,
  ) {
    return switch (request.criteres.rechercheType) {
      RechercheType.onlyOffreEmploi => {'alternance': false.toString()},
      RechercheType.onlyAlternance => {'alternance': true.toString()},
      RechercheType.offreEmploiAndAlternance => {},
    };
  }
}

class OffreEmploiSearchResponse {
  final bool isMoreDataAvailable;
  final List<OffreEmploi> offres;

  OffreEmploiSearchResponse({required this.isMoreDataAvailable, required this.offres});
}
