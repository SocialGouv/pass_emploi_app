import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/diagoriente_metiers_favoris_repository.dart';

import '../dsl/sut_repository2.dart';

void main() {
  group('DiagorienteMetiersFavorisRepository', () {
    final sut = RepositorySut2<DiagorienteMetiersFavorisRepository>();
    sut.givenRepository((client) => DiagorienteMetiersFavorisRepository(client));

    group('get', () {
      sut.when((repository) => repository.get("UID"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "diagoriente_metiers_favoris.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/diagoriente/metiers-favoris",
          );
        });

        test('response should be valid', () async {
          await sut.expectTrueAsResult();
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
