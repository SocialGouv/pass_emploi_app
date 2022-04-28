import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class SuppressionCompteRepository {
  final String _baseUrl;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  SuppressionCompteRepository(this._baseUrl, this._httpClient, [this._crashlytics]);

  Future<bool> deleteUser(String userId) async {
    final url = Uri.parse(_baseUrl + "/jeunes/$userId");
    try {
      final response = await _httpClient.delete(url);
      if (response.statusCode.isValid()) {
        return true;
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return false;
  }
}