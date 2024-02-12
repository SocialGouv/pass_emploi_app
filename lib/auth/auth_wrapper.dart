import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/crashlytics/crashlytics.dart';
import 'package:synchronized/synchronized.dart';

class AuthWrapper {
  final FlutterAppAuth _appAuth;
  final Lock _lock;
  final Crashlytics? _crashlytics;

  AuthWrapper(this._appAuth, this._lock, [this._crashlytics]);

  Future<AuthTokenResponse> login(AuthTokenRequest request) async {
    return _lock.synchronized(() async {
      return _login(request);
    });
  }

  Future<AuthTokenResponse> _login(AuthTokenRequest request) async {
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
        _crashlytics?.recordNonNetworkException("Incorrect Login output : response $response");
        throw AuthWrapperLoginException();
      }
    } on PlatformException catch (e, stack) {
      if (e.isNetworkException()) throw AuthWrapperNetworkException();
      if (e.isDeviceClockWrong()) throw AuthWrapperWrongDeviceClockException();
      if (e.isCodeExchangeFailing() && e.isUserCancellation()) throw UserCanceledLoginException();
      if (e.isCodeExchangeFailing() && !e.isUserCancellation()) throw AuthWrapperCalledCancelException();
      _crashlytics?.recordNonNetworkException(e, stack);
      throw AuthWrapperLoginException();
    }
  }

  Future<AuthTokenResponse> refreshToken(AuthRefreshTokenRequest request) async {
    return _lock.synchronized(() async {
      return _refreshToken(request);
    });
  }

  Future<AuthTokenResponse> _refreshToken(AuthRefreshTokenRequest request) async {
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
        _crashlytics?.recordNonNetworkException("Incorrect Refresh token output : response $response");
        throw AuthWrapperRefreshTokenException();
      }
    } on PlatformException catch (e, stack) {
      if (e.isNetworkException()) throw AuthWrapperNetworkException();
      _crashlytics?.recordNonNetworkException(e, stack);
      if (e.isRefreshTokenExpired()) throw AuthWrapperRefreshTokenExpiredException();
      throw AuthWrapperRefreshTokenException();
    }
  }
}

class AuthWrapperLoginException implements Exception {}

class AuthWrapperRefreshTokenException implements Exception {}

class AuthWrapperLogoutException implements Exception {}

class AuthWrapperNetworkException implements Exception {}

class AuthWrapperWrongDeviceClockException implements Exception {}

class AuthWrapperRefreshTokenExpiredException implements AuthWrapperRefreshTokenException {}

class AuthWrapperCalledCancelException implements AuthWrapperLoginException {}

class UserCanceledLoginException implements AuthWrapperLoginException {}

extension on PlatformException {
  bool isNetworkException() => code == "discovery_failed" || code == "network";

  bool isCodeExchangeFailing() => code == "authorize_and_exchange_code_failed";

  bool isUserCancellation() {
    return message?.contains('User cancelled flow') == true ||
        message?.contains('org.openid' '.appauth.general erreur -3') == true;
  }

  bool isDeviceClockWrong() => details.toString().contains('minutes');

  bool isRefreshTokenExpired() => code == "token_failed";
}
