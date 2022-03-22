import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';

void main() {
  group("When user save new search postSavedSearch should ...", () {
    test(
        "successfully send request when all fields are null - except Title Field - and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforPartialDataWithoutFilters();
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithoutFilters(), "title");

      // Then
      expect(result, isTrue);
    });

    test("successfully send request when all fields are filled and return TRUE if response is valid (201)", () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters(expectedAlternance: false);
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFilters(isAlternance: false), "title");

      // Then
      expect(result, isTrue);
    });

    test("successfully send request when user search alternance and return TRUE if response is valid (201)", () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters(expectedAlternance: true);
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFilters(isAlternance: true), "title");

      // Then
      expect(result, isTrue);
    });

    test("return FALSE if response is invalid", () async {
      // Given
      final httpClient = _failureClient();
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithoutFilters(), "title");

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

MockClient _mockClientforFullDataWithFilters({required bool expectedAlternance}) {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/offres-emploi")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["titre"] != "title") return invalidHttpResponse(message: "title KO");
    if (requestJson["metier"] != "plombier") return invalidHttpResponse(message: "metier KO");
    if (requestJson["localisation"] != "Paris") return invalidHttpResponse(message: "localisation KO");
    if (requestJson["criteres"]["q"] != "secteur privé") return invalidHttpResponse(message: "keywords KO");
    if (requestJson["criteres"]["departement"] != "75") return invalidHttpResponse(message: "departement KO");
    if (requestJson["criteres"]["alternance"] != expectedAlternance) {
      return invalidHttpResponse(message: "alternance KO");
    }
    if (requestJson["criteres"]["rayon"] != 40) return invalidHttpResponse(message: "distance KO");
    if (requestJson["criteres"]["experience"][0] != "3") return invalidHttpResponse(message: "experience KO");
    if (requestJson["criteres"]["contrat"][0] != "CDI") return invalidHttpResponse(message: "contrat KO");
    if (requestJson["criteres"]["duree"][0] != "1") return invalidHttpResponse(message: "duree KO");
    return Response("", 201);
  });
}

MockClient _mockClientforPartialDataWithoutFilters() {
  return MockClient((request) async {
    if (request.method != "POST") return invalidHttpResponse();
    if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches/offres-emploi")) {
      return invalidHttpResponse();
    }
    final requestJson = jsonUtf8Decode(request.bodyBytes);
    if (requestJson["titre"] != "title") return invalidHttpResponse(message: "title KO");
    return Response("", 201);
  });
}

OffreEmploiSavedSearch _savedSearchWithoutFilters() {
  return OffreEmploiSavedSearch(
    id: "id",
    title: "title",
    metier: null,
    location: null,
    keywords: null,
    isAlternance: false,
    filters: OffreEmploiSearchParametersFiltres.noFiltres(),
  );
}

OffreEmploiSavedSearch _savedSearchWithFilters({required bool isAlternance}) {
  return OffreEmploiSavedSearch(
    id: "id",
    title: "title",
    metier: "plombier",
    location: Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT),
    keywords: "secteur privé",
    isAlternance: isAlternance,
    filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: 40,
        contrat: [ContratFiltre.cdi],
        experience: [ExperienceFiltre.trois_ans_et_plus, ExperienceFiltre.de_un_a_trois_ans],
        duree: [DureeFiltre.temps_plein]),
  );
}
