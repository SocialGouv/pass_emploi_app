import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';

class AuthWrapper {
  final FlutterAppAuth _appAuth;

  AuthWrapper(this._appAuth);

  Future<AuthTokenResponse?> login(AuthTokenRequest request) async {
    final response = await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
      request.clientId,
      request.loginRedirectUrl,
      issuer: request.issuer,
      scopes: request.scopes,
      clientSecret: request.clientSecret,
    ));
    if (response != null && response.idToken != null && response.accessToken != null && response.refreshToken != null) {
      return AuthTokenResponse(
        idToken: response.idToken!,
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken!,
      );
    }
    return null;
  }

  Future<AuthTokenResponse?> refreshToken(AuthRefreshTokenRequest request) async {
    final response = await _appAuth.token(TokenRequest(
      request.clientId,
      request.loginRedirectUrl,
      issuer: request.issuer,
      clientSecret: request.clientSecret,
      refreshToken: request.refreshToken,
    ));
    if (response != null && response.idToken != null && response.accessToken != null && response.refreshToken != null) {
      return AuthTokenResponse(
        idToken: response.idToken!,
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken!,
      );
    }
    return null;
  }
}
