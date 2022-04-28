import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';

import '../doubles/fixtures.dart';

void main() {
  test("deleteUser should return true when response is valid", () async {
    // Given
    final httpClient = _successfulClientForDelete();
    final repository = SuppressionCompteRepository("BASE_URL", httpClient);

    // When
    final result = await repository.deleteUser("jeuneId");

    // Then
    expect(result, isTrue);
  });

  test("deleteUser should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = SuppressionCompteRepository("BASE_URL", httpClient);

    // When
    final result = await repository.deleteUser("jeuneId");

    // Then
    expect(result, isFalse);
  });
}

MockClient _failureClient() => MockClient((request) async => Response("", 500));

MockClient _successfulClientForDelete() {
  return MockClient((request) async {
    if (request.method != "DELETE") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId")) return invalidHttpResponse();
    return Response("", 204);
  });
}
