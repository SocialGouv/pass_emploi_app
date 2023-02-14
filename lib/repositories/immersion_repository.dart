import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';

class SearchImmersionRequest {
  final String codeRome;
  final Location location;
  final ImmersionFiltresRecherche filtres;

  SearchImmersionRequest({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });
}

class ImmersionRepository
    extends RechercheRepository<ImmersionCriteresRecherche, ImmersionFiltresRecherche, Immersion> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ImmersionRepository(this._httpClient, [this._crashlytics]);

  @override
  Future<RechercheResponse<Immersion>?> rechercher({
    required String userId,
    required RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche> request,
  }) async {
    const url = "/offres-immersion";
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParameters(request));
      final immersions = (response.data as List).map((offre) => Immersion.fromJson(offre)).toList();
      return RechercheResponse(results: immersions, canLoadMore: false);
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, String> _queryParameters(
    RechercheRequest<ImmersionCriteresRecherche, ImmersionFiltresRecherche> request,
  ) {
    return {
      'rome': request.criteres.metier.codeRome,
      'lat': request.criteres.location.latitude.toString(),
      'lon': request.criteres.location.longitude.toString(),
      if (request.filtres.distance != null) 'distance': request.filtres.distance.toString(),
    };
  }
}
