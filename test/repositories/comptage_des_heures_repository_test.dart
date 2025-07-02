import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/comptage_des_heures.dart';
import 'package:pass_emploi_app/repositories/comptage_des_heures_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('ComptageDesHeuresRepository', () {
    final sut = DioRepositorySut<ComptageDesHeuresRepository>();
    sut.givenRepository((client) => ComptageDesHeuresRepository(client));

    group('get comptage des heures', () {
      sut.when((repository) => repository.get(userId: "userId"));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "comptage.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/userId/comptage",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<ComptageDesHeures?>((result) {
            expect(
                result,
                ComptageDesHeures(
                  nbHeuresDeclarees: 10,
                  nbHeuresValidees: 8,
                  dateDerniereMiseAJour: DateTime(2021, 7, 19, 15, 10, 0),
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
  });
}
