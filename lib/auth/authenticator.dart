import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';

const String _idTokenKey = "idToken";
const String _accessTokenKey = "accessToken";
const String _refreshTokenKey = "refreshToken";

enum RefreshTokenStatus { SUCCESSFUL, GENERIC_ERROR, USER_NOT_LOGGED_IN, NETWORK_UNREACHABLE, EXPIRED_REFRESH_TOKEN }

enum AuthenticationMode { GENERIC, SIMILO, POLE_EMPLOI, DEMO }

const Map<String, String> similoAdditionalParams = {"kc_idp_hint": "similo-jeune"};
const Map<String, String> poleEmploiCejAdditionalParams = {"kc_idp_hint": "pe-jeune"};
const Map<String, String> poleEmploiBrsaAdditionalParams = {"kc_idp_hint": "pe-brsa-jeune"};

sealed class AuthenticatorResponse {}

class SuccessAuthenticatorResponse extends AuthenticatorResponse {}

class CancelledAuthenticatorResponse extends AuthenticatorResponse {}

class WrongDeviceClockAuthenticatorResponse extends AuthenticatorResponse {}

class FailureAuthenticatorResponse extends AuthenticatorResponse {
  final String message;

  FailureAuthenticatorResponse(this.message);
}

class Authenticator {
  final AuthWrapper _authWrapper;
  final LogoutRepository _logoutRepository;
  final Configuration _configuration;
  final FlutterSecureStorage _preferences;
  final Crashlytics? _crashlytics;

  Authenticator(this._authWrapper, this._logoutRepository, this._configuration, this._preferences, [this._crashlytics]);

  Future<AuthenticatorResponse> login(AuthenticationMode mode) async {
    try {
      final response = await _authWrapper.login(
        AuthTokenRequest(
          _configuration.authClientId,
          _configuration.authLoginRedirectUrl,
          _configuration.authIssuer,
          _configuration.authScopes,
          _configuration.authClientSecret,
          _additionalParams(mode),
        ),
      );
      await _saveToken(response);
      return SuccessAuthenticatorResponse();
    } catch (e) {
      if (e is UserCanceledLoginException) return CancelledAuthenticatorResponse();
      if (e is AuthWrapperWrongDeviceClockException) return WrongDeviceClockAuthenticatorResponse();
      return FailureAuthenticatorResponse(e.toString());
    }
  }

  Future<bool> isLoggedIn() async => await idToken() != null;

  Future<AuthIdToken?> idToken() async {
    final String? idToken = await _preferences.read(key: _idTokenKey);
    if (idToken != null) {
      try {
        return AuthIdToken.parse(idToken);
      } catch (e, stack) {
        _crashlytics?.recordNonNetworkException("Corrupted ID token : $idToken", stack);
        await _preferences.delete(key: _idTokenKey);
      }
    }
    return null;
  }

  Future<String?> accessToken() async => _preferences.read(key: _accessTokenKey);

  Future<RefreshTokenStatus> performRefreshToken() async {
    final String? refreshToken = await _preferences.read(key: _refreshTokenKey);
    if (refreshToken == null) return RefreshTokenStatus.USER_NOT_LOGGED_IN;

    try {
      final AuthTokenResponse response = await _authWrapper.refreshToken(
        AuthRefreshTokenRequest(
          _configuration.authClientId,
          _configuration.authLoginRedirectUrl,
          _configuration.authIssuer,
          refreshToken,
          _configuration.authClientSecret,
        ),
      );
      await _saveToken(response);
      return RefreshTokenStatus.SUCCESSFUL;
    } on AuthWrapperNetworkException {
      return RefreshTokenStatus.NETWORK_UNREACHABLE;
    } on AuthWrapperRefreshTokenExpiredException {
      await _deleteToken();
      return RefreshTokenStatus.EXPIRED_REFRESH_TOKEN;
    } on AuthWrapperRefreshTokenException {
      return RefreshTokenStatus.GENERIC_ERROR;
    }
  }

  Future<bool> logout(String userId, LogoutReason reason) async {
    final String? refreshToken = await _preferences.read(key: _refreshTokenKey);
    if (refreshToken == null) return false;
    await _logoutRepository.logout(refreshToken, userId, reason);
    await _deleteToken();
    return true;
  }

  Future<void> _saveToken(AuthTokenResponse response) async {
    await _preferences.write(key: _idTokenKey, value: response.idToken);
    await _preferences.write(key: _accessTokenKey, value: response.accessToken);
    await _preferences.write(key: _refreshTokenKey, value: response.refreshToken);
  }

  Future<void> _deleteToken() async {
    await _preferences.delete(key: _idTokenKey);
    await _preferences.delete(key: _accessTokenKey);
    await _preferences.delete(key: _refreshTokenKey);
  }

  Map<String, String>? _additionalParams(AuthenticationMode mode) {
    if (mode == AuthenticationMode.SIMILO) return similoAdditionalParams;
    if (mode == AuthenticationMode.POLE_EMPLOI && _configuration.brand.isCej) return poleEmploiCejAdditionalParams;
    if (mode == AuthenticationMode.POLE_EMPLOI && _configuration.brand.isBrsa) return poleEmploiBrsaAdditionalParams;
    return null;
  }
}
