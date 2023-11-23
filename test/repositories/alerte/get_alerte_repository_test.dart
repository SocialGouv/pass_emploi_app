import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/repositories/alerte/get_alerte_repository.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/sut_dio_repository.dart';

void main() {
  group('GetAlerteRepository', () {
    final sut = DioRepositorySut<GetAlerteRepository>();
    sut.givenRepository((client) => GetAlerteRepository(client));

    group('getAlerte', () {
      sut.when((repository) => repository.getAlerte("jeuneId"));
      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "alertes.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/jeuneId/recherches",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<Alerte>?>((searches) {
            expect(searches, getMockedAlerte());
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
