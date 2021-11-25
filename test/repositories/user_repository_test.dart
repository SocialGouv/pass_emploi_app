import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';

import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('logUser when response is valid should return user', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "POST") return Response("", 404);
      if (request.url != Uri.parse("BASE_URL/jeunes/ID/login")) return Response("", 404);
      if (request.headers['content-type'] != 'application/json') return Response("", 404);
      return Response(loadTestAssets("user.json"), 200);
    });
    final repository = UserRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final user = await repository.logUser("ID");

    // Then
    expect(user!, isNotNull);
    expect(user.id, "ID");
    expect(user.firstName, "Kenji");
    expect(user.lastName, "LeFameux");
  });

  test('logUser when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => Response("", 404));
    final repository = UserRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final user = await repository.logUser("ID");

    // Then
    expect(user, isNull);
  });
}
