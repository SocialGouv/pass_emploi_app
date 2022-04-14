import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/repositories/service_civique/service_civique_repository.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_assets.dart';

void main() {
  test('get detail when response is valid should return detail', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/services-civique/je_suis_un_id")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("service_civique_detail.json"), 200);
    });
    final repository = ServiceCiviqueDetailRepository("BASE_URL", httpClient);

    // When
    final result = await repository.getServiceCiviqueDetail("je_suis_un_id");

    // Then
    expect(result, isNotNull);
    expect(
      (result as SuccessfullServiceCiviqueDetailResponse).detail,
      ServiceCiviqueDetail(
        titre: "Accompagner la mise en place d'actions culturelles en milieu carcéral",
        dateDeDebut: "15 février 2022",
        dateDeFin: "14 octobre 2022",
        domaine: "solidarite-insertion",
        ville: "Laon",
        organisation: "Direction interrégionale des services pénitentiaires de Lille",
        lienAnnonce: "https://api.api-engagement.beta.gouv.fr/r/61dd694ed016777c442bd35b/61716de019fb03075a0b0d19",
        urlOrganisation: "http://www.justice.gouv.fr/prison-et-reinsertion-10036/la-vie-en-detention-10039/",
        adresseMission: "17 Rue des Epinettes",
        adresseOrganisation: "123 rue nationale , 59000 Lille, France",
        codeDepartement: "02000",
        description:
            "En lien avec le responsable des activités de l'établissement pénitentiaire, le volontaire pourra dormir",
        descriptionOrganisation: null,
        codePostal: "75012",
      ),
    );
  });

  test('search when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ServiceCiviqueDetailRepository("BASE_URL", httpClient);

    // When
    final search = await repository.getServiceCiviqueDetail("id");

    // Then
    expect(search, NotFoundServiceCiviqueDetailResponse());
  });

  test('search when response throws exception with 404 code should flag response as not found', () async {
    // Given
    final httpClient = MockClient((request) async => throw deletedOfferHttpResponse());
    final repository = ServiceCiviqueDetailRepository("BASE_URL", httpClient);

    // When
    final search = await repository.getServiceCiviqueDetail("id");

    // Then
    expect(search, NotFoundServiceCiviqueDetailResponse());
  });

}
