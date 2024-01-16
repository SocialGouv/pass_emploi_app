import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/mon_suivi_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('MonSuiviRepository', () {
    final sut = DioRepositorySut<MonSuiviRepository>();
    sut.givenRepository((client) => MonSuiviRepository(client));

    group('get', () {
      sut.when(
        (repository) => repository.getMonSuivi(userId: 'user-id', debut: DateTime(2024, 1), fin: DateTime(2024, 2)),
      );

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
