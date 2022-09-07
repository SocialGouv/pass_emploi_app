import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/mock_demo_client.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

void main() {
  test('getPageDemarches when response is valid', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/UID/home/demarches")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("home_demarches.json"), 200);
    });
    final repository = PageDemarcheRepository("BASE_URL", httpClient);

    // When
    final PageDemarches? result = await repository.getPageDemarches("UID");

    // Then
    expect(result, isNotNull);
    expect(result?.campagne, isNotNull);
    expect(
      result?.campagne,
      Campagne(
        id: "id-campagne",
        titre: "Votre expérience sur l'application",
        description: "Donnez nous votre avis",
        questions: [
          Question(id: 1, libelle: "la question ?", options: [
            Option(id: 1, libelle: "Non, pas du tout"),
          ])
        ],
      ),
    );
    expect(result?.demarches, isNotNull);
    expect(result?.demarches.length, 7);
    expect(result?.demarches.first, demarcheStub());
  });

  test('getPageDemarches when response is valid when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = PageDemarcheRepository("BASE_URL", httpClient);

    // When
    final search = await repository.getPageDemarches("UserID");

    // Then
    expect(search, isNull);
  });

  test('mode demo should return valid request', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = PageDemarcheRepository("BASE_URL", httpClient);

    // When
    final response = await repository.getPageDemarches("UserID");

    // Then
    expect(response, isNotNull);
    expect(response?.campagne, isNotNull);
    expect(response?.demarches, isNotNull);
  });
}
