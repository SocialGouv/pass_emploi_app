import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/models/thematique_de_demarche.dart';
import 'package:pass_emploi_app/repositories/thematiques_demarche_repository.dart';

import '../dsl/sut_dio_repository.dart';

void main() {
  group('ThematiquesDemarcheRepository', () {
    final sut = DioRepositorySut<ThematiquesDemarcheRepository>();
    sut.givenRepository((client) => ThematiquesDemarcheRepository(client));

    group('get', () {
      sut.when((repository) => repository.get());

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'thematiques_demarche.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: "/referentiels/pole-emploi/thematiques-demarche",
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<ThematiqueDeDemarche>?>((result) {
            _expectDummyThematique(result);
            final demarches = result!.first.demarches;
            _expectDummyDemarche(demarches);
          });
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(400);

        test('response should be null', () async {
          await sut.expectNullResult();
        });
      });
    });
  });
}

void _expectDummyDemarche(List<DemarcheDuReferentiel> demarches) {
  expect(demarches, isNotNull);
  expect(demarches.length, 1);
  expect(demarches.first.id, isNotNull);
  expect(demarches.first.quoi, 'Mes candidatures');
  expect(demarches.first.pourquoi, 'Participation');
  expect(demarches.first.codeQuoi, 'P01');
  expect(demarches.first.codePourquoi, 'P8');
  expect(
    demarches.first.comments,
    [
      Comment(label: 'En voiture', code: 'VOITURE'),
      Comment(label: 'En avion', code: 'AVION'),
    ],
  );
  expect(demarches.first.isCommentMandatory, isTrue);
}

void _expectDummyThematique(List<ThematiqueDeDemarche>? result) {
  expect(result, isNotNull);
  expect(result!.length, 1);
  expect(result.first.code, "P03");
  expect(result.first.libelle, "Mes candidatures");
}
