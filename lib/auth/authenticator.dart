import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_refresh_token_request.dart';
import 'auth_wrapper.dart';

const String _idTokenKey = "idToken";
const String _accessTokenKey = "accessToken";
const String _refreshTokenKey = "refreshToken";

class Authenticator {
  final AuthWrapper _authWrapper;
  final Configuration _configuration;
  final SharedPreferences _preferences;

  Authenticator(this._authWrapper, this._configuration, this._preferences);

  Future<AuthTokenResponse?> login() async {
    try {
      final response = await _authWrapper.login(
        AuthTokenRequest(
          _configuration.authClientId,
          _configuration.authLoginRedirectUrl,
          _configuration.authIssuer,
          _configuration.authScopes,
          _configuration.authClientSecret,
        ),
      );
      storeResponse(response);
      return response;
    } catch (e) {
      return null;
    }
  }

  void storeResponse(AuthTokenResponse response) {
    _preferences.setString(_idTokenKey, response.idToken);
    _preferences.setString(_accessTokenKey, response.accessToken);
    _preferences.setString(_refreshTokenKey, response.refreshToken);
  }

  bool isLoggedIn() => _preferences.containsKey(_idTokenKey);

  AuthIdToken? idToken() {
    final String? idToken = _preferences.getString(_idTokenKey);
    if (idToken != null) return AuthIdToken.parse(idToken);
    return null;
  }

  String? accessToken() => _preferences.getString(_accessTokenKey);

  Future<bool> refreshToken() async {
    final String refreshToken = _preferences.getString(_refreshTokenKey)!;
    AuthTokenResponse? response = await _authWrapper.refreshToken(
      AuthRefreshTokenRequest(
        _configuration.authClientId,
        _configuration.authLoginRedirectUrl,
        _configuration.authIssuer,
        refreshToken,
        _configuration.authClientSecret,
      ),
    );
    storeResponse(response);
    return true;
  }
}
