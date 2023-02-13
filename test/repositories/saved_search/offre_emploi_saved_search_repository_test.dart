import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/network/json_utf8_decoder.dart';
import 'package:pass_emploi_app/repositories/saved_search/offre_emploi_saved_search_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/pass_emploi_mock_client.dart';

void main() {
  group("When user save new search postSavedSearch should ...", () {
    test(
        "successfully send request when all fields are null - except Title Field - and return TRUE if response is valid (201)",
        () async {
      // Given
      final httpClient = _mockClientforPartialDataWithoutFilters();
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithoutFilters(), "title");

      // Then
      expect(result, isTrue);
    });

    test("successfully send request when all fields are filled and return TRUE if response is valid (201)", () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters(expectedAlternance: false);
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFilters(isAlternance: false), "title");

      // Then
      expect(result, isTrue);
    });

    test("successfully send request when user search alternance and return TRUE if response is valid (201)", () async {
      // Given
      final httpClient = _mockClientforFullDataWithFilters(expectedAlternance: true);
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithFilters(isAlternance: true), "title");

      // Then
      expect(result, isTrue);
    });

    test("return FALSE if response is invalid", () async {
      // Given
      final httpClient = _failureClient();
      final repository = OffreEmploiSavedSearchRepository("BASE_URL", httpClient, DummyPassEmploiCacheManager());

      // When
      final result = await repository.postSavedSearch("jeuneId", _savedSearchWithoutFilters(), "title");

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

BaseClient _mockClientforFullDataWithFilters({required bool expectedAlternance}) {
  return PassEmploiMockClient((request) async {
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
    if (requestJson["criteres"]["debutantAccepte"] != true) return invalidHttpResponse(message: "debutantAccepte KO");
    if (requestJson["criteres"]["experience"][0] != "3") return invalidHttpResponse(message: "experience KO");
    if (requestJson["criteres"]["contrat"][0] != "CDI") return invalidHttpResponse(message: "contrat KO");
    if (requestJson["criteres"]["duree"][0] != "1") return invalidHttpResponse(message: "duree KO");
    return Response("", 201);
  });
}

BaseClient _mockClientforPartialDataWithoutFilters() {
  return PassEmploiMockClient((request) async {
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
    keyword: null,
    onlyAlternance: false,
    filters: OffreEmploiSearchParametersFiltres.noFiltres(),
  );
}

OffreEmploiSavedSearch _savedSearchWithFilters({required bool isAlternance}) {
  return OffreEmploiSavedSearch(
    id: "id",
    title: "title",
    metier: "plombier",
    location: Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT),
    keyword: "secteur privé",
    onlyAlternance: isAlternance,
    filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: 40,
        contrat: [ContratFiltre.cdi],
        debutantOnly: true,
        experience: [ExperienceFiltre.trois_ans_et_plus, ExperienceFiltre.de_un_a_trois_ans],
        duree: [DureeFiltre.temps_plein]),
  );
}
