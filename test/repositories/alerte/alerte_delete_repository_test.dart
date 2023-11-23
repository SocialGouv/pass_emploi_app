import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/alerte/alerte_delete_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  group('AlerteDeleteRepository', () {
    final sut = DioRepositorySut<AlerteDeleteRepository>();
    sut.givenRepository((client) => AlerteDeleteRepository(client));

    group('delete', () {
      sut.when((repository) => repository.delete("userId", "alerteId"));
      group('when response is valid', () {
        sut.givenResponseCode(204);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.delete,
            url: "/jeunes/userId/recherches/alerteId",
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
