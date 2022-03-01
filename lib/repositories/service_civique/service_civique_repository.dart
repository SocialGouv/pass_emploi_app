import 'package:http/http.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/network/status_code.dart';

import '../../crashlytics/crashlytics.dart';
import '../../network/headers.dart';
import '../../network/json_utf8_decoder.dart';

class ServiceCiviqueDetailRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headersBuilder;
  final Crashlytics? _crashlytics;

  ServiceCiviqueDetailRepository(this._baseUrl, this._httpClient, this._headersBuilder, [this._crashlytics]);

  Future<ServiceCiviqueDetail?> getServiceCiviqueDetail(String idOffre) async {
    final url = Uri.parse(_baseUrl + "/services-civique/$idOffre");
    try {
      final response = await _httpClient.get(url, headers: await _headersBuilder.headers());
      if (response.statusCode.isValid()) {
        final Map<dynamic, dynamic> json = jsonUtf8Decode(response.bodyBytes) as Map<dynamic, dynamic>;
        return ServiceCiviqueDetail.fromJson(json);
      } else {
        return null;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
