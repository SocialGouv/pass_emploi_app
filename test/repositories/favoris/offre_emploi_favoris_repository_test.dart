import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/repositories/favoris/offre_emploi_favoris_repository.dart';

import '../../doubles/dummies.dart';
import '../../dsl/sut_repository.dart';
import '../../utils/mock_demo_client.dart';

void main() {
  final sut = RepositorySut<OffreEmploiFavorisRepository>();
  sut.givenRepository((client) => OffreEmploiFavorisRepository("BASE_URL", client, DummyPassEmploiCacheManager()));

  group("getFavorisId", () {
    sut.when((repository) => repository.getFavorisId("jeuneId"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "offre_emploi_favoris_id.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/jeunes/jeuneId/favoris/offres-emploi",
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
          await sut.expectRequestBody(method: "POST", url: "BASE_URL/jeunes/jeuneId/favoris/offres-emploi", params: {
            "idOffre": "offreId",
            "titre": "title",
            "typeContrat": "contractType",
            "localisation": {"nom": "Paris"},
            "alternance": false,
            'duree': null,
            'nomEntreprise': null,
          });
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
              await sut
                  .expectRequestBody(method: "POST", url: "BASE_URL/jeunes/jeuneId/favoris/offres-emploi", params: {
                "idOffre": "offreId2",
                "titre": "otherTitle",
                "typeContrat": "otherContractType",
                "localisation": {"nom": "Marseille"},
                "alternance": isAlternance,
                'duree': "duration",
                'nomEntreprise': "companyName",
              });
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
          method: "DELETE",
          url: "BASE_URL/jeunes/jeuneId/favoris/offres-emploi/offreId",
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

  group("getFavoris", () {
    sut.when((repository) => repository.getFavoris("jeuneId"));

    group('when response is valid', () {
      sut.givenJsonResponse(fromJson: "offre_emploi_favoris_data.json");

      test('request should be valid', () async {
        await sut.expectRequestBody(
          method: "GET",
          url: "BASE_URL/jeunes/jeuneId/favoris/offres-emploi?detail=true",
        );
      });

      test('response should be valid', () async {
        await sut.expectResult<Map<String, OffreEmploi>?>((result) {
          expect(result, _expectedFavoriList());
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

  // TODO mode demo ?

  test('getFavorisId when mode demo', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavorisId("jeuneId");

    // Then
    expect(favoris, isNotEmpty);
  });

  test('getFavoris when mode demo', () async {
    // Given
    final httpClient = MockModeDemoClient();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavoris("jeuneId");

    // Then
    expect(favoris, isNotEmpty);
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
  );
}

Map<String, OffreEmploi> _expectedFavoriList() {
  return {
    "124PSHL": OffreEmploi(
      id: "124PSHL",
      duration: "Temps partiel",
      location: "974 - STE MARIE",
      contractType: "CDD",
      isAlternance: false,
      companyName: "SARL HAYA",
      title: "Cuisinier / Cuisinière",
    ),
    "124PSJW": OffreEmploi(
      id: "124PSJW",
      duration: "Temps partiel",
      location: "07 - LEMPS",
      contractType: "CDD",
      isAlternance: true,
      companyName: "ATALIAN PROPRETE",
      title: "Agent de nettoyage chez un particulier H/F",
    ),
    "124PSJS": OffreEmploi(
      id: "124PSJS",
      duration: "Temps partiel",
      location: "80 - AMIENS",
      contractType: "CDI",
      isAlternance: false,
      companyName: "CHARPENTE MENUISERIE ROUSSEAU",
      title: "Vendeur / Vendeuse de fruits et légumes",
    ),
    "124PSJR": OffreEmploi(
      id: "124PSJR",
      duration: "Temps plein",
      location: "63 - ISSOIRE",
      contractType: "CDI",
      isAlternance: false,
      companyName: "SERVICES MAINTENANCE INDUSTRIELLE",
      title: "Serrurier(ère) métallier(ère) industriel(le)                (H/F)",
    ),
    "123ZZZN1": OffreEmploi(
      id: "123ZZZN1",
      duration: "Temps plein",
      location: null,
      contractType: "CDI",
      companyName: "SUPER TAXI",
      title: "Chauffeur / Chauffeuse de taxi (H/F)",
      isAlternance: false,
    )
  };
}
