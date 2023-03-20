import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../doubles/stubs.dart';

void main() {
  test("Throws an exception when id token is null", () async {
    // Given
    final tokenRetriever = AuthAccessTokenRetriever(AuthenticatorNotLoggedInStub());
    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Returns access token when id token is valid", () async {
    // Given
    final tokenRetriever = AuthAccessTokenRetriever(AuthenticatorLoggedInAndValidIdTokenStub());
    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });

  test("Returns access token when id token is invalid but refresh token is SUCCESSFUL", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.SUCCESSFUL);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });

  test("Throws an exception when id token is invalid and refresh token returns GENERIC_ERROR", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.GENERIC_ERROR);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns USER_NOT_LOGGED_IN", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.USER_NOT_LOGGED_IN);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns NETWORK_UNREACHABLE", () async {
    // Given
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.NETWORK_UNREACHABLE);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns EXPIRED_REFRESH_TOKEN", () async {
    // Given
    final store = StoreSpy();
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);
    tokenRetriever.setStore(store);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Logout user when id token is invalid and refresh token returns EXPIRED_REFRESH_TOKEN", () async {
    // Given
    final store = StoreSpy();
    final authenticator = AuthenticatorLoggedInAndInvalidIdTokenStub(RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
    final tokenRetriever = AuthAccessTokenRetriever(authenticator);
    tokenRetriever.setStore(store);

    // When
    try {
      await tokenRetriever.accessToken();
    } catch (_) {}

    // Then
    expect(store.dispatchedAction, isA<RequestLogoutAction>());
  });
}

class AuthenticatorLoggedInAndValidIdTokenStub extends Authenticator {
  AuthenticatorLoggedInAndValidIdTokenStub()
      : super(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), SharedPreferencesSpy());

  @override
  Future<AuthIdToken?> idToken() async => AuthIdToken(
        userId: "id",
        firstName: "F",
        lastName: "L",
        email: "email@email.com",
        expiresAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 1000,
        loginMode: 'MILO',
      );

  @override
  Future<String?> accessToken() async => "Access token";
}

class AuthenticatorLoggedInAndInvalidIdTokenStub extends Authenticator {
  final RefreshTokenStatus refreshTokenStatus;

  AuthenticatorLoggedInAndInvalidIdTokenStub(this.refreshTokenStatus)
      : super(DummyAuthWrapper(), DummyLogoutRepository(), configuration(), SharedPreferencesSpy());

  @override
  Future<AuthIdToken?> idToken() async => AuthIdToken(
        userId: "id",
        firstName: "F",
        lastName: "L",
        email: "email@email.com",
        expiresAt: 0,
        loginMode: 'MILO',
      );

  @override
  Future<String?> accessToken() async => "Access token";

  @override
  Future<RefreshTokenStatus> performRefreshToken() => Future.value(refreshTokenStatus);
}
