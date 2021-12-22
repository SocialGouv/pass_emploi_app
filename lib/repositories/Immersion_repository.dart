import 'package:http/http.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class ImmersionRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;

  ImmersionRepository(this._baseUrl, this._httpClient, this._headerBuilder);

  Future<List<Immersion>?> getImmersions({
    required String userId,
    required String codeRome,
    required Location location,
  }) async {
    final url = Uri.parse(_baseUrl + "/offres-immersion").replace(queryParameters: {
      'rome': codeRome,
      'lat': location.latitude.toString(),
      'lon': location.longitude.toString(),
    });
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((immersion) => Immersion.fromJson(immersion)).toList();
      }
    } catch (e) {
      print('Exception on ${url.toString()}: ' + e.toString());
    }
    return null;
  }
}
