import 'dart:convert';

import 'package:http/http.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';

class LogoutRepository {
  final String _authIssuer;
  final String _clientSecret;
  final String _clientId;
  final Crashlytics? _crashlytics;
  late Client _httpClient;

  LogoutRepository(
    this._authIssuer,
    this._clientSecret,
    this._clientId, [
    this._crashlytics,
  ]);

  Future<void> logout(String refreshToken) async {
    final url = Uri.parse(_authIssuer + "/protocol/openid-connect/logout");
    try {
      await _httpClient.post(
        url,
        encoding: Encoding.getByName('utf-8'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'refresh_token': refreshToken,
          'client_secret': _clientSecret,
        },
      );
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
  }

  void setHttpClient(Client httpClient) {
    _httpClient = httpClient;
  }
}
