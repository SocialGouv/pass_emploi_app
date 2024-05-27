import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/repositories/animations_collectives_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('AnimationsCollectivesRepository', () {
    final sut = DioRepositorySut<AnimationsCollectivesRepository>();
    sut.givenRepository((client) => AnimationsCollectivesRepository(client));

    group('get', () {
      sut.when(
        (repository) => repository.get("UID", DateTime.utc(2022, 11, 5)),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "animations-collectives.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/animations-collectives?maintenant=2022-11-05T00%3A00%3A00%2B00%3A00",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<Rendezvous>?>((result) {
            expect(result, isNotNull);
            expect(result?.length, 3);

            expect(
              result?[0],
              mockAnimationCollective(),
            );

            expect(result?[0].estInscrit, true);
            expect(result?[1].estInscrit, false);
            expect(result?[2].estInscrit, null);
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
  });
}
