import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/alerte/immersion_alerte_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('ImmersionAlerteRepository', () {
    final sut = DioRepositorySut<ImmersionAlerteRepository>();
    sut.givenRepository((client) => ImmersionAlerteRepository(client));

    group('postAlerte', () {
      sut.when(
        (repository) => repository.postAlerte(
          "userId",
          mockImmersionAlerteWithFiltres(),
          "title",
        ),
      );
      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/userId/recherches/immersions",
            jsonBody: {
              'titre': 'title',
              'metier': 'plombier',
              'localisation': 'Paris',
              'criteres': {'rome': 'F1104', 'lat': 48.830108, 'lon': 2.323026, 'distance': 30}
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
