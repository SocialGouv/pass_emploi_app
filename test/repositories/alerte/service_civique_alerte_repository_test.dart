import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/alerte/service_civique_alerte_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('ServiceCiviqueAlerteRepository', () {
    final sut = DioRepositorySut<ServiceCiviqueAlerteRepository>();
    sut.givenRepository((client) => ServiceCiviqueAlerteRepository(client));

    group('postAlerte', () {
      sut.when(
        (repository) => repository.postAlerte(
          "userId",
          mockServiceCiviqueAlerteWithFiltres(),
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
