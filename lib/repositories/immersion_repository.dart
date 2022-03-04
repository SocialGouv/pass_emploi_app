import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';
import 'package:pass_emploi_app/redux/requests/immersion_request.dart';

class ImmersionRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  ImmersionRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<List<Immersion>?> getImmersions(String userId, ImmersionRequest request) async {
    final url = Uri.parse(_baseUrl + "/offres-immersion").replace(queryParameters: {
      'rome': request.codeRome,
      'lat': request.location.latitude.toString(),
      'lon': request.location.longitude.toString(),
    });
    try {
      final response = await _httpClient.get(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return (json as List).map((immersion) => Immersion.fromJson(immersion)).toList();
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
