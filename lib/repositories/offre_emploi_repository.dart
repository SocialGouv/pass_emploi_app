import 'package:http/http.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';

class OffreEmploiRepository {
  static const PAGE_SIZE = 50;

  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;

  OffreEmploiRepository(this._baseUrl, this._httpClient, this._headerBuilder);

  Future<OffreEmploiSearchResponse?> search({
    required String userId,
    required String keywords,
    required Location? location,
    required int page,
    required OffreEmploiSearchParametersFiltres filtres,
  }) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi").replace(queryParameters: {
      if (keywords.isNotEmpty) "q": keywords,
      if (location?.type == LocationType.DEPARTMENT) "departement": location!.code,
      if (location?.type == LocationType.COMMUNE) "commune": location!.code,
      "page": page.toString(),
      "limit": PAGE_SIZE.toString(),
    });
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final list = (json["results"] as List).map((offre) => OffreEmploi.fromJson(offre)).toList();
        return OffreEmploiSearchResponse(isMoreDataAvailable: list.length == PAGE_SIZE, offres: list);
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}

class OffreEmploiSearchResponse {
  final bool isMoreDataAvailable;
  final List<OffreEmploi> offres;

  OffreEmploiSearchResponse({required this.isMoreDataAvailable, required this.offres});
}
