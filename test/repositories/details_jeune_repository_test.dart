import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

import '../dsl/sut_repository.dart';
import '../utils/mock_demo_client.dart';
import '../utils/test_datetime.dart';

void main() {
  final sut = RepositorySut<DetailsJeuneRepository>();
  sut.givenRepository((client) => DetailsJeuneRepository("BASE_URL", client));

  group("fetch", () {
    sut.when((repository) => repository.fetch("id-jeune"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "details_jeune.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/jeunes/id-jeune",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<DetailsJeune?>((result) {
          expect(result, isNotNull);
          expect(
              result,
              DetailsJeune(
                conseiller: DetailsJeuneConseiller(
                  firstname: "Nils",
                  lastname: "Tavernier",
                  sinceDate: parseDateTimeUtcWithCurrentTimeZone('2022-02-15T0:0:0.0Z'),
                ),
              ));
        });
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });

  // TODO : utile ? Il n'y a pas un test général ?
  // Si oui utile, alors ajouter un helper dans le RepositorySut
  test('should return details jeune on valid request', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = DetailsJeuneRepository("BASE_URL", httpClient);

    // When
    final response = await repository.fetch("id-jeune");

    // Then
    expect(response, isNotNull);
  });
}
