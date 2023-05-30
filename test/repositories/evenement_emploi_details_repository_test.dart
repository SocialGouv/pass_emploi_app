import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/evenement_emploi_details_repository.dart';

import '../dsl/sut_repository2.dart';

void main() {
  group('EvenementEmploiDetailsRepository', () {
    final sut = RepositorySut2<EvenementEmploiDetailsRepository>();
    sut.givenRepository((client) => EvenementEmploiDetailsRepository(client));

    group('get', () {
      sut.when((repository) => repository.get());

      group('when response is valid', () {
        sut.givenResponseCode(200); //TODO:

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/todo",
          );
        });

        test('response should be valid', () async {
          await sut.expectNullResult(); //TODO:
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectNullResult(); //TODO:
        });
      });
    });
  });
}
