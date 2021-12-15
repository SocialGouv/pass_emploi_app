import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_logout_request.dart';
import 'auth_refresh_token_request.dart';
import 'auth_wrapper.dart';

const String _idTokenKey = "idToken";
const String _accessTokenKey = "accessToken";
const String _refreshTokenKey = "refreshToken";

enum RefreshTokenStatus { SUCCESSFUL, GENERIC_ERROR, USER_NOT_LOGGED_IN, NETWORK_UNREACHABLE, EXPIRED_REFRESH_TOKEN }

enum AuthenticationMode { GENERIC, SIMILO }

const Map<String, String> similoAdditionalParameters = {"kc_idp_hint": "similo-jeune"};

class Authenticator {
  final AuthWrapper _authWrapper;
  final Configuration _configuration;
  final SharedPreferences _preferences;

  Authenticator(this._authWrapper, this._configuration, this._preferences);

  Future<bool> login(AuthenticationMode mode) async {
    try {
      final response = await _authWrapper.login(
        AuthTokenRequest(
          _configuration.authClientId,
          _configuration.authLoginRedirectUrl,
          _configuration.authIssuer,
          _configuration.authScopes,
          _configuration.authClientSecret,
          mode == AuthenticationMode.SIMILO ? similoAdditionalParameters : null,
        ),
      );
      _saveToken(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isLoggedIn() => _preferences.containsKey(_idTokenKey);

  AuthIdToken? idToken() {
    final String? idToken = _preferences.getString(_idTokenKey);
    if (idToken != null) return AuthIdToken.parse(idToken);
    return null;
  }

  String? accessToken() => _preferences.getString(_accessTokenKey);

  Future<RefreshTokenStatus> refreshToken() async {
    final String? refreshToken = _preferences.getString(_refreshTokenKey);
    if (refreshToken == null) return RefreshTokenStatus.USER_NOT_LOGGED_IN;

    try {
      AuthTokenResponse response = await _authWrapper.refreshToken(
        AuthRefreshTokenRequest(
          _configuration.authClientId,
          _configuration.authLoginRedirectUrl,
          _configuration.authIssuer,
          refreshToken,
          _configuration.authClientSecret,
        ),
      );
      _saveToken(response);
      return RefreshTokenStatus.SUCCESSFUL;
    } on AuthWrapperNetworkException {
      return RefreshTokenStatus.NETWORK_UNREACHABLE;
    } on AuthWrapperRefreshTokenExpiredException {
      _deleteToken();
      return RefreshTokenStatus.EXPIRED_REFRESH_TOKEN;
    } on AuthWrapperRefreshTokenException {
      return RefreshTokenStatus.GENERIC_ERROR;
    }
  }

  Future<bool> logout() async {
    final String? idToken = _preferences.getString(_idTokenKey);
    if (idToken == null) return false;
    try {
      await _authWrapper.logout(AuthLogoutRequest(
        idToken,
        _configuration.authLogoutRedirectUrl,
        _configuration.authIssuer,
      ));
      _deleteToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _saveToken(AuthTokenResponse response) {
    _preferences.setString(_idTokenKey, response.idToken);
    _preferences.setString(_accessTokenKey, response.accessToken);
    _preferences.setString(_refreshTokenKey, response.refreshToken);
  }

  void _deleteToken() {
    _preferences.remove(_idTokenKey);
    _preferences.remove(_accessTokenKey);
    _preferences.remove(_refreshTokenKey);
  }
}
