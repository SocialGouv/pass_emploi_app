import 'package:dio/dio.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';

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

class ImmersionRepository {
  final Dio _httpClient;
  final Crashlytics? _crashlytics;

  ImmersionRepository(this._httpClient, [this._crashlytics]);

  Future<List<Immersion>?> search({required String userId, required SearchImmersionRequest request}) async {
    const url = "/offres-immersion";
    try {
      final response = await _httpClient.get(url, queryParameters: _queryParameters(request));
      return (response.data as List).map((offre) => Immersion.fromJson(offre)).toList();
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkExceptionUrl(e, stack, url);
    }
    return null;
  }

  Map<String, String> _queryParameters(SearchImmersionRequest request) {
    return {
      'rome': request.codeRome,
      if (request.location != null) 'lat': request.location!.latitude.toString(),
      if (request.location != null) 'lon': request.location!.longitude.toString(),
      if (request.filtres.distance != null) 'distance': request.filtres.distance.toString(),
    };
  }
}
