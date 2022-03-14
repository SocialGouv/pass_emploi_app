import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_auth_repository.dart';

import '../../../doubles/fixtures.dart';
import '../../../utils/test_assets.dart';

void main() {
  test('getPoleEmploiToken when response is valid should return auth token', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("AUTH_ISSUER/broker/pe-jeune/token")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("pole_emploi_auth_token.json"), 201);
    });
    final repository = PoleEmploiAuthRepository("AUTH_ISSUER", httpClient);

    // When
    final token = await repository.getPoleEmploiToken();

    // Then
    expect(token, AuthTokenResponse(idToken: 'id_token', accessToken: 'access_token', refreshToken: 'refresh_token'));
  });

  test('getPoleEmploiToken when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = PoleEmploiAuthRepository("AUTH_ISSUER", httpClient);

    // When
    final token = await repository.getPoleEmploiToken();

    // Then
    expect(token, isNull);
  });

  test('getPoleEmploiToken when response throws exception should return null', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = PoleEmploiAuthRepository("AUTH_ISSUER", httpClient);

    // When
    final token = await repository.getPoleEmploiToken();

    // Then
    expect(token, isNull);
  });
}
