import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/contact_immersion_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_dio_repository.dart';

void main() {
  group('ContactImmersionRepository', () {
    final sut = DioRepositorySut<ContactImmersionRepository>();
    sut.givenRepository((client) => ContactImmersionRepository(client));

    group('post', () {
      sut.when((repository) => repository.post("UID", mockContactImmersionRequest()));

      group('when response is valid', () {
        sut.givenResponseCode(200);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/UID/offres-immersion/contact",
            jsonBody: {
              "codeRome": "codeRome",
              "labelRome": "metier",
              "siret": "siret",
              "prenom": "Philippe",
              "nom": "Flopflip",
              "email": "philippe.flopflip@magiciens.com",
              "message": "Bonjour, j'aimerai faire une immersion dans votre salon de magie.",
              "contactMode": "EMAIL",
            },
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<ContactImmersionResponse>((response) {
            expect(response, ContactImmersionResponse.success);
          });
        });
      });

      group('when response is 409', () {
        sut.givenResponseCode(409);

        test('response should be already done', () async {
          await sut.expectResult<ContactImmersionResponse>((response) {
            expect(response, ContactImmersionResponse.alreadyDone);
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(500);

        test('response should be null', () async {
          await sut.expectResult<ContactImmersionResponse>((response) {
            expect(response, ContactImmersionResponse.failure);
          });
        });
      });
    });
  });
}
