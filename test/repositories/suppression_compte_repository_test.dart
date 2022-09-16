import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/suppression_compte_repository.dart';

import '../dsl/sut_repository.dart';

void main() {
  final sut = RepositorySut<SuppressionCompteRepository>();
  sut.givenRepository((client) => SuppressionCompteRepository("BASE_URL", client));

  group("deleteUser", () {
    sut.when((repository) => repository.deleteUser("jeuneId"));

    group('when response is valid', () {
      sut.givenResponseCode(204);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "DELETE",
          url: "BASE_URL/jeunes/jeuneId",
        );
      });

      test('response should be valid', () async {
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
}
