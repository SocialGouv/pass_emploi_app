import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';

import 'auth_logout_request.dart';
import 'auth_refresh_token_request.dart';
import 'auth_wrapper.dart';

const String _idTokenKey = "idToken";
const String _accessTokenKey = "accessToken";
const String _refreshTokenKey = "refreshToken";

enum RefreshTokenStatus { SUCCESSFUL, GENERIC_ERROR, USER_NOT_LOGGED_IN, NETWORK_UNREACHABLE, EXPIRED_REFRESH_TOKEN }

enum AuthenticationMode { GENERIC, SIMILO, POLE_EMPLOI }

const Map<String, String> similoAdditionalParameters = {"kc_idp_hint": "similo-jeune"};
const Map<String, String> poleEmploiAdditionalParameters = {"kc_idp_hint": "pe-jeune"};

enum AuthenticatorResponse { SUCCESS, FAILURE, CANCELLED }

class Authenticator {
  final AuthWrapper _authWrapper;
  final Configuration _configuration;
  final FlutterSecureStorage _preferences;

  Authenticator(this._authWrapper, this._configuration, this._preferences);

  Future<AuthenticatorResponse> login(AuthenticationMode mode) async {
    try {
      final response = await _authWrapper.login(
        AuthTokenRequest(
          _configuration.authClientId,
          _configuration.authLoginRedirectUrl,
          _configuration.authIssuer,
          _configuration.authScopes,
          _configuration.authClientSecret,
          _additionalParameters(mode),
        ),
      );
      _saveToken(response);
      return AuthenticatorResponse.SUCCESS;
    } catch (e) {
      return (e is UserCanceledLoginException) ? AuthenticatorResponse.CANCELLED : AuthenticatorResponse.FAILURE;
    }
  }

  Future<bool> isLoggedIn() async => await _preferences.read(key: _idTokenKey) != null;

  Future<AuthIdToken?> idToken() async {
    final String? idToken = await _preferences.read(key: _idTokenKey);
    if (idToken != null) return AuthIdToken.parse(idToken);
    return null;
  }

  Future<String?> accessToken() async => _preferences.read(key: _accessTokenKey);

  Future<RefreshTokenStatus> refreshToken() async {
    final String? refreshToken = await _preferences.read(key: _refreshTokenKey);
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
    final String? idToken = await _preferences.read(key: _idTokenKey);
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
    _preferences.write(key: _idTokenKey, value: response.idToken);
    _preferences.write(key: _accessTokenKey, value: response.accessToken);
    _preferences.write(key: _refreshTokenKey, value: response.refreshToken);
  }

  void _deleteToken() {
    _preferences.delete(key: _idTokenKey);
    _preferences.delete(key: _accessTokenKey);
    _preferences.delete(key: _refreshTokenKey);
  }

  Map<String, String>? _additionalParameters(AuthenticationMode mode) {
    if (mode == AuthenticationMode.SIMILO) {
      return similoAdditionalParameters;
    } else if (mode == AuthenticationMode.POLE_EMPLOI) {
      return poleEmploiAdditionalParameters;
    } else {
      return null;
    }
  }
}
