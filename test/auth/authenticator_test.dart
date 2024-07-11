import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_refresh_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/auth_wrapper.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/repositories/auth/logout_repository.dart';

import '../doubles/dummies.dart';
import '../doubles/fixtures.dart';
import '../doubles/mocks.dart';
import '../doubles/spies.dart';

void main() {
  late MockAuthWrapper wrapper;
  late SharedPreferencesSpy prefs;
  late Authenticator authenticator;
  late LogoutRepository logoutRepository;

  setUp(() {
    wrapper = MockAuthWrapper();
    prefs = SharedPreferencesSpy();
    logoutRepository = DummyLogoutRepository();
    logoutRepository.setCacheManager(DummyPassEmploiCacheManager());
    authenticator = Authenticator(wrapper, logoutRepository, configuration(), prefs);
  });

  group('Login tests', () {
    test('token is saved and returned when login in GENERIC mode is successful', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());

      // When
      final result = await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(result, isA<SuccessAuthenticatorResponse>());
      expect(await prefs.read(key: "idToken"), authTokenResponse().idToken);
      expect(await prefs.read(key: "accessToken"), authTokenResponse().accessToken);
      expect(await prefs.read(key: "refreshToken"), authTokenResponse().refreshToken);
    });

    test('token is saved and returned when login in SIMILO mode is successful', () async {
      // Given
      when(() => wrapper.login(_tokenRequest(additionalParameters: {"kc_idp_hint": "similo-jeune"})))
          .thenAnswer((_) async => authTokenResponse());

      // When
      final result = await authenticator.login(AuthenticationMode.SIMILO);

      // Then
      expect(result, isA<SuccessAuthenticatorResponse>());
      expect(await prefs.read(key: "idToken"), authTokenResponse().idToken);
      expect(await prefs.read(key: "accessToken"), authTokenResponse().accessToken);
      expect(await prefs.read(key: "refreshToken"), authTokenResponse().refreshToken);
    });

    test('token is saved and returned when login in POLE_EMPLOI mode is successful', () async {
      // Given
      when(() => wrapper.login(_tokenRequest(additionalParameters: {"kc_idp_hint": "ft-beneficiaire"})))
          .thenAnswer((_) async => authTokenResponse());

      // When
      final result = await authenticator.login(AuthenticationMode.POLE_EMPLOI);

      // Then
      expect(result, isA<SuccessAuthenticatorResponse>());
      expect(await prefs.read(key: "idToken"), authTokenResponse().idToken);
      expect(await prefs.read(key: "accessToken"), authTokenResponse().accessToken);
      expect(await prefs.read(key: "refreshToken"), authTokenResponse().refreshToken);
    });

    test('token is null when login has failed', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenThrow(Exception());

      // When
      final result = await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(result, isA<FailureAuthenticatorResponse>());
    });

    test('response is canceled when login has been canceled', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenThrow(UserCanceledLoginException(''));

      // When
      final result = await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(result, isA<CancelledAuthenticatorResponse>());
    });

    // Required for Android behavior: https://github.com/MaikuB/flutter_appauth/issues/422
    test('response is wrong device clock when login has clock exception', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenThrow(AuthWrapperWrongDeviceClockException(''));

      // When
      final result = await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(result, isA<WrongDeviceClockAuthenticatorResponse>());
    });

    test('isLoggedIn is TRUE when login is successful', () async {
      // Given
      final wrapper = MockAuthWrapper();
      final authenticator = Authenticator(wrapper, logoutRepository, configuration(brand: Brand.passEmploi), prefs);
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async =>
          AuthTokenResponse(accessToken: 'accessToken', idToken: realPassEmploiIdToken, refreshToken: 'refreshToken'));

      // When
      await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(await authenticator.isLoggedIn(), true);
    });

    test('isLoggedIn is FALSE when login failed', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenThrow(Exception());

      // When
      await authenticator.login(AuthenticationMode.GENERIC);

      // Then
      expect(await authenticator.isLoggedIn(), false);
    });
  });

  group('Refresh token tests', () {
    test('token is saved when refresh token is successful and user is logged in', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());
      when(() => wrapper.refreshToken(_refreshTokenRequest())).thenAnswer((_) async =>
          AuthTokenResponse(accessToken: 'accessToken2', idToken: 'idToken2', refreshToken: 'refreshToken2'));

      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.performRefreshToken();

      // Then
      expect(result, RefreshTokenStatus.SUCCESSFUL);
      expect(await prefs.read(key: "idToken"), "idToken2");
      expect(await prefs.read(key: "accessToken"), "accessToken2");
      expect(await prefs.read(key: "refreshToken"), "refreshToken2");
    });

    test('refresh token returns NETWORK_UNREACHABLE when user is logged in but network is unreachable', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());
      when(() => wrapper.refreshToken(_refreshTokenRequest())).thenThrow(AuthWrapperNetworkException(''));

      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.performRefreshToken();

      // Then
      expect(result, RefreshTokenStatus.NETWORK_UNREACHABLE);
    });

    test(
        'refresh token returns EXPIRED_REFRESH_TOKEN and delete tokens when user is logged in but refresh token is expired',
        () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());
      when(() => wrapper.refreshToken(_refreshTokenRequest())).thenThrow(AuthWrapperRefreshTokenExpiredException(''));

      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.performRefreshToken();

      // Then
      expect(result, RefreshTokenStatus.EXPIRED_REFRESH_TOKEN);
      expect(await authenticator.isLoggedIn(), false);
    });

    test('refresh token returns GENERIC_ERROR when user is logged in but refresh token fails on generic exception',
        () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());
      when(() => wrapper.refreshToken(_refreshTokenRequest())).thenThrow(AuthWrapperRefreshTokenException(''));

      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.performRefreshToken();

      // Then
      expect(result, RefreshTokenStatus.GENERIC_ERROR);
    });

    test('refresh token returns USER_NOT_LOGGED_IN when user is not logged in', () async {
      // Given user not logged in

      // When
      final result = await authenticator.performRefreshToken();

      // Then
      expect(result, RefreshTokenStatus.USER_NOT_LOGGED_IN);
      expect(await authenticator.isLoggedIn(), false);
    });
  });

  group('Logout tests', () {
    test('TRUE is returned and tokens are deleted when user was logged in', () async {
      // Given
      when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());
      await authenticator.login(AuthenticationMode.GENERIC);

      // When
      final result = await authenticator.logout('userId', LogoutReason.expiredRefreshToken);

      // Then
      expect(result, isTrue);
      expect(await authenticator.isLoggedIn(), false);
    });

    test('FALSE is returned if user was not logged in', () async {
      // Given user not logged in

      // When
      final result = await authenticator.logout('NOT_LOGIN_USER', LogoutReason.expiredRefreshToken);

      // Then
      expect(result, isFalse);
    });
  });

  test('ID token is properly returned and deserialized when login is successful', () async {
    // Given
    when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => AuthTokenResponse(
          idToken: realPassEmploiIdToken,
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
        ));

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
          email: null,
          issuedAt: 1638874111,
          expiresAt: 1638874410,
          structure: 'PASS_EMPLOI',
        ));
  });

  test("ID token is properly returned and deserialized when login is successful and id token contains email", () async {
    // Given
    when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => AuthTokenResponse(
          idToken: realMiloIdToken,
          accessToken: 'accessToken',
          refreshToken: 'refreshToken',
        ));

    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.idToken();

    // Then
    expect(
        token,
        AuthIdToken(
          userId: "5C02587A-D341-4E6D-B5A0-574733D0EBB9",
          firstName: "Kenji",
          lastName: "Dupont",
          email: "jeune.milo.passemploi@gmail.com",
          issuedAt: 1644420849,
          expiresAt: 1644422649,
          structure: 'MILO',
        ));
  });

  test('ID token is null when login failed', () async {
    // Given
    when(() => wrapper.login(_tokenRequest())).thenThrow(Exception());
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.idToken();

    // Then
    expect(token, isNull);
  });

  test('Access token is returned when login is successful', () async {
    // Given
    when(() => wrapper.login(_tokenRequest())).thenAnswer((_) async => authTokenResponse());
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.accessToken();

    // Then
    expect(token, "accessToken");
  });

  test('Access token is null when login failed', () async {
    // Given
    when(() => wrapper.login(_tokenRequest())).thenThrow(Exception());
    await authenticator.login(AuthenticationMode.GENERIC);

    // When
    final token = await authenticator.accessToken();

    // Then
    expect(token, isNull);
  });
}

AuthTokenRequest _tokenRequest({Map<String, String>? additionalParameters}) {
  return AuthTokenRequest(
    configuration().authClientId,
    configuration().authLoginRedirectUrl,
    configuration().authIssuer,
    configuration().authScopes,
    configuration().authClientSecret,
    additionalParameters,
  );
}

AuthRefreshTokenRequest _refreshTokenRequest() {
  return AuthRefreshTokenRequest(
    configuration().authClientId,
    configuration().authLoginRedirectUrl,
    configuration().authIssuer,
    'refreshToken',
    configuration().authClientSecret,
  );
}

const String realPassEmploiIdToken =
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJnMG4zdi1lV2pLZVdjSXdSTlljQ2dSaHJTVkdBSXdpLWYxRnlOOVk1R1ZZIn0.eyJleHAiOjE2Mzg4NzQ0MTAsImlhdCI6MTYzODg3NDExMSwiYXV0aF90aW1lIjoxNjM4ODc0MTEwLCJqdGkiOiI0ZTY1MzFkYS0yMjdhLTRmNWEtOGRkOC01YWEzNjY3OTcxYzUiLCJpc3MiOiJodHRwczovL3BhLWF1dGgtc3RhZ2luZy5vc2Mtc2VjbnVtLWZyMS5zY2FsaW5nby5pby9hdXRoL3JlYWxtcy9wYXNzLWVtcGxvaSIsImF1ZCI6InBhc3MtZW1wbG9pLWFwcCIsInN1YiI6IjYwZjdlMDFmLWNjZWUtNDEwYy1hODI4LWIzNmZhYjQ5ZjJhYiIsInR5cCI6IklEIiwiYXpwIjoicGFzcy1lbXBsb2ktYXBwIiwibm9uY2UiOiIwU29JUjhXLWhFWTctVFdnTDdLVVFRIiwic2Vzc2lvbl9zdGF0ZSI6IjQ3NjQ3MWI1LWM3NWUtNDg5NC1hNWEyLWM4MTZiZmE0MDAwMiIsImF0X2hhc2giOiJEbE5ONDU3b2s2ekl2dHA4NklqUklRIiwiYWNyIjoiMSIsInNpZCI6IjQ3NjQ3MWI1LWM3NWUtNDg5NC1hNWEyLWM4MTZiZmE0MDAwMiIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwidXNlclN0cnVjdHVyZSI6IlBBU1NfRU1QTE9JIiwibmFtZSI6IkdhYnJpZWwgQW5kcm9pZCIsInVzZXJUeXBlIjoiSkVVTkUiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ6a2JhYyIsImdpdmVuX25hbWUiOiJHYWJyaWVsIiwiZmFtaWx5X25hbWUiOiJBbmRyb2lkIiwidXNlcklkIjoiWktCQUMifQ.EsdwKH0XhNHGatXX6n6ip";

const String realMiloIdToken =
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJnMG4zdi1lV2pLZVdjSXdSTlljQ2dSaHJTVkdBSXdpLWYxRnlOOVk1R1ZZIn0.eyJleHAiOjE2NDQ0MjI2NDksImlhdCI6MTY0NDQyMDg0OSwiYXV0aF90aW1lIjoxNjQ0NDIwODQ4LCJqdGkiOiJlNTg2ZTZiOS01OTExLTQ1YWYtYjcwOS1lOGU0OThhN2UxNmYiLCJpc3MiOiJodHRwczovL2lkLnBhc3MtZW1wbG9pLmluY3ViYXRldXIubmV0L2F1dGgvcmVhbG1zL3Bhc3MtZW1wbG9pIiwiYXVkIjoicGFzcy1lbXBsb2ktYXBwIiwic3ViIjoiYmM4NzRjOGMtMjMyMS00OTY5LWIzZWMtM2RlZGRmZWI3MzdkIiwidHlwIjoiSUQiLCJhenAiOiJwYXNzLWVtcGxvaS1hcHAiLCJub25jZSI6IlFhcjV6ZVFNbmVKS01rd0h5LTZJa1EiLCJzZXNzaW9uX3N0YXRlIjoiZTg2MmQyOGYtZGQ3My00MDBjLWFjMTctZWM5ZjFhNmQyYzE0IiwiYXRfaGFzaCI6InQ2UHdBdkhSeXR1R0pTbkVnQU1MTEEiLCJhY3IiOiIxIiwic2lkIjoiZTg2MmQyOGYtZGQ3My00MDBjLWFjMTctZWM5ZjFhNmQyYzE0IiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJ1c2VyU3RydWN0dXJlIjoiTUlMTyIsIm5hbWUiOiJLZW5qaSBEdXBvbnQiLCJ1c2VyVHlwZSI6IkpFVU5FIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiamV1bmUubWlsby5wYXNzZW1wbG9pQGdtYWlsLmNvbSIsImdpdmVuX25hbWUiOiJLZW5qaSIsImZhbWlseV9uYW1lIjoiRHVwb250IiwidXNlcklkIjoiNUMwMjU4N0EtRDM0MS00RTZELUI1QTAtNTc0NzMzRDBFQkI5IiwiZW1haWwiOiJqZXVuZS5taWxvLnBhc3NlbXBsb2lAZ21haWwuY29tIn0.A4N3JCg0LfvZJKmuo-phXyV1lqLJcbOLVhVrNE4ptqhJAb5yOhjDc4Or6RKHwQrXpY4LIX-qGFquE_PNsJJTNQIZsoMrTh-t9FNh7bRbP6ViPA5tw52s7AgTpXj2VjcjH0yjLsCVwm09uloGEQo3xfRaWEodcV-0y33Jq6KdJQ1hEM8K_CMNwrDPdxQgf_ZHvJgxTe32PBeuf56cWuPPMeML8mDcKuNw3vLHqRr2qzsA4sjs8UWFQMpDfIVEj44xqSqqXXaFcfMD-T0hZLrKVTvtvBVBZPpyLQ8fza-G2ho5cIDk8anTjKt2UyEDc4t1wBPDMDYb_0XmsLA9V77ZcQ";
