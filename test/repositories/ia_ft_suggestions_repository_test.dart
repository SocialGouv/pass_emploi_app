import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/ia_ft_suggestions_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('IaFtSuggestionsRepository', () {
    final sut = DioRepositorySut<IaFtSuggestionsRepository>();
    sut.givenRepository((client) => IaFtSuggestionsRepository(client));

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
