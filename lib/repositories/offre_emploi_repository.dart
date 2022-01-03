import 'package:http/http.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/network/filtres_request.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

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
    final url = Uri.parse(_baseUrl + "/offres-emploi").replace(query: _createQuery(keywords, location, page, filtres));
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

  String _createQuery(String keywords, Location? location, int page, OffreEmploiSearchParametersFiltres filtres) {
    final result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }

    writeParameter("page", page.toString());
    writeParameter("limit", PAGE_SIZE.toString());
    if (keywords.isNotEmpty) {
      writeParameter("q", keywords);
    }
    if (location?.type == LocationType.DEPARTMENT) {
      writeParameter("departement", location!.code);
    }
    if (location?.type == LocationType.COMMUNE) {
      writeParameter("commune", location!.code);
    }
    if (filtres.distance != null) {
      writeParameter("rayon", filtres.distance.toString());
    }
    filtres.experience?.forEach((element) {
      writeParameter("experience", FiltresRequest.experienceToUrlParameter(element));
    });
    filtres.contrat?.forEach((element) {
      writeParameter("contrat", FiltresRequest.contratToUrlParameter(element));
    });
    filtres.duree?.forEach((element) {
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
