import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/alerte/offre_emploi_alerte_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('OffreEmploiAlerteRepository', () {
    final sut = DioRepositorySut<OffreEmploiAlerteRepository>();
    sut.givenRepository((client) => OffreEmploiAlerteRepository(client));

    void testPostAlerte({required bool isAlternance}) {
      group('postAlerte isAlternance: $isAlternance', () {
        sut.when(
          (repository) => repository.postAlerte(
            "userId",
            mockOffreEmploiAlerteWithFilters(isAlternance: isAlternance),
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

    testPostAlerte(isAlternance: true);
    testPostAlerte(isAlternance: false);
  });
}
