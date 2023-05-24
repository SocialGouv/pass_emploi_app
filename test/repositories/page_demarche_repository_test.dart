import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/page_demarches.dart';
import 'package:pass_emploi_app/repositories/page_demarche_repository.dart';

import '../doubles/fixtures.dart';
import '../dsl/sut_repository2.dart';
import '../utils/test_datetime.dart';

void main() {
  final sut = RepositorySut2<PageDemarcheRepository>();
  sut.givenRepository((client) => PageDemarcheRepository(client));

  group("getPageDemarches", () {
    sut.when((repository) => repository.getPageDemarches("UID"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "home_demarches.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/v2/jeunes/UID/home/demarches",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<PageDemarches?>((result) {
          expect(result, isNotNull);
          expect(result!.campagne, isNotNull);
          expect(
            result.campagne,
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
          expect(result.demarches, isNotNull);
          expect(result.demarches.length, 7);
          expect(result.demarches.first, demarcheStub());
          expect(result.dateDerniereMiseAJour, parseDateTimeUtcWithCurrentTimeZone('2023-01-01T00:00:00.000Z'));
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
}
