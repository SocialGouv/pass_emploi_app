import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/favoris/service_civique_favoris_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';
import '../../utils/test_assets.dart';

void main() {
  test('getFavorisId when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/services-civique")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("service_civique_favoris_id.json"), 200);
    });
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavorisId("jeuneId");

    // Then
    expect(favoris, [
      "4f44d3ec-6568-41f0-b66e-e53a9e1fe904",
      "4277d7b7-3d86-453d-9375-14aee8fde94d",
      "b2d70bb3-ba69-4dd8-880a-62171b48ecbc",
    ]);
  });

  test('getFavorisId when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavorisId("jeuneId");

    // Then
    expect(favoris, isNull);
  });

  test(
      "postFavori when adding favori should post correct data when all fields are not null and return true when response is valid",
      () async {
    // Given
    final httpClient = _mockClientForFullData();

    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.postFavori("jeuneId", _offreWithFullData());

    // Then
    expect(result, isTrue);
  });

  test("deleteFavori when removing favori should delete with correct id and return true when response is valid",
      () async {
    // Given
        final httpClient = _successfulClientForDelete();
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.deleteFavori("jeuneId", "offreId");

    // Then
    expect(result, isTrue);
  });

  test("deleteFavori when removing favori should return true when response is a 404", () async {
    // Given
    final httpClient = _notFoundClient();
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.deleteFavori("jeuneId", "offreId");

    // Then
    expect(result, true);
  });

  test("deleteFavori when removing favori should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.deleteFavori("jeuneId", "offreId");

    // Then
    expect(result, isFalse);
  });

  test("postFavori when adding favori should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.postFavori("jeuneId", _offreWithFullData());

    // Then
    expect(result, isFalse);
  });

  test("postFavori when adding favori should return true when response is 409", () async {
    // Given
    final httpClient = _alreadyExistsClient();
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.postFavori("jeuneId", _offreWithFullData());

    // Then
    expect(result, isTrue);
  });

  test('getFavoris when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = _successfulClientForQuery();
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavoris("jeuneId");

    // Then
    expect(favoris, {
      "61dd6f4cd016777c442bd8c7": ServiceCivique(
          id: "61dd6f4cd016777c442bd8c7",
          title: "Accompagnement des publics individuels",
          startDate: "2021-12-01T00:00:00.000Z",
          domain: "solidarite-insertion",
          location: "Valençay",
          companyName: "SYNDICAT MIXTE DU CHATEAU DE VALENCAY"),
      "61dd6f4ad016777c442bd8c5": ServiceCivique(
          id: "61dd6f4ad016777c442bd8c5",
          title: "Accompagnement des publics groupes",
          startDate: "2021-12-01T00:00:00.000Z",
          domain: "solidarite-insertion",
          location: "Valençay",
          companyName: "SYNDICAT MIXTE DU CHATEAU DE VALENCAY"),
    });
  });

  test('getFavoris when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = ServiceCiviqueFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavoris("jeuneId");

    // Then
    expect(favoris, isNull);
  });
}

BaseClient _successfulClientForQuery() {
  return PassEmploiMockClient((request) async {
    if (request.method != "GET") return invalidHttpResponse();
    if (request.url.queryParameters["detail"] != "true") return invalidHttpResponse(message: "query KO");
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/services-civique")) {
      return invalidHttpResponse();
    }
    return Response.bytes(loadTestAssetsAsBytes("service_civique_favoris_data.json"), 200);
  });
}

BaseClient _failureClient() {
  return PassEmploiMockClient((request) async {
    return Response("", 500);
  });
}

BaseClient _notFoundClient() {
  return PassEmploiMockClient((request) async {
    return Response("", 404);
  });
}

BaseClient _alreadyExistsClient() {
  return PassEmploiMockClient((request) async {
    return Response("", 409);
  });
}

BaseClient _successfulClientForDelete() {
  return PassEmploiMockClient((request) async {
    if (request.method != "DELETE") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/services-civique/offreId")) {
      return invalidHttpResponse();
    }
    return Response("", 204);
  });
}

BaseClient _mockClientForFullData() {
  return PassEmploiMockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/services-civique")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["id"] != "GOAT") {
      return invalidHttpResponse(message: "idOffre KO");
    }
    if (requestJson["domaine"] != "Footballeur") return invalidHttpResponse(message: "metier KO");
    if (requestJson["titre"] != "Cristiano Ronaldo") return invalidHttpResponse(message: "nomEtablissement KO");
    if (requestJson["dateDeDebut"] != "as soon as possible") return invalidHttpResponse(message: "secteurActivite KO");
    if (requestJson["ville"] != "Manchester") return invalidHttpResponse(message: "ville KO");
    if (requestJson["organisation"] != "United") return invalidHttpResponse(message: "organisation KO");
    return Response("", 201);
  });
}

ServiceCivique _offreWithFullData() {
  return ServiceCivique(
    id: "GOAT",
    companyName: 'United',
    domain: 'Footballeur',
    title: 'Cristiano Ronaldo',
    location: "Manchester",
    startDate: "as soon as possible",
  );
}
