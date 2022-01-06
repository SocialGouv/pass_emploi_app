import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_logout_request.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';
import '../doubles/stubs.dart';

void main() {
  late AuthWrapperStub authWrapperStub;
  late SharedPreferencesSpy prefs;
  late Authenticator authenticator;

  setUp(() {
    authWrapperStub = AuthWrapperStub();
    prefs = SharedPreferencesSpy();
    authenticator = Authenticator(authWrapperStub, configuration(), prefs);
  });

  group('Login tests', () {
    test('token is saved and returned when login in GENERIC mode is successful', () async {
      // Given
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());

      // When
      final bool result = await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(result, isTrue);
      expect(prefs.storedValues["idToken"], authTokenResponse().idToken);
      expect(prefs.storedValues["accessToken"], authTokenResponse().accessToken);
      expect(prefs.storedValues["refreshToken"], authTokenResponse().refreshToken);
    });

    test('token is saved and returned when login in SIMILO mode is successful', () async {
      // Given
      authWrapperStub.withLoginArgsResolves(
        _authTokenRequest(additionalParameters: {"kc_idp_hint": "similo-jeune"}),
        authTokenResponse(),
      );

      // When
      final bool result = await authenticator.login(AuthenticationMode.SIMILO);

      // Then
      expect(result, isTrue);
      expect(prefs.storedValues["idToken"], authTokenResponse().idToken);
      expect(prefs.storedValues["accessToken"], authTokenResponse().accessToken);
      expect(prefs.storedValues["refreshToken"], authTokenResponse().refreshToken);
    });

    test('token is null when login has failed', () async {
      // Given
      authWrapperStub.withLoginArgsThrows();

      // When
      final bool result = await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(result, isFalse);
    });

    test('isLoggedIn is TRUE when login is successful', () async {
      // Given
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());

      // When
      await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(await authenticator.isLoggedIn(), true);
    });

    test('isLoggedIn is FALSE when login failed', () async {
      // Given
      authWrapperStub.withLoginArgsThrows();

      // When
      await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(await authenticator.isLoggedIn(), false);
    });
  });

  group('Refresh token tests', () {
    test('token is saved when refresh token is successful and user is logged in', () async {
      // Given
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
      authWrapperStub.withRefreshArgsResolves(
        _authRefreshTokenRequest(),
        AuthTokenResponse(accessToken: 'accessToken2', idToken: 'idToken2', refreshToken: 'refreshToken2'),
      );

      await authenticator.login(AuthenticationMode.GENERIC);

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

      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.refreshToken();

      // Then
      expect(result, RefreshTokenStatus.NETWORK_UNREACHABLE);
    });

    test(
        'refresh token returns EXPIRED_REFRESH_TOKEN and delete tokens when user is logged in but refresh token is expired',
        () async {
      // Given
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
      authWrapperStub.withRefreshArgsThrowsExpired();

      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.refreshToken();

      // Then
      expect(result, RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
      expect(await authenticator.isLoggedIn(), false);
    });

    test('refresh token returns GENERIC_ERROR when user is logged in but refresh token fails on generic exception',
        () async {
      // Given
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
      authWrapperStub.withRefreshArgsThrowsGeneric();

      await authenticator.login(AuthenticationMode.GENERIC);

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
      expect(await authenticator.isLoggedIn(), false);
    });
  });

  group('Logout tests', () {
    test('TRUE is returned and tokens are deleted when user was logged in and logout is successful', () async {
      // Given
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
      authWrapperStub.withLogoutArgsResolves(_authLogoutRequest());
      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.logout();

      // Then
      expect(result, isTrue);
      expect(await authenticator.isLoggedIn(), false);
    });

    test('FALSE is returned if user was logged in but logout fails', () async {
      // Given user not logged in and…
      authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
      authWrapperStub.withLogoutArgsThrows();
      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.logout();

      // Then
      expect(result, isFalse);
    });

    test('FALSE is returned if user was not logged in', () async {
      // Given user not logged in and…
      authWrapperStub.withLogoutArgsResolves(_authLogoutRequest());

      // When
      final result = await authenticator.logout();

      // Then
      expect(result, isFalse);
    });
  });

  test('ID token is properly returned and deserialized when login is successful', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(
      _authTokenRequest(),
      AuthTokenResponse(
        idToken: realIdToken,
        accessToken: 'accessToken',
        refreshToken: 'refreshToken',
      ),
    );
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.idToken();

    // Then
    expect(
        token,
        AuthIdToken(
          userId: "ZKBAC",
          firstName: "Gabriel",
          lastName: "Android",
          expiresAt: 1638874410,
        ));
  });

  test('ID token is null when login failed', () async {
    // Given
    authWrapperStub.withLoginArgsThrows();
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.idToken();

    // Then
    expect(token, isNull);
  });

  test('Access token is returned when login is successful', () async {
    // Given
    authWrapperStub.withLoginArgsResolves(_authTokenRequest(), authTokenResponse());
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.accessToken();

    // Then
    expect(token, "accessToken");
  });

  test('Access token is null when login failed', () async {
    // Given
    authWrapperStub.withLoginArgsThrows();
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.accessToken();

    // Then
    expect(token, isNull);
  });
}

AuthTokenRequest _authTokenRequest({Map<String, String>? additionalParameters}) {
  return AuthTokenRequest(
    configuration().authClientId,
    configuration().authLoginRedirectUrl,
    configuration().authIssuer,
    configuration().authScopes,
    configuration().authClientSecret,
    additionalParameters,
  );
}

AuthRefreshTokenRequest _authRefreshTokenRequest() {
  return AuthRefreshTokenRequest(
    configuration().authClientId,
    configuration().authLoginRedirectUrl,
    configuration().authIssuer,
    'refreshToken',
    configuration().authClientSecret,
  );
}

AuthLogoutRequest _authLogoutRequest() {
  return AuthLogoutRequest(
    "idToken",
    configuration().authLogoutRedirectUrl,
    configuration().authIssuer,
  );
}

const String realIdToken =
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJnMG4zdi1lV2pLZVdjSXdSTlljQ2dSaHJTVkdBSXdpLWYxRnlOOVk1R1ZZIn0.eyJleHAiOjE2Mzg4NzQ0MTAsImlhdCI6MTYzODg3NDExMSwiYXV0aF90aW1lIjoxNjM4ODc0MTEwLCJqdGkiOiI0ZTY1MzFkYS0yMjdhLTRmNWEtOGRkOC01YWEzNjY3OTcxYzUiLCJpc3MiOiJodHRwczovL3BhLWF1dGgtc3RhZ2luZy5vc2Mtc2VjbnVtLWZyMS5zY2FsaW5nby5pby9hdXRoL3JlYWxtcy9wYXNzLWVtcGxvaSIsImF1ZCI6InBhc3MtZW1wbG9pLWFwcCIsInN1YiI6IjYwZjdlMDFmLWNjZWUtNDEwYy1hODI4LWIzNmZhYjQ5ZjJhYiIsInR5cCI6IklEIiwiYXpwIjoicGFzcy1lbXBsb2ktYXBwIiwibm9uY2UiOiIwU29JUjhXLWhFWTctVFdnTDdLVVFRIiwic2Vzc2lvbl9zdGF0ZSI6IjQ3NjQ3MWI1LWM3NWUtNDg5NC1hNWEyLWM4MTZiZmE0MDAwMiIsImF0X2hhc2giOiJEbE5ONDU3b2s2ekl2dHA4NklqUklRIiwiYWNyIjoiMSIsInNpZCI6IjQ3NjQ3MWI1LWM3NWUtNDg5NC1hNWEyLWM4MTZiZmE0MDAwMiIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwidXNlclN0cnVjdHVyZSI6IlBBU1NfRU1QTE9JIiwibmFtZSI6IkdhYnJpZWwgQW5kcm9pZCIsInVzZXJUeXBlIjoiSkVVTkUiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ6a2JhYyIsImdpdmVuX25hbWUiOiJHYWJyaWVsIiwiZmFtaWx5X25hbWUiOiJBbmRyb2lkIiwidXNlcklkIjoiWktCQUMifQ.EsdwKH0XhNHGatXX6n6ip";
