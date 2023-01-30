import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/raclette_repository.dart';

import '../dsl/sut_repository2.dart';

void main() {
  group('RacletteRepository', () {
    final sut = RepositorySut2<RacletteRepository>();
    sut.givenRepository((client) => RacletteRepository(client));

    group('get', () {
      sut.when((repository) => repository.get());

      group('when response is valid', () {
        sut.givenResponseCode(200);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/todo",
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
