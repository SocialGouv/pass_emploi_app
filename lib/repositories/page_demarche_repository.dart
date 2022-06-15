import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class PageDemarcheRepository {
  final String _baseUrl;
  final Client _httpClient;

  final Crashlytics? _crashlytics;

  PageDemarcheRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<PageDemarches?> getPageDemarches(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId/home/demarches");
    try {
      final response = await _httpClient.get(url);
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return PageDemarches.fromJson(json);
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
