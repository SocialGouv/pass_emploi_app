import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SearchOffreEmploiRequest {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;
  final int page;
  final OffreEmploiSearchParametersFiltres filtres;

  SearchOffreEmploiRequest({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
    required this.page,
    required this.filtres,
  });
}

class OffreEmploiRepository {
  static const PAGE_SIZE = 50;

  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  OffreEmploiRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<OffreEmploiSearchResponse?> search({required String userId, required SearchOffreEmploiRequest request}) async {
    final url = Uri.parse(_baseUrl + "/offres-emploi").replace(
      query: _createQuery(request),
    );
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final list = (json["results"] as List).map((offre) => OffreEmploi.fromJson(offre)).toList();
        return OffreEmploiSearchResponse(isMoreDataAvailable: list.length == PAGE_SIZE, offres: list);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  String _createQuery(SearchOffreEmploiRequest request) {
    final result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }

    if (request.onlyAlternance) {
      writeParameter("alternance", true.toString());
    }
    writeParameter("page", request.page.toString());
    writeParameter("limit", PAGE_SIZE.toString());
    if (request.keywords.isNotEmpty) {
      writeParameter("q", request.keywords);
    }
    if (request.location?.type == LocationType.DEPARTMENT) {
      writeParameter("departement", request.location!.code);
    }
    if (request.location?.type == LocationType.COMMUNE) {
      writeParameter("commune", request.location!.code);
    }
    if (request.filtres.distance != null) {
      writeParameter("rayon", request.filtres.distance.toString());
    }
    request.filtres.experience?.forEach((element) {
      writeParameter("experience", FiltresRequest.experienceToUrlParameter(element));
    });
    request.filtres.contrat?.forEach((element) {
      writeParameter("contrat", FiltresRequest.contratToUrlParameter(element));
    });
    request.filtres.duree?.forEach((element) {
      writeParameter("duree", FiltresRequest.dureeToUrlParameter(element));
    });
    return result.toString();
  }
}

extension Encoded on StringBuffer {
  void writeEncoded(String string) {
    write(Uri.encodeQueryComponent(string));
  }
}

class OffreEmploiSearchResponse {
  final bool isMoreDataAvailable;
  final List<OffreEmploi> offres;

  OffreEmploiSearchResponse({required this.isMoreDataAvailable, required this.offres});
}
