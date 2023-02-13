import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_criteres_recherche.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/recherche/recherche_repository.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';

//TODO(1356) migrer tests vers la nouvelle fonction après nettoyage

class SearchImmersionRequest {
  final String codeRome;
  final Location? location;
  final ImmersionSearchParametersFiltres filtres;

  SearchImmersionRequest({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });
}

class ImmersionRepository
    extends RechercheRepository<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres, Immersion> {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ImmersionRepository(this._httpClient, [this._crashlytics]);

  //TODO(1356): old
  Future<List<Immersion>?> search({required String userId, required SearchImmersionRequest request}) async {
    const url = "/offres-immersion";
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParametersOld(request));
      return (response.data as List).map((offre) => Immersion.fromJson(offre)).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  //TODO(1356): old
  Map<String, String> _queryParametersOld(SearchImmersionRequest request) {
    return {
      'rome': request.codeRome,
      if (request.location != null) 'lat': request.location!.latitude.toString(),
      if (request.location != null) 'lon': request.location!.longitude.toString(),
      if (request.filtres.distance != null) 'distance': request.filtres.distance.toString(),
    };
  }

  @override
  Future<RechercheResponse<Immersion>?> rechercher({
    required String userId,
    required RechercheRequest<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres> request,
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
    RechercheRequest<ImmersionCriteresRecherche, ImmersionSearchParametersFiltres> request,
  ) {
    return {
      'rome': request.criteres.metier.codeRome,
      'lat': request.criteres.location.latitude.toString(),
      'lon': request.criteres.location.longitude.toString(),
      if (request.filtres.distance != null) 'distance': request.filtres.distance.toString(),
    };
  }
}
