import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../dsl/sut_repository.dart';

void main() {
  final sut = RepositorySut<CreateDemarcheRepository>();
  sut.givenRepository((client) => CreateDemarcheRepository("BASE_URL", client));

  group("createDemarche", () {
    sut.when(
      (repository) => repository.createDemarche(
        userId: 'id',
        codeQuoi: 'codeQuoi',
        codePourquoi: 'codePourquoi',
        codeComment: 'codeComment',
        dateEcheance: DateTime(2021, 12, 23, 12, 8, 10),
      ),
    );

    group('when response is valid', () {
      sut.givenResponseCode(200);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/jeunes/id/demarches",
          params: {
            "codeQuoi": "codeQuoi",
            "codePourquoi": "codePourquoi",
            "codeComment": "codeComment",
            "dateFin": "2021-12-23T12:08:10.000",
          },
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(400);

      test('response should be null', () async {
        await sut.expectFalseAsResult();
      });
    });
  });

  group("createDemarchePersonnalisee", () {
    sut.when(
      (repository) => repository.createDemarchePersonnalisee(
        userId: 'id',
        commentaire: 'Description accentuée',
        dateEcheance: DateTime(2021, 12, 23, 12, 8, 10),
      ),
    );

    group('when response is valid', () {
      sut.givenResponseCode(200);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "POST",
          url: "BASE_URL/jeunes/id/demarches",
          params: {
            "description": "Description accentuée",
            "dateFin": "2021-12-23T12:08:10.000",
          },
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(400);

      test('response should be null', () async {
        await sut.expectFalseAsResult();
      });
    });
  });
}
