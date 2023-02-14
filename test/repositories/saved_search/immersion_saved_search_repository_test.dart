import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';

void main() {
  group("When user save new search postSavedSearch should ...", () {
    test("successfully send request when all fields and filters are full and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters();
      final repository = ImmersionSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFiltres(), "title");

      // Then
      expect(result, isTrue);
    });

    test(
        "successfully send request when all fields are full without filters and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforFulllDataWithoutFilters();
      final repository = ImmersionSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithoutFiltres(), "title");

      // Then
      expect(result, isTrue);
    });

    test("return FALSE if response is invalid", () async {
      // Given
      final httpClient = _failureClient();
      final repository = ImmersionSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFiltres(), "title");

      // Then
      expect(result, isFalse);
    });
  });
}

BaseClient _failureClient() {
  return PassEmploiMockClient((request) async {
    return Response("", 500);
  });
}

BaseClient _mockClientforFullDataWithFilters() {
  return PassEmploiMockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/immersions")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["titre"] != "title") return invalidHttpResponse(message: "title KO");
    if (requestJson["metier"] != "plombier") return invalidHttpResponse(message: "metier KO");
    if (requestJson["localisation"] != "Paris") return invalidHttpResponse(message: "localisation KO");
    if (requestJson["criteres"]["rome"] != "F1104") return invalidHttpResponse(message: "code rome KO");
    if (requestJson["criteres"]["lat"] != 48.830108) return invalidHttpResponse(message: "latitude KO");
    if (requestJson["criteres"]["lon"] != 2.323026) return invalidHttpResponse(message: "longitude KO");
    return Response("", 201);
  });
}

BaseClient _mockClientforFulllDataWithoutFilters() {
  return PassEmploiMockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/immersions")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["titre"] != "title") return invalidHttpResponse(message: "title KO");
    if (requestJson["metier"] != "plombier") return invalidHttpResponse(message: "metier KO");
    if (requestJson["localisation"] != "Paris") return invalidHttpResponse(message: "localisation KO");
    return Response("", 201);
  });
}

ImmersionSavedSearch _savedSearchWithoutFiltres() {
  return ImmersionSavedSearch(
    id: "id",
    title: "title",
    metier: "plombier",
    ville: "Paris",
    codeRome: "F1104",
    location: mockLocation(lat: 48.830108, lon: 2.323026),
    filtres: ImmersionFiltresRecherche.noFiltre(),
  );
}

ImmersionSavedSearch _savedSearchWithFiltres() {
  return ImmersionSavedSearch(
    id: "id",
    title: "title",
    metier: "plombier",
    ville: "Paris",
    codeRome: "F1104",
    location: mockLocation(lat: 48.830108, lon: 2.323026),
    filtres: ImmersionFiltresRecherche.distance(30),
  );
}
