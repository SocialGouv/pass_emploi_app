import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  group('SavedSearchDeleteRepository', () {
    final sut = DioRepositorySut<SavedSearchDeleteRepository>();
    sut.givenRepository((client) => SavedSearchDeleteRepository(client));

    group('delete', () {
      sut.when((repository) => repository.delete("userId", "savedSearchId"));
      group('when response is valid', () {
        sut.givenResponseCode(204);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.delete,
            url: "/jeunes/userId/recherches/savedSearchId",
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
