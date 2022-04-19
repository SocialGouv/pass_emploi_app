import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SearchServiceCiviqueRequest {
  final String? domain;
  final Location? location;
  final int? distance;
  final String? startDate;
  final String? endDate;
  final int page;

  SearchServiceCiviqueRequest({
    required this.domain,
    required this.location,
    required this.distance,
    required this.startDate,
    required this.endDate,
    required this.page,
  });
}

class ServiceCiviqueRepository {
  static const PAGE_SIZE = 50;

  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  ServiceCiviqueRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<ServiceCiviqueSearchResponse?> search({
    required String userId,
    required SearchServiceCiviqueRequest request,
    required List<ServiceCivique> previousOffers,
  }) async {
    final url = Uri.parse(_baseUrl + "/services-civique").replace(
      query: _createQuery(request),
    );
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final list = (json as List).map((offre) => ServiceCivique.fromJson(offre)).toList();
        return ServiceCiviqueSearchResponse(
          isMoreDataAvailable: list.length == PAGE_SIZE,
          offres: List.from(previousOffers)..addAll(list),
          lastRequest: request,
        );
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  String _createQuery(SearchServiceCiviqueRequest request) {
    final result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }

    writeParameter("page", request.page.toString());
    writeParameter("limit", PAGE_SIZE.toString());
    if (request.location?.latitude != null) {
      writeParameter("lat", request.location!.latitude.toString());
    }
    if (request.location?.longitude != null) {
      writeParameter("lon", request.location!.longitude.toString());
    }
    if (request.distance != null) {
      writeParameter("distance", request.distance.toString());
    }
    if (request.startDate != null && request.startDate!.isNotEmpty) {
      writeParameter("dateDeDebutMinimum", request.startDate!);
    }
    if (request.endDate != null && request.endDate!.isNotEmpty) {
      writeParameter("dateDeDebutMaximum", request.endDate!);
    }
    if (request.domain != null && request.domain!.isNotEmpty) {
      writeParameter("domaine", request.domain!);
    }
    return result.toString();
  }
}

class ServiceCiviqueSearchResponse {
  final bool isMoreDataAvailable;
  final SearchServiceCiviqueRequest lastRequest;
  final List<ServiceCivique> offres;

  ServiceCiviqueSearchResponse({
    required this.isMoreDataAvailable,
    required this.offres,
    required this.lastRequest,
  });
}
