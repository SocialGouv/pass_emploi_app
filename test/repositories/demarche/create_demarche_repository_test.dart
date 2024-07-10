import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/repositories/demarche/create_demarche_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  group('CreateDemarcheRepository', () {
    final sut = DioRepositorySut<CreateDemarcheRepository>();
    sut.givenRepository((client) => CreateDemarcheRepository(client));

    group("createDemarche", () {
      sut.when(
        (repository) => repository.createDemarche(
          userId: 'id',
          codeQuoi: 'codeQuoi',
          codePourquoi: 'codePourquoi',
          codeComment: 'codeComment',
          dateEcheance: DateTime(2021, 12, 23, 12, 8, 10),
          estDuplicata: false,
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'create_demarche.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/id/demarches",
            jsonBody: {
              "codeQuoi": "codeQuoi",
              "codePourquoi": "codePourquoi",
              "codeComment": "codeComment",
              "dateFin": "2021-12-23T12:08:10.000",
              "estDuplicata": false,
            },
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<DemarcheId?>((result) => expect(result, 'DEMARCHE-ID'));
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(400);

        test('response should be null', () async => await sut.expectNullResult());
      });
    });

    group("createDemarchePersonnalisee", () {
      sut.when(
        (repository) => repository.createDemarchePersonnalisee(
          userId: 'id',
          commentaire: 'Description accentuée',
          dateEcheance: DateTime(2021, 12, 23, 12, 8, 10),
          estDuplicata: false,
        ),
      );

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: 'create_demarche.json');

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/id/demarches",
            jsonBody: {
              "description": "Description accentuée",
              "dateFin": "2021-12-23T12:08:10.000",
              "estDuplicata": false,
            },
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<DemarcheId?>((result) => expect(result, 'DEMARCHE-ID'));
        });
      });

      group('when response is invalid', () {
        sut.givenResponseCode(400);

        test('response should be null', () async => await sut.expectNullResult());
      });
    });
  });
}
