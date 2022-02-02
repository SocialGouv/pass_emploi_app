import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_saved_search/post_offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';

class OffreEmploiSavedSearchRepository extends SavedSearchRepository<OffreEmploiSavedSearch> {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  OffreEmploiSavedSearchRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  @override
  Future<bool> postSavedSearch(String userId, OffreEmploiSavedSearch savedSearch) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/offres-emploi");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headersBuilder.headers(contentType: 'application/json'),
        body: customJsonEncode(
          PostOffreEmploiSavedSearch(
            title: savedSearch.title,
            metier: savedSearch.metier,
            localisation: savedSearch.location,
            keywords: savedSearch.keywords,
            isAlternance: savedSearch.isAlternance,
            experience: savedSearch.filters.experience,
            contrat: savedSearch.filters.contrat,
            duration: savedSearch.filters.duree,
            rayon: savedSearch.filters.distance,
          ),
        ),
      );
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
