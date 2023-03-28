import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';

import '../dsl/sut_repository2.dart';

void main() {
  // TODO: ajouter les tests
  group('ContactImmersionRepository', () {
    final sut = RepositorySut2<ContactImmersionRepository>();
    sut.givenRepository((client) => ContactImmersionRepository(client));

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
