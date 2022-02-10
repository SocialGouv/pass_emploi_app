import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/saved_search/immersion_saved_search_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';

main() {
  group("When user save new search postSavedSearch should ...", () {
    test("successfully send request when all fields and filters are full and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters();
      final repository = ImmersionSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFilters(), "title");

      // Then
      expect(result, isTrue);
    });

    test(
        "successfully send request when all fields are full without filters and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforFulllDataWithoutFilters();
      final repository = ImmersionSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithoutFilters(), "title");

      // Then
      expect(result, isTrue);
    });

    test("return FALSE if response is invalid", () async {
      // Given
      final httpClient = _failureClient();
      final repository = ImmersionSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFilters(), "title");

      // Then
      expect(result, isFalse);
    });
  });
}

MockClient _failureClient() {
  return MockClient((request) async {
    return Response("", 500);
  });
}

MockClient _mockClientforFullDataWithFilters() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/immersions"))
      return invalidHttpResponse();
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

MockClient _mockClientforFulllDataWithoutFilters() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/immersions"))
      return invalidHttpResponse();
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["titre"] != "title") return invalidHttpResponse(message: "title KO");
    if (requestJson["metier"] != "plombier") return invalidHttpResponse(message: "metier KO");
    if (requestJson["localisation"] != "Paris") return invalidHttpResponse(message: "localisation KO");
    return Response("", 201);
  });
}

ImmersionSavedSearch _savedSearchWithoutFilters() {
  return ImmersionSavedSearch(
    title: "title",
    metier: "plombier",
    location: "Paris",
    filters: ImmersionSearchParametersFilters.withoutFilters(),
  );
}

ImmersionSavedSearch _savedSearchWithFilters() {
  return ImmersionSavedSearch(
    title: "title",
    metier: "plombier",
    location: "Paris",
    filters: ImmersionSearchParametersFilters.withFilters(
      codeRome: "F1104",
      lat: 48.830108,
      lon: 2.323026,
    ),
  );
}
