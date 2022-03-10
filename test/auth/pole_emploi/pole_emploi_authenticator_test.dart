import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/auth/pole_emploi/pole_emploi_authenticator.dart';

void main() {
  final authenticator = PoleEmploiAuthenticator();

  test("getPoleEmploiAccessToken when auth token has not been previously set", () async {
    // Given
    final accessToken = authenticator.getPoleEmploiAccessToken();

    // Then
    expect(accessToken, isNull);
  });

  test("getPoleEmploiAccessToken when auth token has been previously set", () async {
    // Given
    authenticator.setPoleEmploiAuthToken(
      AuthTokenResponse(idToken: 'idToken', accessToken: 'accessToken', refreshToken: 'refreshToken'),
    );

    // When
    final accessToken = authenticator.getPoleEmploiAccessToken();

    // Then
    expect(accessToken, 'accessToken');
  });

  test("getPoleEmploiAccessToken when auth token has been cleared", () async {
    // Given
    authenticator.setPoleEmploiAuthToken(AuthTokenResponse(idToken: '', accessToken: '', refreshToken: ''));

    // When
    authenticator.clearPoleEmploiAuthToken();

    // Then
    final accessToken = authenticator.getPoleEmploiAccessToken();
    expect(accessToken, isNull);
  });
}
