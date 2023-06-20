import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searches_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_repository2.dart';

void main() {
  group('GetSavedSearchRepository', () {
    final sut = RepositorySut2<GetSavedSearchRepository>();
    sut.givenRepository((client) => GetSavedSearchRepository(client));

    group('getSavedSearch', () {
      sut.when((repository) => repository.getSavedSearch("jeuneId"));
      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "saved_search_data.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/jeuneId/recherches",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<SavedSearch>?>((searches) {
            expect(searches, getMockedSavedSearch());
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectNullResult();
        });
      });
    });
  });
}
