import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_encoder.dart';
import 'package:pass_emploi_app/network/post_saved_search/post_service_civique_saved_search.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_repository.dart';

class ServiceCiviqueSavedSearchRepository extends SavedSearchRepository<ServiceCiviqueSavedSearch> {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  ServiceCiviqueSavedSearchRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  @override
  Future<bool> postSavedSearch(String userId, ServiceCiviqueSavedSearch savedSearch, String title) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/recherches/services-civique");
    try {
      final response = await _httpClient.post(
        url,
        headers: await _headersBuilder.headers(contentType: 'application/json'),
        body: customJsonEncode(
          PostServiceCiviqueSavedSearch(
            titre: title,
            localisation: savedSearch.ville,
            lat: savedSearch.location?.latitude,
            lon: savedSearch.location?.longitude,
            distance: savedSearch.filtres.distance,
            dateDeDebutMinimum: savedSearch.dateDeDebut,
            domaine: savedSearch.domaine?.titre,
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
