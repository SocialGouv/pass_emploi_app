import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/immersion_contact.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/repositories/immersion_details_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('fetch when response is valid without contact info should return immersion', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-immersion/id-immersion")) return invalidHttpResponse();
      return Response(loadTestAssets("immersion_details_without_contact.json"), 200);
    });
    final repository = ImmersionDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersion = await repository.fetch("ID", "id-immersion");

    // Then
    expect(
      immersion,
      ImmersionDetails(
        id: "3eaa17fb-a912-4610-863d-93c5db29ea0c",
        metier: "xxxx",
        nomEtablissement: "CTRE SOINS SUITE ET READAPTAT EN ADDICTO",
        secteurActivite: "xxxx",
        ville: "xxxx",
        adresse: "Service des ressources humaines, 40 RUE DU DEPUTE HALLEZ, 67500 HAGUENAU",
        isVolontaire: false,
        contact: null,
      ),
    );
  });

  test('fetch when response is valid with contact info should return immersion', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-immersion/id-immersion")) return invalidHttpResponse();
      return Response(loadTestAssets("immersion_details_with_contact.json"), 200);
    });
    final repository = ImmersionDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersion = await repository.fetch("ID", "id-immersion");

    // Then
    expect(
      immersion,
      ImmersionDetails(
        id: "0e32e7bd-b1dd-468d-8faa-d82ae6f5a939",
        metier: "xxxx",
        nomEtablissement: "GSF SATURNE",
        secteurActivite: "xxxx",
        ville: "xxxx",
        adresse: "4 RUE DES FRERES LUMIERE 67170 BRUMATH",
        isVolontaire: true,
        contact: ImmersionContact(
          lastName: "PHILIPPE",
          firstName: "LAUREAU",
          phone: "",
          mail: "gsf-responsables@ch-bischwiller.fr",
          role: "Responsable Nettoyage",
          mode: ImmersionContactMode.EMAIL,
        ),
      ),
    );
  });

  test('fetch when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ImmersionDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersion = await repository.fetch("ID", "id-immersion");

    // Then
    expect(immersion, isNull);
  });

  test('fetch when response throws exception should return null', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = ImmersionDetailsRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersion = await repository.fetch("ID", "id-immersion");

    // Then
    expect(immersion, isNull);
  });
}
