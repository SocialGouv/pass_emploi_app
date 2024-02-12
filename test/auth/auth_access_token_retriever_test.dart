import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_access_token_retriever.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:synchronized/synchronized.dart';

import '../doubles/dummies.dart';
import '../doubles/mocks.dart';
import '../doubles/spies.dart';

void main() {
  late MockAuthenticator authenticator;
  late AuthAccessTokenRetriever tokenRetriever;

  setUp(() {
    authenticator = MockAuthenticator();
    tokenRetriever = AuthAccessTokenRetriever(DummyMaxLivingTimeConfig(), authenticator, Lock());
  });

  test("Throws an exception when id token is null", () async {
    // Given
    when(() => authenticator.idToken()).thenAnswer((_) async => null);
    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Returns access token when id token is valid", () async {
    // Given
    when(() => authenticator.accessToken()).thenAnswer((_) async => "Access token");
    when(() => authenticator.idToken()).thenAnswer((_) async => validIdToken());
    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });

  test("Returns access token when id token is invalid but refresh token is SUCCESSFUL", () async {
    // Given
    when(() => authenticator.idToken()).thenAnswer((_) async => invalidIdToken());
    when(() => authenticator.performRefreshToken()).thenAnswer((_) async => RefreshTokenStatus.SUCCESSFUL);
    when(() => authenticator.accessToken()).thenAnswer((_) async => "Access token");

    // When-Then
    expect(await tokenRetriever.accessToken(), "Access token");
  });

  test("Throws an exception when id token is invalid and refresh token returns GENERIC_ERROR", () async {
    // Given
    when(() => authenticator.idToken()).thenAnswer((_) async => invalidIdToken());
    when(() => authenticator.performRefreshToken()).thenAnswer((_) async => RefreshTokenStatus.GENERIC_ERROR);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns USER_NOT_LOGGED_IN", () async {
    // Given
    when(() => authenticator.idToken()).thenAnswer((_) async => invalidIdToken());
    when(() => authenticator.performRefreshToken()).thenAnswer((_) async => RefreshTokenStatus.USER_NOT_LOGGED_IN);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns NETWORK_UNREACHABLE", () async {
    // Given
    when(() => authenticator.idToken()).thenAnswer((_) async => invalidIdToken());
    when(() => authenticator.performRefreshToken()).thenAnswer((_) async => RefreshTokenStatus.NETWORK_UNREACHABLE);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Throws an exception when id token is invalid and refresh token returns EXPIRED_REFRESH_TOKEN", () async {
    // Given
    final store = StoreSpy();
    when(() => authenticator.idToken()).thenAnswer((_) async => invalidIdToken());
    when(() => authenticator.performRefreshToken()).thenAnswer((_) async => RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
    tokenRetriever.setStore(store);

    // When-Then
    expect(() async => await tokenRetriever.accessToken(), throwsException);
  });

  test("Logout user when id token is invalid and refresh token returns EXPIRED_REFRESH_TOKEN", () async {
    // Given
    final store = StoreSpy();
    when(() => authenticator.idToken()).thenAnswer((_) async => invalidIdToken());
    when(() => authenticator.performRefreshToken()).thenAnswer((_) async => RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
    tokenRetriever.setStore(store);

    // When
    try {
      await tokenRetriever.accessToken();
    } catch (_) {}

    // Then
    expect(store.dispatchedAction, isA<RequestLogoutAction>());
  });
}

AuthIdToken validIdToken() => AuthIdToken(
      userId: "id",
      firstName: "F",
      lastName: "L",
      email: "email",
      issuedAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
      expiresAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 1000,
      loginMode: 'MILO',
    );

AuthIdToken invalidIdToken() => AuthIdToken(
      userId: "id",
      firstName: "F",
      lastName: "L",
      email: "email@email.com",
      issuedAt: 0,
      expiresAt: 0,
      loginMode: 'MILO',
    );
