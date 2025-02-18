import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/auto_inscription_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('AutoInscriptionRepository', () {
    final sut = DioRepositorySut<AutoInscriptionRepository>();
    sut.givenRepository((client) => AutoInscriptionRepository(client));

    group('get', () {
      sut.when((repository) => repository.set("userId", "eventId"));

      group('when response is valid', () {
        sut.givenResponseCode(200);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/milo/userId/sessions/eventId/inscrire",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<AutoInscriptionSuccess>((result) => true);
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectResult<AutoInscriptionGenericError>((result) => true);
        });
      });

      group('when response has NOMBRE_PLACE_INSUFFISANT code', () {
        sut.givenResponseCode(400, responseData: {"code": "NOMBRE_PLACE_INSUFFISANT"});

        test('response should be null', () async {
          await sut.expectResult<AutoInscriptionNombrePlacesInsuffisantes>((result) => true);
        });
      });

      group('when response is invalid with 422', () {
        sut.givenResponseCode(422);

        test('response should be null', () async {
          await sut.expectResult<AutoInscriptionConseillerInactif>((result) => true);
        });
      });
    });
  });
}
