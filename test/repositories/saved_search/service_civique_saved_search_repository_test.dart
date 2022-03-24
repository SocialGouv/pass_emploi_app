import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/saved_search/service_civique_saved_search.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/saved_search/service_civique_saved_search_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';

void main() {
  group("When user save new search postSavedSearch should ...", () {
    test("successfully send request when all fields and filters are full and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters();
      final repository = ServiceCiviqueSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFiltres(), "ronaldo");

      // Then
      expect(result, isTrue);
    });

    test("return FALSE if response is invalid", () async {
      // Given
      final httpClient = MockClient((request) async => Response("", 500));
      final repository = ServiceCiviqueSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFiltres(), "ronaldo");

      // Then
      expect(result, isFalse);
    });
  });
}

MockClient _mockClientforFullDataWithFilters() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/services-civique")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["titre"] != "ronaldo") return invalidHttpResponse(message: "title KO");
    if (requestJson["localisation"] != "Paris") return invalidHttpResponse(message: "localisation KO");
    if (requestJson["criteres"]["domaine"] != "solidarite-insertion") return invalidHttpResponse(message: "metier KO");
    if (requestJson["criteres"]["distance"] != 30) return invalidHttpResponse(message: "code rome KO");
    if (requestJson["criteres"]["lat"] != 48.830108) return invalidHttpResponse(message: "latitude KO");
    if (requestJson["criteres"]["lon"] != 2.323026) return invalidHttpResponse(message: "longitude KO");
    return Response("", 201);
  });
}

ServiceCiviqueSavedSearch _savedSearchWithFiltres() {
  return ServiceCiviqueSavedSearch(
    id: "id",
    titre: "ronaldo",
    domaine: Domaine.values[2],
    ville: "Paris",
    location: mockLocation(lat: 48.830108, lon: 2.323026),
    filtres: ServiceCiviqueFiltresParameters.distance(30),
  );
}
