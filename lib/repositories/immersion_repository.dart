import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_request.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SearchImmersionRequest {
  final String codeRome;
  final Location location;
  final ImmersionSearchParametersFiltres filtres;

  SearchImmersionRequest({
    required this.codeRome,
    required this.location,
    required this.filtres,
  });
}

class ImmersionRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  ImmersionRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<List<Immersion>?> search({required String userId, required SearchImmersionRequest request}) async {
    final url = Uri.parse(_baseUrl + "/offres-immersion").replace(
      query: _createQuery(request),
    );
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        final list = (json as List).map((offre) => Immersion.fromJson(offre)).toList();
        return list;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }

  String _createQuery(SearchImmersionRequest request) {
    final result = StringBuffer();
    var separator = "";

    void writeParameter(String key, String value) {
      result.write(separator);
      separator = "&";
      result.write(Uri.encodeQueryComponent(key));
      result.write("=");
      result.write(Uri.encodeQueryComponent(value));
    }

    writeParameter("rome", request.codeRome);

    writeParameter("lat", request.location.latitude.toString());
    writeParameter("lon", request.location.longitude.toString());

    if (request.filtres.distance != null) {
      writeParameter("distance", request.filtres.distance.toString());
    }
    return result.toString();
  }
}
