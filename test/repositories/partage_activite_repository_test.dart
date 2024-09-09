import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/preferences.dart';
import 'package:pass_emploi_app/repositories/partage_activite_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('PartageActiviteRepository', () {
    final sut = DioRepositorySut<PartageActiviteRepository>();
    sut.givenRepository((client) => PartageActiviteRepository(client));

    group('getPartageActivite', () {
      sut.when(
        (repository) => repository.getPartageActivite("UID"),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "partage_activite.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/jeunes/UID/preferences",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<Preferences?>((result) {
            expect(result, Preferences(partageFavoris: true));
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

    group('updatePartageActivite', () {
      sut.when(
        (repository) => repository.updatePartageActivite("UID", true),
      );

      group('when response is valid', () {
        sut.givenResponseCode(200);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.put,
            url: "/jeunes/UID/preferences",
            jsonBody: {'partageFavoris': true},
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
