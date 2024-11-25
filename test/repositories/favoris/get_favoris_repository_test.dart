import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  group('GetFavorisRepository', () {
    final sut = DioRepositorySut<GetFavorisRepository>();
    sut.givenRepository((client) => GetFavorisRepository(client));

    group('getFavoris', () {
      sut.when((repository) => repository.getFavoris('user-id'));

      group('when response is valid', () {
        sut.givenJsonResponse(fromJson: "favoris.json");

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.get,
            url: '/jeunes/user-id/favoris',
          );
        });

        test('response should be valid', () async {
          await sut.expectResult<List<Favori>?>((result) {
            expect(result, isNotNull);
            expect(result!.length, 4);
            expect(
              result[0],
              Favori(
                id: '1',
                type: OffreType.emploi,
                titre: 'titre-1',
                organisation: 'organisation-1',
                localisation: 'localisation-1',
                origin: PartenaireOrigin(name: 'Indeed', logoUrl: 'https://indeed.com/logo.png'),
              ),
            );
            expect(
              result[1],
              Favori(
                id: '2',
                type: OffreType.alternance,
                titre: 'titre-2',
                organisation: 'organisation-2',
                localisation: 'localisation-2',
                origin: FranceTravailOrigin(),
              ),
            );
            expect(result[2].type, OffreType.immersion);
            expect(result[3].type, OffreType.serviceCivique);
          });
        });
      });

      group('when response is valid with unknown favori types', () {
        sut.givenJsonResponse(fromJson: "favoris_with_unknown_types.json");

        test('unknown types should be removed from result', () async {
          await sut.expectResult<List<Favori>?>((result) {
            expect(result, isNotNull);
            expect(result!.length, 1);
            expect(result.first.id, '1');
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
  });
}
