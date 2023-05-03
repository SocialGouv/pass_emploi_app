import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_criteres_recherche.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/recherche/recherche_request.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../doubles/fixtures.dart';
import '../utils/pass_emploi_mock_client.dart';
import '../utils/test_assets.dart';

void main() {
  test('response when response is valid with keyword and a department location should return offres', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters["q"] != "keyword") return invalidHttpResponse();
      if (request.url.queryParameters["departement"] != "75") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient);

    // When
    final location = Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT);
    final response = await repository.rechercher(
      userId: "ID",
      request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
        EmploiCriteresRecherche(
          keyword: "keyword",
          location: location,
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
        EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );

    // Then
    expect(response!, isNotNull);
    expect(response.canLoadMore, false);
    expect(response.results.length, 4);
    final offre = response.results.first;
    expect(
      offre,
      OffreEmploi(
        id: "123YYCD",
        title: "Serveur / Serveuse de restaurant - chef de rang h/f   (H/F)",
        companyName: "BRASSERIE FLO",
        contractType: "CDI",
        isAlternance: false,
        location: "75 - PARIS 10",
        duration: "Temps plein",
      ),
    );
    final offreWithoutLocation = response.results[3];
    expect(
        offreWithoutLocation,
        OffreEmploi(
          id: "123ZZZN1",
          duration: "Temps plein",
          location: null,
          contractType: "CDI",
          companyName: "SUPER TAXI",
          title: "Chauffeur / Chauffeuse de taxi (H/F)",
          isAlternance: false,
        ));
  });

  test('response when response is valid with keyword and a commune location should return offres', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters["q"] != "keyword") return invalidHttpResponse();
      if (request.url.queryParameters["commune"] != "13202") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient);

    // When
    final location = Location(libelle: "Marseille 02", code: "13202", codePostal: "13002", type: LocationType.COMMUNE);
    final response = await repository.rechercher(
      userId: "ID",
      request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
        EmploiCriteresRecherche(
          keyword: "keyword",
          location: location,
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
        EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );

    // Then
    expect(response, isNotNull);
  });

  test('response when response is valid with empty keyword and department parameters should return offres', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters.containsKey("q")) return invalidHttpResponse();
      if (request.url.queryParameters.containsKey("departement")) return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient);

    // When
    final response = await repository.rechercher(
      userId: "ID",
      request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
        EmploiCriteresRecherche(
          keyword: "",
          location: null,
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
        EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );

    // Then
    expect(response, isNotNull);
  });

  test('response when response is valid with only alternance should return offres', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters.containsKey("q")) return invalidHttpResponse();
      if (request.url.queryParameters.containsKey("departement")) return invalidHttpResponse();
      if (request.url.queryParameters["alternance"] != "true") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient);

    // When
    final response = await repository.rechercher(
      userId: "ID",
      request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
        EmploiCriteresRecherche(
          keyword: "",
          location: null,
          rechercheType: RechercheType.onlyAlternance,
        ),
        EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );

    // Then
    expect(response, isNotNull);
  });

  test('response when response is valid with keyword and a department location should return offres', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters["q"] != "keyword") return invalidHttpResponse();
      if (request.url.queryParameters["departement"] != "75") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient);

    // When
    final location = Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT);
    final response = await repository.rechercher(
      userId: "ID",
      request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
        EmploiCriteresRecherche(
          keyword: "keyword",
          location: location,
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
        EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );

    // Then
    expect(response!, isNotNull);
    expect(response.canLoadMore, false);
    expect(response.results.length, 4);
    final offre = response.results.first;
    expect(
        offre,
        OffreEmploi(
          id: "123YYCD",
          title: "Serveur / Serveuse de restaurant - chef de rang h/f   (H/F)",
          companyName: "BRASSERIE FLO",
          contractType: "CDI",
          location: "75 - PARIS 10",
          duration: "Temps plein",
          isAlternance: false,
        ));
  });

  group("When RechercheType…", () {
    test('is offreEmploiAndAlternance should not set alternance query param', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.url.queryParameters.containsKey("alternance")) return invalidHttpResponse();
        return Response(loadTestAssets("offres_emploi.json"), 200);
      });
      final repository = OffreEmploiRepository("BASE_URL", httpClient);

      // When
      final response = await repository.rechercher(
        userId: "ID",
        request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
          EmploiCriteresRecherche(
            keyword: "keyword",
            location: mockLocation(),
            rechercheType: RechercheType.offreEmploiAndAlternance,
          ),
          EmploiFiltresRecherche.noFiltre(),
          1,
        ),
      );

      // Then
      expect(response, isNotNull);
    });

    test('is onlyAlternance should set alternance query param to true', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.url.queryParameters["alternance"] != "true") return invalidHttpResponse();
        return Response(loadTestAssets("offres_emploi.json"), 200);
      });
      final repository = OffreEmploiRepository("BASE_URL", httpClient);

      // When
      final response = await repository.rechercher(
        userId: "ID",
        request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
          EmploiCriteresRecherche(
            keyword: "keyword",
            location: mockLocation(),
            rechercheType: RechercheType.onlyAlternance,
          ),
          EmploiFiltresRecherche.noFiltre(),
          1,
        ),
      );

      // Then
      expect(response, isNotNull);
    });

    test('is onlyOffreEmploi should set alternance query param to false', () async {
      // Given
      final httpClient = PassEmploiMockClient((request) async {
        if (request.url.queryParameters["alternance"] != "false") return invalidHttpResponse();
        return Response(loadTestAssets("offres_emploi.json"), 200);
      });
      final repository = OffreEmploiRepository("BASE_URL", httpClient);

      // When
      final response = await repository.rechercher(
        userId: "ID",
        request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
          EmploiCriteresRecherche(
            keyword: "keyword",
            location: mockLocation(),
            rechercheType: RechercheType.onlyOffreEmploi,
          ),
          EmploiFiltresRecherche.noFiltre(),
          1,
        ),
      );

      // Then
      expect(response, isNotNull);
    });
  });

  group("response when filtres are applied ...", () {
    void assertFiltres(
      String title,
      EmploiFiltresRecherche filtres,
      bool Function(String query) assertion,
    ) {
      test(title, () async {
        // Given
        final httpClient = PassEmploiMockClient((request) async {
          if (!assertion(request.url.query)) return invalidHttpResponse();
          return Response(loadTestAssets("offres_emploi.json"), 200);
        });
        final repository = OffreEmploiRepository("BASE_URL", httpClient);

        // When
        final location = Location(libelle: "Issy", code: "03129", codePostal: "92130", type: LocationType.COMMUNE);
        final response = await repository.rechercher(
          userId: "ID",
          request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
            EmploiCriteresRecherche(
              keyword: "keyword",
              location: location,
              rechercheType: RechercheType.offreEmploiAndAlternance,
            ),
            filtres,
            1,
          ),
        );

        // Then
        expect(response, isNotNull);
      });
    }

    group(("when distance is applied should set proper rayon"), () {
      assertFiltres(
        "when distance is 70",
        EmploiFiltresRecherche.withFiltres(distance: 70),
        (query) => query.contains("rayon=70"),
      );

      assertFiltres(
        "when distance is 32",
        EmploiFiltresRecherche.withFiltres(distance: 32),
        (query) => query.contains("rayon=32"),
      );

      assertFiltres(
        "when not filter is set should not set rayon",
        EmploiFiltresRecherche.noFiltre(),
        (query) => !query.contains("rayon"),
      );
    });

    group(("when debutantAccepte is applied should set parameter"), () {
      assertFiltres(
        "when debutantAccepte is true",
        EmploiFiltresRecherche.withFiltres(debutantOnly: true),
        (query) => query.contains("debutantAccepte=true"),
      );

      assertFiltres(
        "when debutantAccepte is false",
        EmploiFiltresRecherche.withFiltres(debutantOnly: false),
        (query) => query.contains("debutantAccepte=false"),
      );

      assertFiltres(
        "when no filter is set should not set debutantAccepte",
        EmploiFiltresRecherche.noFiltre(),
        (query) => !query.contains("debutantAccepte"),
      );
    });

    group(
        ("MANDATORY FOR RETRO-COMPATIBILITY IN SAVED SEARCHES : when experience filtre is applied should set proper values"),
        () {
      assertFiltres(
        "when experience is De 0 à 1 an",
        EmploiFiltresRecherche.withFiltres(experience: [ExperienceFiltre.de_zero_a_un_an]),
        (query) => query.contains("experience=1"),
      );

      assertFiltres(
        "when experience is De 1 an à 3 ans",
        EmploiFiltresRecherche.withFiltres(experience: [ExperienceFiltre.de_un_a_trois_ans]),
        (query) => query.contains("experience=2"),
      );

      assertFiltres(
        "when experience is 3 ans et +",
        EmploiFiltresRecherche.withFiltres(experience: [ExperienceFiltre.trois_ans_et_plus]),
        (query) => query.contains("experience=3"),
      );

      assertFiltres(
        "when experience is De 0 à 1 an and De 1 an à 3 ans",
        EmploiFiltresRecherche.withFiltres(
            experience: [ExperienceFiltre.de_zero_a_un_an, ExperienceFiltre.de_un_a_trois_ans]),
        (query) => query.contains("experience=1") && query.contains("experience=2"),
      );

      assertFiltres(
        "when all three experience values are selected",
        EmploiFiltresRecherche.withFiltres(experience: [
          ExperienceFiltre.de_zero_a_un_an,
          ExperienceFiltre.de_un_a_trois_ans,
          ExperienceFiltre.trois_ans_et_plus
        ]),
        (query) => query.contains("experience=1") && query.contains("experience=2") && query.contains("experience=3"),
      );

      assertFiltres(
        "when no experience is selected",
        EmploiFiltresRecherche.withFiltres(experience: []),
        (query) => !query.contains("experience"),
      );
      assertFiltres(
        "when no experience is selected - null",
        EmploiFiltresRecherche.noFiltre(),
        (query) => !query.contains("experience"),
      );
    });

    group(("when contrat filtre is applied should set proper values"), () {
      assertFiltres(
        "when cdi is selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdi]),
        (query) => query.contains("contrat=CDI"),
      );

      assertFiltres(
        "when cdd is selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdd_interim_saisonnier]),
        (query) => query.contains("contrat=CDD-interim-saisonnier"),
      );

      assertFiltres(
        "when autre is selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.autre]),
        (query) => query.contains("contrat=autre"),
      );

      assertFiltres(
        "when cdi and autre are selected",
        EmploiFiltresRecherche.withFiltres(contrat: [ContratFiltre.cdi, ContratFiltre.autre]),
        (query) => query.contains("contrat=CDI") && query.contains("contrat=autre"),
      );

      assertFiltres(
        "when all three options are selected",
        EmploiFiltresRecherche.withFiltres(
          contrat: [ContratFiltre.cdi, ContratFiltre.cdd_interim_saisonnier, ContratFiltre.autre],
        ),
        (query) =>
            query.contains("contrat=CDI") &&
            query.contains("contrat=CDD-interim-saisonnier") &&
            query.contains("contrat=autre"),
      );

      assertFiltres(
        "when no contrat is selected",
        EmploiFiltresRecherche.withFiltres(contrat: []),
        (query) => !query.contains("contrat"),
      );

      assertFiltres(
        "when no contrat is selected - null",
        EmploiFiltresRecherche.noFiltre(),
        (query) => !query.contains("contrat"),
      );
    });

    group("when duree filtre is applied should set proper values", () {
      assertFiltres(
        "when duree is temps plein",
        EmploiFiltresRecherche.withFiltres(duree: [DureeFiltre.temps_plein]),
        (query) => query.contains("duree=1"),
      );

      assertFiltres(
        "when duree is temps partiel",
        EmploiFiltresRecherche.withFiltres(duree: [DureeFiltre.temps_partiel]),
        (query) => query.contains("duree=2"),
      );

      assertFiltres(
        "when duree is both",
        EmploiFiltresRecherche.withFiltres(duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel]),
        (query) => query.contains("duree=1") && query.contains("duree=2"),
      );

      assertFiltres(
        "when no duree is selected",
        EmploiFiltresRecherche.withFiltres(duree: []),
        (query) => !query.contains("duree"),
      );

      assertFiltres(
        "when no duree is selected - null",
        EmploiFiltresRecherche.noFiltre(),
        (query) => !query.contains("duree"),
      );
    });
  });

  test('response when response is invalid should return null', () async {
    // Given
    final httpClient = PassEmploiMockClient((request) async => invalidHttpResponse());
    final repository = OffreEmploiRepository("BASE_URL", httpClient);

    // When
    final response = await repository.rechercher(
      userId: "ID",
      request: RechercheRequest<EmploiCriteresRecherche, EmploiFiltresRecherche>(
        EmploiCriteresRecherche(
          keyword: "keyword",
          location: null,
          rechercheType: RechercheType.offreEmploiAndAlternance,
        ),
        EmploiFiltresRecherche.noFiltre(),
        1,
      ),
    );

    // Then
    expect(response, isNull);
  });
}
