import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/auth/firebase_auth_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_assets.dart';

void main() {
  test('getFirebaseToken when response is valid with all parameters should return token and key', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "POST") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/auth/firebase/token")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("firebase_auth_token.json"), 201);
    });
    final repository = FirebaseAuthRepository("BASE_URL", httpClient);

    // When
    final token = await repository.getFirebaseAuth("ID");

    // Then
    expect(token, FirebaseAuthResponse("FIREBASE-TOKEN", "CLE"));
  });

  test('getFirebaseToken when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = FirebaseAuthRepository("BASE_URL", httpClient);

    // When
    final token = await repository.getFirebaseAuth("ID");

    // Then
    expect(token, isNull);
  });

  test('getFirebaseToken when response throws exception should return null', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = FirebaseAuthRepository("BASE_URL", httpClient);

    // When
    final token = await repository.getFirebaseAuth("ID");

    // Then
    expect(token, isNull);
  });
}
