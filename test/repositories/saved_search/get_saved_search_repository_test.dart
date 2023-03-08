import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';
import '../../utils/test_assets.dart';

void main() {
  group("When user want to get a saved search list, getSavedSearch should ...", () {
    test('return saved search offers when response is valid with all parameters', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.method != "GET") return invalidHttpResponse();
        if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches")) return invalidHttpResponse();
        return Response.bytes(loadTestAssetsAsBytes("saved_search_data.json"), 200);
      });
      final repository = GetSavedSearchRepository("BASE_URL", httpClient);

      // When
      final savedSearch = await repository.getSavedSearch("jeuneId");

      // Then
      expect(savedSearch, getMockedSavedSearch());
    });

    test('return null when response is invalid should return null', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
      final repository = GetSavedSearchRepository("BASE_URL", httpClient);

      // When
      final savedSearch = await repository.getSavedSearch("jeuneId");

      // Then
      expect(savedSearch, isNull);
    });
  });
}
