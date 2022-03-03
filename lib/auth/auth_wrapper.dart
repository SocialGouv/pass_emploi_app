import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:pass_emploi_app/auth/auth_logout_request.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';

class AuthWrapper {
  final FlutterAppAuth _appAuth;

  AuthWrapper(this._appAuth);

  Future<AuthTokenResponse> login(AuthTokenRequest request) async {
    try {
      final response = await _appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        request.clientId,
        request.loginRedirectUrl,
        issuer: request.issuer,
        scopes: request.scopes,
        clientSecret: request.clientSecret,
        additionalParameters: request.additionalParameters,
      ));
      if (response != null &&
          response.idToken != null &&
          response.accessToken != null &&
          response.refreshToken != null) {
        return AuthTokenResponse(
          idToken: response.idToken!,
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
        );
      } else {
        throw AuthWrapperLoginException();
      }
    } on PlatformException catch (e) {
      if (e.code == "discovery_failed") {
        throw AuthWrapperNetworkException();
      } else if (e.code == "authorize_and_exchange_code_failed") {
        if (_isUserCancelled(e)) {
          throw UserCanceledLoginException();
        } else {
          throw AuthWrapperCalledCancelException();
        }
      } else {
        throw AuthWrapperLoginException();
      }
    }
  }

  bool _isUserCancelled(PlatformException e) =>
      e.message == "Failed to authorize: [error: null, description: User cancelled flow]" ||
      e.message == "Failed to authorize: L’opération n’a pas pu s’achever. (org.openid.appauth.general erreur -3.)";

  Future<AuthTokenResponse> refreshToken(AuthRefreshTokenRequest request) async {
    try {
      final response = await _appAuth.token(TokenRequest(
        request.clientId,
        request.loginRedirectUrl,
        issuer: request.issuer,
        clientSecret: request.clientSecret,
        refreshToken: request.refreshToken,
      ));
      if (response != null &&
          response.idToken != null &&
          response.accessToken != null &&
          response.refreshToken != null) {
        return AuthTokenResponse(
          idToken: response.idToken!,
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
        );
      } else {
        throw AuthWrapperRefreshTokenException();
      }
    } on PlatformException catch (e) {
      if (e.code == "network") {
        throw AuthWrapperNetworkException();
      } else if (e.code == "token_failed") {
        throw AuthWrapperRefreshTokenExpiredException();
      } else {
        debugPrint(e.toString());
        rethrow;
      }
    }
  }

  Future<void> logout(AuthLogoutRequest request) async {
    try {
      await _appAuth.endSession(EndSessionRequest(
        idTokenHint: request.idToken,
        postLogoutRedirectUrl: request.logoutRedirectUrl,
        issuer: request.issuer,
      ));
    } catch (e) {
      debugPrint(e.toString());
      throw AuthWrapperLogoutException();
    }
  }
}

class AuthWrapperLoginException implements Exception {}

class AuthWrapperRefreshTokenException implements Exception {}

class AuthWrapperLogoutException implements Exception {}

class AuthWrapperNetworkException implements Exception {}

class AuthWrapperRefreshTokenExpiredException implements AuthWrapperRefreshTokenException {}

class AuthWrapperCalledCancelException implements AuthWrapperLoginException {}

class UserCanceledLoginException implements AuthWrapperLoginException {}
