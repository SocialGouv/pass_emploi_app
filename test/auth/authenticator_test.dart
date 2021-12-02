import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_token_request.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/authenticator.dart';
import 'package:pass_emploi_app/configuration/configuration.dart';

import '../doubles/fixtures.dart';
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
  test('login', () async {
    // Given
    final authWrapperStub = AuthWrapperStub();
    final authenticator = Authenticator(authWrapperStub, _configuration);

    final AuthTokenRequest parameters = AuthTokenRequest(
      _configuration.authClientId,
      _configuration.authLoginRedirectUrl,
      _configuration.authIssuer,
      _configuration.authScopes,
      _configuration.authClientSecret,
    );

    authWrapperStub.withArgsResolves(parameters, authTokenResponse());

    // When
    final AuthTokenResponse? token = await authenticator.login();

    // Then
    expect(token, authTokenResponse());
  });
}
