import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_token_repository.dart';

void main() {
  final repository = PoleEmploiTokenRepository();

  test("getPoleEmploiAccessToken when auth token has not been previously set", () async {
    // Given
    final accessToken = repository.getPoleEmploiAccessToken();

    // Then
    expect(accessToken, isNull);
  });

  test("getPoleEmploiAccessToken when auth token has been previously set", () async {
    // Given
    repository.setPoleEmploiAuthToken(
      AuthTokenResponse(idToken: 'idToken', accessToken: 'accessToken', refreshToken: 'refreshToken'),
    );

    // When
    final accessToken = repository.getPoleEmploiAccessToken();

    // Then
    expect(accessToken, 'accessToken');
  });

  test("getPoleEmploiAccessToken when auth token has been cleared", () async {
    // Given
    repository.setPoleEmploiAuthToken(AuthTokenResponse(idToken: '', accessToken: '', refreshToken: ''));

    // When
    repository.clearPoleEmploiAuthToken();

    // Then
    final accessToken = repository.getPoleEmploiAccessToken();
    expect(accessToken, isNull);
  });
}
