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
      if (response.idToken != null && response.accessToken != null && response.refreshToken != null) {
        return AuthTokenResponse(
          idToken: response.idToken!,
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
        );
      } else {
        final message = "Incorrect Login output : response $response";
        _crashlytics?.recordNonNetworkException(message);
        throw AuthWrapperLoginException(message);
      }
    } on PlatformException catch (e, stack) {
      final message = e.toString();
      if (e.isNetworkException()) throw AuthWrapperNetworkException(message);
      if (e.isDeviceClockWrong()) throw AuthWrapperWrongDeviceClockException(message);
      if (e.isCodeExchangeFailing() && e.isUserCancellation()) throw UserCanceledLoginException(message);
      if (e.isCodeExchangeFailing() && !e.isUserCancellation()) throw AuthWrapperCalledCancelException(message);
      _crashlytics?.recordNonNetworkException(e, stack);
      throw AuthWrapperLoginException(message);
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
      if (response.idToken != null && response.accessToken != null && response.refreshToken != null) {
        return AuthTokenResponse(
          idToken: response.idToken!,
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
        );
      } else {
        final message = "Incorrect Refresh token output : response $response";
        _crashlytics?.recordNonNetworkException(message);
        throw AuthWrapperRefreshTokenException(message);
      }
    } on PlatformException catch (e, stack) {
      final message = e.toString();
      if (e.isNetworkException()) throw AuthWrapperNetworkException(message);
      _crashlytics?.recordNonNetworkException(e, stack);
      if (e.isRefreshTokenExpired()) throw AuthWrapperRefreshTokenExpiredException(message);
      throw AuthWrapperRefreshTokenException(message);
    }
  }
}

class AuthWrapperException implements Exception {
  final String? message;

  AuthWrapperException(this.message);

  @override
  String toString() => message ?? super.toString();
}

class AuthWrapperLoginException extends AuthWrapperException {
  AuthWrapperLoginException(super.message);
}

class AuthWrapperRefreshTokenException extends AuthWrapperException {
  AuthWrapperRefreshTokenException(super.message);
}

class AuthWrapperLogoutException extends AuthWrapperException {
  AuthWrapperLogoutException(super.message);
}

class AuthWrapperNetworkException extends AuthWrapperException {
  AuthWrapperNetworkException(super.message);
}

class AuthWrapperWrongDeviceClockException extends AuthWrapperLoginException {
  AuthWrapperWrongDeviceClockException(super.message);
}

class AuthWrapperCalledCancelException extends AuthWrapperLoginException {
  AuthWrapperCalledCancelException(super.message);
}

class UserCanceledLoginException extends AuthWrapperLoginException {
  UserCanceledLoginException(super.message);
}

class AuthWrapperRefreshTokenExpiredException extends AuthWrapperRefreshTokenException {
  AuthWrapperRefreshTokenExpiredException(super.message);
}

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
