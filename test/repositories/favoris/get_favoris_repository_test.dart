import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/repositories/favoris/get_favoris_repository.dart';

import '../../dsl/sut_repository2.dart';

void main() {
  group('GetFavorisRepository', () {
    final sut = RepositorySut2<GetFavorisRepository>();
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
                type: FavoriType.emploi,
                titre: 'titre-1',
                organisation: 'organisation-1',
                localisation: 'localisation-1',
              ),
            );
            expect(result[1].type, FavoriType.alternance);
            expect(result[2].type, FavoriType.immersion);
            expect(result[3].type, FavoriType.civique);
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
