import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';

import '../doubles/dummies.dart';
import '../dsl/sut_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  final sut = RepositorySut<ActionCommentaireRepository>();
  sut.givenRepository((client) => ActionCommentaireRepository("BASE_URL", client, DummyPassEmploiCacheManager()));

  group("getCommentaires", () {
    sut.when((repository) => repository.getCommentaires("actionId"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "commentaires.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/actions/actionId/commentaires",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<List<Commentaire>?>((result) {
          expect(result, isNotNull);
          expect(result?.length, 2);
          expect(
            result?[0],
            Commentaire(
              id: "8392839",
              content: "Premier commentaire",
              creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T12:08:10.000"),
              createdByAdvisor: true,
              creatorName: "Nils Tavernier",
            ),
          );
          expect(
            result?[1],
            Commentaire(
              id: "8802034",
              content: "Deuxieme commentaire",
              creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T17:08:10.000"),
              createdByAdvisor: false,
              creatorName: null,
            ),
          );
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

  group("sendCommentaires", () {
    sut.when(
      (repository) => repository.sendCommentaire(
        actionId: 'actionId',
        comment: 'Commentaire à envoyer',
      ),
    );

    group('when response is valid', () {
      sut.givenResponseCode(200);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/actions/actionId/commentaires",
          jsonBody: {
            "commentaire": "Commentaire à envoyer",
          },
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be null', () async {
        await sut.expectFalseAsResult();
      });
    });
  });
}
