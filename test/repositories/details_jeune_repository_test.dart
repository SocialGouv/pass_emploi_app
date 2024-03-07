import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/details_jeune.dart';
import 'package:pass_emploi_app/repositories/details_jeune/details_jeune_repository.dart';

import '../dsl/sut_dio_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  final sut = DioRepositorySut<DetailsJeuneRepository>();
  sut.givenRepository((client) => DetailsJeuneRepository(client));

  group("fetch", () {
    sut.when((repository) => repository.fetch("id-jeune"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "details_jeune.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/jeunes/id-jeune",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<DetailsJeune?>((result) {
          expect(result, isNotNull);
          expect(
              result,
              DetailsJeune(
                conseiller: DetailsJeuneConseiller(
                  id: "ID_CONSEILLER",
                  firstname: "Nils",
                  lastname: "Tavernier",
                  sinceDate: parseDateTimeUtcWithCurrentTimeZone('2022-02-15T0:0:0.0Z'),
                ),
                structure: StructureMilo("ID-STRUCTURE", "Mission locale Brest"),
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
}
