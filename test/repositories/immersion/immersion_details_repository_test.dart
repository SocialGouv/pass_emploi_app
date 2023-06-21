import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/repositories/immersion/immersion_details_repository.dart';
import 'package:pass_emploi_app/repositories/offre_emploi/offre_emploi_details_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<ImmersionDetailsRepository>();
  sut.givenRepository((client) => ImmersionDetailsRepository(client));

  group('fetch', () {
    sut.when((repository) => repository.fetch('id-immersion'));

    group('when response is valid without contact', () {
      sut.givenJsonResponse(fromJson: "immersion_details_without_contact.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-immersion/id-immersion',
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<OffreDetailsResponse<ImmersionDetails>>((result) {
          expect(result.isGenericFailure, isFalse);
          expect(result.isOffreNotFound, isFalse);
          expect(
            result.details,
            ImmersionDetails(
              id: "3eaa17fb-a912-4610-863d-93c5db29ea0c",
              metier: "xxxx",
              companyName: "CTRE SOINS SUITE ET READAPTAT EN ADDICTO",
              secteurActivite: "xxxx",
              ville: "xxxx",
              address: "Service des ressources humaines, 40 RUE DU DEPUTE HALLEZ, 67500 HAGUENAU",
              codeRome: "G1102",
              siret: "12345678901234",
              fromEntrepriseAccueillante: false,
              contact: null,
            ),
          );
        });
      });
    });

    group('when response is valid with contact', () {
      sut.givenJsonResponse(fromJson: "immersion_details_with_contact.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: '/offres-immersion/id-immersion',
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<OffreDetailsResponse<ImmersionDetails>>((result) {
          expect(result.isGenericFailure, isFalse);
          expect(result.isOffreNotFound, isFalse);
          expect(
            result.details,
            ImmersionDetails(
              id: "0e32e7bd-b1dd-468d-8faa-d82ae6f5a939",
              metier: "xxxx",
              companyName: "GSF SATURNE",
              secteurActivite: "xxxx",
              ville: "xxxx",
              address: "4 RUE DES FRERES LUMIERE 67170 BRUMATH",
              codeRome: "G1102",
              siret: "12345678901234",
              fromEntrepriseAccueillante: true,
              contact: ImmersionContact(
                lastName: "PHILIPPE",
                firstName: "LAUREAU",
                phone: "",
                mail: "gsf-responsables@ch-bischwiller.fr",
                role: "Responsable Nettoyage",
                mode: ImmersionContactMode.MAIL,
              ),
            ),
          );
        });
      });
    });

    group('when response is 404', () {
      sut.givenResponseCode(HttpStatus.notFound);

      test('response should be flagged as not found', () async {
        await sut.expectResult<OffreDetailsResponse<ImmersionDetails>>((result) {
          expect(result.isGenericFailure, isFalse);
          expect(result.isOffreNotFound, isTrue);
        });
      });
    });

    group('when response throws exception', () {
      sut.givenThrowingExceptionResponse();

      test('response should be generic failure', () async {
        await sut.expectResult<OffreDetailsResponse<ImmersionDetails>>((result) {
          expect(result.isGenericFailure, isTrue);
          expect(result.isOffreNotFound, isFalse);
        });
      });
    });
  });
}
