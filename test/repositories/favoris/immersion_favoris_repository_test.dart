import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/repositories/favoris/favoris_repository.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<ImmersionFavorisRepository>();
  sut.givenRepository((client) => ImmersionFavorisRepository(client));

  group("getFavorisId", () {
    sut.when((repository) => repository.getFavorisId("jeuneId"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "immersion_favoris_id.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/jeunes/jeuneId/favoris/offres-immersion",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<Set<FavoriDto>?>((result) {
          expect(result, [
            FavoriDto("4f44d3ec-6568-41f0-b66e-e53a9e1fe904"),
            FavoriDto("4277d7b7-3d86-453d-9375-14aee8fde94d"),
            FavoriDto("b2d70bb3-ba69-4dd8-880a-62171b48ecbc"),
          ]);
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

  group("postFavori", () {
    sut.when((repository) => repository.postFavori("jeuneId", _offreWithFullData()));

    group('when response is valid', () {
      sut.givenResponseCode(200);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.post,
          url: "/jeunes/jeuneId/favoris/offres-immersion",
          jsonBody: {
            'idOffre': '98286f66-2a8e-4a22-80a8-c6fda3a52980',
            'metier': 'Boulanger',
            'nomEtablissement': 'EPSAN Brumath',
            'secteurActivite': 'Boulangerie',
            'ville': 'Brumath'
          },
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });
    });

    group('when response is invalid', () {
      sut.givenResponseCode(500);

      test('response should be false', () async {
        await sut.expectFalseAsResult();
      });
    });

    group('when response is 409', () {
      sut.givenResponseCode(409);

      test('response should be true', () async {
        await sut.expectTrueAsResult();
      });
    });
  });

  group("deleteFavori", () {
    sut.when((repository) => repository.deleteFavori("jeuneId", "offreId"));

    group('when response is valid', () {
      sut.givenResponseCode(204);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.delete,
          url: "/jeunes/jeuneId/favoris/offres-immersion/offreId",
        );
      });

      test('response should be valid', () async {
        await sut.expectTrueAsResult();
      });
    });

    group('when response is 404', () {
      sut.givenResponseCode(404);

      test('response should be true', () async {
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

Immersion _offreWithFullData() {
  return Immersion(
    id: "98286f66-2a8e-4a22-80a8-c6fda3a52980",
    ville: 'Brumath',
    nomEtablissement: 'EPSAN Brumath',
    metier: 'Boulanger',
    secteurActivite: 'Boulangerie',
  );
}
