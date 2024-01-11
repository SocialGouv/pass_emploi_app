import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_details_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  group('ServiceCiviqueDetailRepository', () {
    final sut = DioRepositorySut<ServiceCiviqueDetailRepository>();
    sut.givenRepository((client) => ServiceCiviqueDetailRepository(client));

    group('getServiceCiviqueDetail', () {
      sut.when((repository) => repository.getServiceCiviqueDetail('id'));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "service_civique_detail.json");

        test('request should be valid', () {
          sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/services-civique/id",
          );
        });

        test('result should be valid', () {
          sut.expectResult<SuccessfullServiceCiviqueDetailResponse>((response) {
            expect(
              response,
              SuccessfullServiceCiviqueDetailResponse(
                ServiceCiviqueDetail(
                  id: "je_suis_un_id",
                  titre: "Accompagner la mise en place d'actions culturelles en milieu carcéral",
                  dateDeDebut: "15 février 2022",
                  dateDeFin: "14 octobre 2022",
                  domaine: "solidarite-insertion",
                  ville: "Laon",
                  organisation: "Direction interrégionale des services pénitentiaires de Lille",
                  lienAnnonce:
                      "https://api.api-engagement.beta.gouv.fr/r/61dd694ed016777c442bd35b/61716de019fb03075a0b0d19",
                  urlOrganisation: "http://www.justice.gouv.fr/prison-et-reinsertion-10036/la-vie-en-detention-10039/",
                  adresseMission: "17 Rue des Epinettes",
                  adresseOrganisation: "123 rue nationale , 59000 Lille, France",
                  codeDepartement: "02000",
                  description:
                      "En lien avec le responsable des activités de l'établissement pénitentiaire, le volontaire pourra dormir",
                  descriptionOrganisation: null,
                  codePostal: "75012",
                ),
              ),
            );
          });
        });
      });

      group('when response is valid with code department as int', () {
        sut.givenJsonResponse(fromJson: "service_civique_detail_2.json");

        test('result should be valid', () {
          sut.expectResult<SuccessfullServiceCiviqueDetailResponse>((response) {
            expect(response.detail.codeDepartement, '13');
          });
        });
      });

      group('when response is 404', () {
        sut.givenResponseCode(404);

        test('result should be not found', () {
          sut.expectResult<NotFoundServiceCiviqueDetailResponse>((response) {
            expect(response, NotFoundServiceCiviqueDetailResponse());
          });
        });
      });

      group('when response is 500', () {
        sut.givenResponseCode(500);

        test('result should be not found', () {
          sut.expectResult<NotFoundServiceCiviqueDetailResponse>((response) {
            expect(response, NotFoundServiceCiviqueDetailResponse());
          });
        });
      });

      group('when response throws exception', () {
        sut.givenThrowingExceptionResponse();

        test('result should be failure', () {
          sut.expectResult<FailedServiceCiviqueDetailResponse>((response) {
            expect(response, FailedServiceCiviqueDetailResponse());
          });
        });
      });
    });
  });
}
