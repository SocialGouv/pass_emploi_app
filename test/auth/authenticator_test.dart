import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../doubles/stubs.dart';

final _configuration = Configuration(
  'serverBaseUrl',
  'firebaseEnvironmentPrefix',
  'matomoBaseUrl',
  'matomoSiteId',
  'authClientId',
  'authLoginRedirectUrl',
  'authIssuer',
  ['scope1', 'scope2', 'scope3'],
  'authClientSecret',
);

void main() {
  late AuthWrapperStub authWrapperStub;
  late SharedPreferencesSpy prefs;
  late Authenticator authenticator;

  setUp(() {
    authWrapperStub = AuthWrapperStub();
    prefs = SharedPreferencesSpy();
    authenticator = Authenticator(authWrapperStub, _configuration, prefs);
  });

  test('token is saved and returned when login is successful', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());

    // When
    final AuthTokenResponse? token = await authenticator.login();

    // Then
    expect(token!, authTokenResponse());
    expect(prefs.storedValues["idToken"], token.idToken);
    expect(prefs.storedValues["accessToken"], token.accessToken);
    expect(prefs.storedValues["refreshToken"], token.refreshToken);
  });

  test('token is null when login has failed', () async {
    // Given
    authWrapperStub.withLoginArgsThrows();

    // When
    final AuthTokenResponse? token = await authenticator.login();

    // Then
    expect(token, isNull);
  });

  test('isLoggedIn is TRUE when login is successful', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());

    // When
    await authenticator.login();

    // Then
    expect(authenticator.isLoggedIn(), true);
  });

  test('isLoggedIn is FALSE when login failed', () async {
    // Given
    authWrapperStub.withLoginArgsThrows();

    // When
    await authenticator.login();

    // Then
    expect(authenticator.isLoggedIn(), false);
  });

  test('ID token is properly returned and deserialized  when login is successful', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(
      _authTokenRequest(),
      AuthTokenResponse(
        idToken: realIdToken,
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
      ),
    );
    await authenticator.login();

    // When
    final token = authenticator.idToken();

    // Then
    expect(
        token,
        AuthIdToken(
          userId: "448092da-4ad7-4fcf-8ff5-a303f30ea109",
          firstName: "toto",
          lastName: "tata",
          expiresAt: 1638446993,
        ));
  });

  test('ID token is null when login failed', () async {
    // Given
    authWrapperStub.withLoginArgsThrows();
    await authenticator.login();

    // When
    final token = authenticator.idToken();

    // Then
    expect(token, isNull);
  });

  test('Access token is returned when login is successful', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
    await authenticator.login();

    // When
    final token = authenticator.accessToken();

    // Then
    expect(token, "accessToken");
  });

  test('Access token is null when login failed', () async {
    // Given
    authWrapperStub.withLoginArgsThrows();
    await authenticator.login();

    // When
    final token = authenticator.accessToken();

    // Then
    expect(token, isNull);
  });

  test('token is saved when refresh token is successful and user is logged in', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
    authWrapperStub.withRefreshArgsResolves(
      _refreshTokenRequest(),
      AuthTokenResponse(accessToken: 'accessToken2', idToken: 'idToken2', refreshToken: 'refreshToken2'),
    );

    await authenticator.login();

    // When
    final result = await authenticator.refreshToken();

    // Then
    expect(result, RefreshTokenStatus.SUCCESSFUL);
    expect(prefs.storedValues["idToken"], "idToken2");
    expect(prefs.storedValues["accessToken"], "accessToken2");
    expect(prefs.storedValues["refreshToken"], "refreshToken2");
  });

  test('refresh token returns NETWORK_UNREACHABLE when user is logged in but network is unreachable', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
    authWrapperStub.withRefreshArgsThrowsNetwork();

    await authenticator.login();

    // When
    final result = await authenticator.refreshToken();

    // Then
    expect(result, RefreshTokenStatus.NETWORK_UNREACHABLE);
  });

  test('refresh token returns EXPIRED_REFRESH_TOKEN when user is logged in but refresh token is expired', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
    authWrapperStub.withRefreshArgsThrowsExpired();

    await authenticator.login();

    // When
    final result = await authenticator.refreshToken();

    // Then
    expect(result, RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
  });

  test('refresh token returns GENERIC_ERROR when user is logged in but refresh token fails on generic exception',
      () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
    authWrapperStub.withRefreshArgsThrowsGeneric();

    await authenticator.login();

    // When
    final result = await authenticator.refreshToken();

    // Then
    expect(result, RefreshTokenStatus.GENERIC_ERROR);
  });

  test('refresh token returns USER_NOT_LOGGED_IN when user is not logged in', () async {
    // Given user not logged in

    // When
    final result = await authenticator.refreshToken();

    // Then
    expect(result, RefreshTokenStatus.USER_NOT_LOGGED_IN);
  });
}

AuthTokenRequest _authTokenRequest() {
  return AuthTokenRequest(
    _configuration.authClientId,
    _configuration.authLoginRedirectUrl,
    _configuration.authIssuer,
    _configuration.authScopes,
    _configuration.authClientSecret,
  );
}

AuthRefreshTokenRequest _refreshTokenRequest() {
  return AuthRefreshTokenRequest(
    _configuration.authClientId,
    _configuration.authLoginRedirectUrl,
    _configuration.authIssuer,
    'refreshToken',
    _configuration.authClientSecret,
  );
}

const String realIdToken =
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJnMG4zdi1lV2pLZVdjSXdSTlljQ2dSaHJTVkdBSXdpLWYxRnlOOVk1R1ZZIn0.eyJleHAiOjE2Mzg0NDY5OTMsImlhdCI6MTYzODQ0NjY5MywiYXV0aF90aW1lIjoxNjM4NDQ2NjkzLCJqdGkiOiIxODdjMDIzNy03OTY2LTQ0ZTYtOWRiOC0xMzBjY2ZlZjBjNjYiLCJpc3MiOiJodHRwczovL3BhLWF1dGgtc3RhZ2luZy5vc2Mtc2VjbnVtLWZyMS5zY2FsaW5nby5pby9hdXRoL3JlYWxtcy9wYXNzLWVtcGxvaSIsImF1ZCI6InBhc3MtZW1wbG9pLWFwcCIsInN1YiI6IjQ0ODA5MmRhLTRhZDctNGZjZi04ZmY1LWEzMDNmMzBlYTEwOSIsInR5cCI6IklEIiwiYXpwIjoicGFzcy1lbXBsb2ktYXBwIiwibm9uY2UiOiJRVDBQYUdBdVFhZFNPR3NlMngwOElBIiwic2Vzc2lvbl9zdGF0ZSI6ImMzYTk2ZDg4LWY0ZWUtNDAwYS05M2E5LTk4MjA0YzkyNWQyYSIsImF0X2hhc2giOiJVY2JweEoycS1JS0FodnI3dlFMTFpBIiwiYWNyIjoiMSIsInNpZCI6ImMzYTk2ZDg4LWY0ZWUtNDAwYS05M2E5LTk4MjA0YzkyNWQyYSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwibmFtZSI6InRvdG8gdGF0YSIsInByZWZlcnJlZF91c2VybmFtZSI6InRvdG8iLCJnaXZlbl9uYW1lIjoidG90byIsImZhbWlseV9uYW1lIjoidGF0YSJ9";
