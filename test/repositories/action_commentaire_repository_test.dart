import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/repositories/action_commentaire_repository.dart';

import '../doubles/dummies.dart';
import '../dsl/sut_dio_repository.dart';
import '../utils/test_datetime.dart';

void main() {
  final sut = DioRepositorySut<ActionCommentaireRepository>();
  sut.givenRepository((client) => ActionCommentaireRepository(client, DummyPassEmploiCacheManager()));

  group("getCommentaires", () {
    sut.when((repository) => repository.getCommentaires("actionId"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "commentaires.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/actions/actionId/commentaires",
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
}
