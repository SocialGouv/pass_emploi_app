import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/recherches_recentes_repository.dart';

import '../dsl/sut_repository2.dart';

void main() {
  group('RecherchesRecentesRepository', () {
    final sut = RepositorySut2<RecherchesRecentesRepository>();
    sut.givenRepository((client) => RecherchesRecentesRepository(client));

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
