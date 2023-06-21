import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/saved_search/service_civique_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('ServiceCiviqueSavedSearchRepository', () {
    final sut = DioRepositorySut<ServiceCiviqueSavedSearchRepository>();
    sut.givenRepository((client) => ServiceCiviqueSavedSearchRepository(client, DummyPassEmploiCacheManager()));

    group('postSavedSearch', () {
      sut.when(
        (repository) => repository.postSavedSearch(
          "userId",
          mockServiceCiviqueSavedSearchWithFiltres(),
          "title",
        ),
      );
      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/userId/recherches/services-civique",
            jsonBody: {
              'titre': 'title',
              'localisation': 'Paris',
              'criteres': {
                'lat': 48.830108,
                'lon': 2.323026,
                'distance': 30,
                'dateDeDebutMinimum': null,
                'domaine': 'solidarite-insertion',
              }
            },
          );
        });

        test('response should be true', () async {
          await sut.expectTrueAsResult();
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be false', () async {
          await sut.expectFalseAsResult();
        });
      });
    });
  });
}
