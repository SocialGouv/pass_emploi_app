import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';

import '../../dsl/sut_dio_repository.dart';

void main() {
  final sut = DioRepositorySut<OffreEmploiFavorisRepository>();
  sut.givenRepository((client) => OffreEmploiFavorisRepository(client));

  group("getFavorisId", () {
    sut.when((repository) => repository.getFavorisId("jeuneId"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "offre_emploi_favoris_id.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.get,
          url: "/jeunes/jeuneId/favoris/offres-emploi",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<Set<String>?>((result) {
          expect(result, ["124GQRG", "124FGRM", "124FGFB", "124FGJJ"]);
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
    group("with partial data in request", () {
      sut.when((repository) => repository.postFavori("jeuneId", _offreWithPartialData()));

      group('when response is valid', () {
        sut.givenResponseCode(201);

        test('request should be valid', () async {
          await sut.expectRequestBody(
            method: HttpMethod.post,
            url: "/jeunes/jeuneId/favoris/offres-emploi",
            jsonBody: {
              "idOffre": "offreId",
              "titre": "title",
              "typeContrat": "contractType",
              "localisation": {"nom": "Paris"},
              "alternance": false,
              'duree': null,
              'nomEntreprise': null,
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

    group("with full data in request", () {
      void expectValidRequestAndResponse({required bool isAlternance}) {
        group("isAlternance : $isAlternance", () {
          sut.when((repository) => repository.postFavori("jeuneId", _offreWithFullData(isAlternance: isAlternance)));

          group('when response is valid', () {
            sut.givenResponseCode(201);

            test('request should be valid', () async {
              await sut.expectRequestBody(
                method: HttpMethod.post,
                url: "/jeunes/jeuneId/favoris/offres-emploi",
                jsonBody: {
                  "idOffre": "offreId2",
                  "titre": "otherTitle",
                  "typeContrat": "otherContractType",
                  "localisation": {"nom": "Marseille"},
                  "alternance": isAlternance,
                  'duree': "duration",
                  'nomEntreprise': "companyName",
                },
              );
            });

            test('response should be valid', () async {
              await sut.expectResult<bool?>((result) {
                expect(result, true);
              });
            });
          });
        });
      }

      expectValidRequestAndResponse(isAlternance: true);
      expectValidRequestAndResponse(isAlternance: false);
    });
  });

  group("deleteFavori", () {
    sut.when((repository) => repository.deleteFavori("jeuneId", "offreId"));

    group('when response is valid', () {
      sut.givenResponseCode(204);

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: HttpMethod.delete,
          url: "/jeunes/jeuneId/favoris/offres-emploi/offreId",
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

OffreEmploi _offreWithPartialData() {
  return OffreEmploi(
    id: "offreId",
    duration: null,
    contractType: "contractType",
    companyName: null,
    isAlternance: false,
    location: "Paris",
    title: "title",
    origin: null,
  );
}

OffreEmploi _offreWithFullData({required bool isAlternance}) {
  return OffreEmploi(
    id: "offreId2",
    duration: "duration",
    contractType: "otherContractType",
    companyName: "companyName",
    isAlternance: isAlternance,
    location: "Marseille",
    title: "otherTitle",
    origin: null,
  );
}
