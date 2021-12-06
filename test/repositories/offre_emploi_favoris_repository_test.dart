import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

main() {
  test('getOffreEmploiFavorisId when response is valid with all parameters should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favoris")) return invalidHttpResponse();
      return Response.bytes(loadTestAssetsAsBytes("offre_emploi_favoris_id.json"), 200);
    });
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final favoris = await repository.getOffreEmploiFavorisId("jeuneId");

    // Then
    expect(favoris, ["124GQRG", "124FGRM", "124FGFB", "124FGJJ"]);
  });

  test('getOffreEmploiFavorisId when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final favoris = await repository.getOffreEmploiFavorisId("jeuneId");

    // Then
    expect(favoris, isNull);
  });

  test(
      "updateOffreEmploiFavoriStatus when adding favori should post correct data when most fields are null and return true when response is valid",
      () async {
    // Given
    final httpClient = _mockClientForPartialData();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithPartialData(),
      true,
    );

    // Then
    expect(result, isTrue);
  });

  test(
      "updateOffreEmploiFavoriStatus when adding favori should post correct data when all fields are not null and return true when response is valid",
      () async {
    // Given
    final httpClient = _mockClientForFullData();

    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithFullData(),
      true,
    );

    // Then
    expect(result, isTrue);
  });

  test(
      "updateOffreEmploiFavoriStatus when removing favori should delete with correct id and return true when response is valid",
      () async {
    // Given
    final httpClient = _successfulClientForDelete();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithPartialData(),
      false,
    );

    // Then
    expect(result, isTrue);
  });

  test("updateOffreEmploiFavoriStatus when removing favori should return true when response is a 404", () async {
    // Given
    final httpClient = _notFoundClient();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithPartialData(),
      false,
    );

    // Then
    expect(result, true);
  });

  test("updateOffreEmploiFavoriStatus when removing favori should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithPartialData(),
      false,
    );

    // Then
    expect(result, isFalse);
  });

  test("updateOffreEmploiFavoriStatus when adding favori should return false when response is invalid", () async {
    // Given
    final httpClient = _failureClient();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithPartialData(),
      true,
    );

    // Then
    expect(result, isFalse);
  });

  test("updateOffreEmploiFavoriStatus when adding favori should return true when response is 409", () async {
    // Given
    final httpClient = _alreadyExistsClient();
    final repository = OffreEmploiFavorisRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final result = await repository.updateOffreEmploiFavoriStatus(
      "jeuneId",
      _offreWithPartialData(),
      true,
    );

    // Then
    expect(result, isTrue);
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
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favori/offreId")) return invalidHttpResponse();
    return Response("", 204);
  });
}

MockClient _mockClientForFullData() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favori")) return invalidHttpResponse();
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["idOffre"] != "offreId2") return invalidHttpResponse(message: "idOffre KO");
    if (requestJson["duree"] != "duration") return invalidHttpResponse(message: "idOffre KO");
    if (requestJson["titre"] != "otherTitle") return invalidHttpResponse(message: "titre KO");
    if (requestJson["nomEntreprise"] != "companyName") return invalidHttpResponse(message: "titre KO");
    if (requestJson["typeContrat"] != "otherContractType") return invalidHttpResponse(message: "typeContrat KO");
    if (requestJson["localisation"]["nom"] != "Marseille") return invalidHttpResponse(message: "alternance KO");
    if (requestJson["alternance"] != false) return invalidHttpResponse(message: "alternance KO");
    return Response("", 201);
  });
}

MockClient _mockClientForPartialData() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/favori")) return invalidHttpResponse();
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["idOffre"] != "offreId") return invalidHttpResponse(message: "idOffre KO");
    if (requestJson["titre"] != "title") return invalidHttpResponse(message: "titre KO");
    if (requestJson["typeContrat"] != "contractType") return invalidHttpResponse(message: "typeContrat KO");
    if (requestJson["localisation"]["nom"] != "Paris") return invalidHttpResponse(message: "alternance KO");
    if (requestJson["alternance"] != false) return invalidHttpResponse(message: "alternance KO");
    return Response("", 201);
  });
}

OffreEmploi _offreWithPartialData() {
  return OffreEmploi(
    id: "offreId",
    duration: null,
    contractType: "contractType",
    companyName: null,
    location: "Paris",
    title: "title",
  );
}

OffreEmploi _offreWithFullData() {
  return OffreEmploi(
    id: "offreId2",
    duration: "duration",
    contractType: "otherContractType",
    companyName: "companyName",
    location: "Marseille",
    title: "otherTitle",
  );
}
