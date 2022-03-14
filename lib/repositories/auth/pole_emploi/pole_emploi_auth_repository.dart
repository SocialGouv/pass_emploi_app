import 'package:http/http.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/network/status_code.dart';

class PoleEmploiAuthRepository {
  final String _authIssuer;
  final Client _httpClient;
  final Crashlytics? _crashlytics;

  PoleEmploiAuthRepository(this._authIssuer, this._httpClient, [this._crashlytics]);

  Future<AuthTokenResponse?> getPoleEmploiToken() async {
    final url = Uri.parse(_authIssuer + "/broker/pe-jeune/token");
    try {
      final response = await _httpClient.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode.isValid()) {
        final json = jsonUtf8Decode(response.bodyBytes);
        return AuthTokenResponse(
          idToken: json['id_token'] as String,
          accessToken: json['access_token'] as String,
          refreshToken: json['refresh_token'] as String,
        );
      }
    } catch (e, stack) {
      _crashlytics?.recordNonNetworkException(e, stack, url);
    }
    return null;
  }
}
