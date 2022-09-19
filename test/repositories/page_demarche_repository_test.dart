import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository.dart';
import '../utils/mock_demo_client.dart';

void main() {
  final sut = RepositorySut<PageDemarcheRepository>();
  sut.givenRepository((client) => PageDemarcheRepository("BASE_URL", client));

  group("getPageDemarches", () {
    sut.when((repository) => repository.getPageDemarches("UID"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "home_demarches.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/jeunes/UID/home/demarches",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<PageDemarches?>((result) {
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
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });

  // todo demo ?

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
