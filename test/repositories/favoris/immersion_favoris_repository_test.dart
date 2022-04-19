import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/favoris/immersion_favoris_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_assets.dart';

void main() {
  test('getFavorisId when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/offres-immersion")) {
        return invalidHttpResponse();
      }
      return Response.bytes(loadTestAssetsAsBytes("immersion_favoris_id.json"), 200);
    });
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

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
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

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

    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.postFavori("jeuneId", _offreWithFullData());

    // Then
    expect(result, isTrue);
  });

  test("deleteFavori when removing favori should delete with correct id and return true when response is valid",
      () async {
    // Given
        final httpClient = _successfulClientForDelete();
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.deleteFavori("jeuneId", "offreId");

    // Then
    expect(result, isTrue);
  });

  test("deleteFavori when removing favori should return true when response is a 404", () async {
    // Given
    final httpClient = _notFoundClient();
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.deleteFavori("jeuneId", "offreId");

    // Then
    expect(result, true);
  });

  test("deleteFavori when removing favori should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.deleteFavori("jeuneId", "offreId");

    // Then
    expect(result, isFalse);
  });

  test("postFavori when adding favori should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.postFavori("jeuneId", _offreWithFullData());

    // Then
    expect(result, isFalse);
  });

  test("postFavori when adding favori should return true when response is 409", () async {
    // Given
    final httpClient = _alreadyExistsClient();
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final result = await repository.postFavori("jeuneId", _offreWithFullData());

    // Then
    expect(result, isTrue);
  });

  test('getFavoris when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = _successfulClientForQuery();
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavoris("jeuneId");

    // Then
    expect(favoris, {
      "4f44d3ec-6568-41f0-b66e-e53a9e1fe904": Immersion(
        id: "4f44d3ec-6568-41f0-b66e-e53a9e1fe904",
        metier: "xxxx",
        nomEtablissement: "EPSAN",
        secteurActivite: "xxxx",
        ville: "xxxx",
      ),
      "4277d7b7-3d86-453d-9375-14aee8fde94d": Immersion(
        id: "4277d7b7-3d86-453d-9375-14aee8fde94d",
        metier: "xxxx",
        nomEtablissement: "LES FOURMIS DE L AJPA",
        secteurActivite: "xxxx",
        ville: "xxxx",
      ),
      "b2d70bb3-ba69-4dd8-880a-62171b48ecbc": Immersion(
        id: "b2d70bb3-ba69-4dd8-880a-62171b48ecbc",
        metier: "xxxx",
        nomEtablissement: "CENTRE SERVICES",
        secteurActivite: "xxxx",
        ville: "xxxx",
      ),
    });
  });

  test('getFavoris when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ImmersionFavorisRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

    // When
    final favoris = await repository.getFavoris("jeuneId");

    // Then
    expect(favoris, isNull);
  });
}

MockClient _successfulClientForQuery() {
  return MockClient((request) async {
    if (request.method != "GET") return invalidHttpResponse();
    if (request.url.queryParameters["detail"] != "true") return invalidHttpResponse(message: "query KO");
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/offres-immersion")) {
      return invalidHttpResponse();
    }
    return Response.bytes(loadTestAssetsAsBytes("immersion_favoris_data.json"), 200);
  });
}

MockClient _failureClient() {
  return MockClient((request) async {
    return Response("", 500);
  });
}

MockClient _notFoundClient() {
  return MockClient((request) async {
    return Response("", 404);
  });
}

MockClient _alreadyExistsClient() {
  return MockClient((request) async {
    return Response("", 409);
  });
}

MockClient _successfulClientForDelete() {
  return MockClient((request) async {
    if (request.method != "DELETE") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/offres-immersion/offreId")) {
      return invalidHttpResponse();
    }
    return Response("", 204);
  });
}

MockClient _mockClientForFullData() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris/offres-immersion")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["idOffre"] != "98286f66-2a8e-4a22-80a8-c6fda3a52980") {
      return invalidHttpResponse(message: "idOffre KO");
    }
    if (requestJson["metier"] != "Boulanger") return invalidHttpResponse(message: "metier KO");
    if (requestJson["nomEtablissement"] != "EPSAN Brumath") return invalidHttpResponse(message: "nomEtablissement KO");
    if (requestJson["secteurActivite"] != "Boulangerie") return invalidHttpResponse(message: "secteurActivite KO");
    if (requestJson["ville"] != "Brumath") return invalidHttpResponse(message: "ville KO");
    return Response("", 201);
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
