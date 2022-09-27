import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/repositories/demarche/search_demarche_repository.dart';

import '../../dsl/sut_repository.dart';

void main() {
  final sut = RepositorySut<SearchDemarcheRepository>();
  sut.givenRepository((client) => SearchDemarcheRepository("BASE_URL", client));

  group("search", () {
    sut.when(
      (repository) => repository.search("query"),
    );

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "demarches_du_referentiel.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/referentiels/pole-emploi/types-demarches?recherche=query",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<List<DemarcheDuReferentiel>?>((result) {
          expect(result, isNotNull);
          expect(result!.length, 1);
          expect(result.first.id, isNotNull);
          expect(result.first.quoi, 'Mes candidatures');
          expect(result.first.pourquoi, 'Participation');
          expect(result.first.codeQuoi, 'P01');
          expect(result.first.codePourquoi, 'P8');
          expect(
            result.first.comments,
            [
              Comment(label: 'En voiture', code: 'VOITURE'),
              Comment(label: 'En avion', code: 'AVION'),
            ],
          );
          expect(result.first.isCommentMandatory, isTrue);
        });
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(400);

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });

    group('when response throws exception', () {
      sut.givenThrowingExceptionResponse();

      test('response should be null', () async {
        await sut.expectNullResult();
      });
    });
  });
}
