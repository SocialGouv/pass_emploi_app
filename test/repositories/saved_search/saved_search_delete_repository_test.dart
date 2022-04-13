import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';

void main() {
  test('delete should return true when response is valid with proper parameters', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "DELETE") return invalidHttpResponse();
      if (request.url.toString() != "BASE_URL/jeunes/jeuneId/recherches/savedSearchId") return invalidHttpResponse();
      return Response('', 204);
    });
    final repository = SavedSearchDeleteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.delete("jeuneId", "savedSearchId");

    // Then
    expect(result, isTrue);
  });

  test('delete should return false when response is valid', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = SavedSearchDeleteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.delete("jeuneId", "savedSearchId");

    // Then
    expect(result, isFalse);
  });

  test('delete should return false when response throws exception', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = SavedSearchDeleteRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.delete("jeuneId", "savedSearchId");

    // Then
    expect(result, isFalse);
  });
}
