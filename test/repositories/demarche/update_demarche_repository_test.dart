import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/repositories/demarche/update_demarche_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<UpdateDemarcheRepository>();
  sut.givenRepository((client) => UpdateDemarcheRepository(client));

  group("updateDemarche", () {
    sut.when(
      (repository) => repository.updateDemarche(
        'user-id',
        '8802034',
        DemarcheStatus.pasCommencee,
        DateTime.utc(2021, 12, 24, 12, 8, 10),
        DateTime.utc(2021, 12, 23, 12, 8, 10),
      ),
    );

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "demarche_modified.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.put,
          url: "/jeunes/user-id/demarches/8802034/statut",
          jsonBody: {
            "statut": "A_FAIRE",
            "dateFin": "2021-12-24T12:08:10+00:00",
            "dateDebut": "2021-12-23T12:08:10+00:00",
          },
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<Demarche?>((result) {
          expect(result, isNotNull);
          expect(result!.id, '8802034');
        });
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(400);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });
}
