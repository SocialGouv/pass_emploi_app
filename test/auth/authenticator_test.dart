import 'package:flutter_test/flutter_test.dart';
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
    authWrapperStub.withArgsResolves(_authTokenRequest(), authTokenResponse());

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
    authWrapperStub.withArgsThrows();

    // When
    final AuthTokenResponse? token = await authenticator.login();

    // Then
    expect(token, isNull);
  });

  test('isLoggedIn is TRUE when login is successful', () async {
    // Given
    authWrapperStub.withArgsResolves(_authTokenRequest(), authTokenResponse());

    // When
    await authenticator.login();

    // Then
    expect(authenticator.isLoggedIn(), true);
  });

  test('isLoggedIn is FALSE when login failed', () async {
    // Given
    authWrapperStub.withArgsThrows();

    // When
    await authenticator.login();

    // Then
    expect(authenticator.isLoggedIn(), false);
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
