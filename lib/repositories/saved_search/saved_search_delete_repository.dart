import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SavedSearchDeleteRepository {
  final String _baseUrl;
  final Client _httpClient;
  final HeadersBuilder _headerBuilder;
  final Crashlytics? _crashlytics;

  SavedSearchDeleteRepository(this._baseUrl, this._httpClient, this._headerBuilder, [this._crashlytics]);

  Future<bool> delete(String userId, String savedSearchId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/" + userId + "/recherches/" + savedSearchId);
    try {
      final response = await _httpClient.delete(url, headers: await _headerBuilder.headers(userId: userId));
      if (response.statusCode.isValid()) return true;
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}
