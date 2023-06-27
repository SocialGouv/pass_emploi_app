import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('OffreEmploiSavedSearchRepository', () {
    final sut = DioRepositorySut<OffreEmploiSavedSearchRepository>();
    sut.givenRepository((client) => OffreEmploiSavedSearchRepository(client, DummyPassEmploiCacheManager()));

    void testPostSavedSearch({required bool isAlternance}) {
      group('postSavedSearch isAlternance: $isAlternance', () {
        sut.when(
          (repository) => repository.postSavedSearch(
            "userId",
            mockOffreEmploiSavedSearchWithFilters(isAlternance: isAlternance),
            "title",
          ),
        );
        group('when response is valid', () {
          sut.givenResponseCode(201);

          test('request should be valid', () async {
            await sut.expectRequestBody(
              method: HttpMethod.post,
              url: "/jeunes/userId/recherches/offres-emploi",
              jsonBody: {
                'titre': 'title',
                'metier': 'plombier',
                'localisation': 'Paris',
                'criteres': {
                  'q': 'secteur privé',
                  'departement': '75',
                  'alternance': isAlternance,
                  'debutantAccepte': true,
                  'experience': ['3', '2'],
                  'contrat': ['CDI'],
                  'duree': ['1'],
                  'commune': null,
                  'rayon': 40
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
    }

    testPostSavedSearch(isAlternance: true);
    testPostSavedSearch(isAlternance: false);
  });
}
