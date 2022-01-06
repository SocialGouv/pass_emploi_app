import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('search when response is valid with keywords and a department location should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters["q"] != "keywords") return invalidHttpResponse();
      if (request.url.queryParameters["departement"] != "75") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final location = Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT);
    final search = await repository.search(
      userId: "ID",
      keywords: "keywords",
      location: location,
      page: 1,
      filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
    );

    // Then
    expect(search!, isNotNull);
    expect(search.isMoreDataAvailable, false);
    expect(search.offres.length, 3);
    final offre = search.offres[0];
    expect(
        offre,
        OffreEmploi(
          id: "123YYCD",
          title: "Serveur / Serveuse de restaurant - chef de rang h/f   (H/F)",
          companyName: "BRASSERIE FLO",
          contractType: "CDI",
          location: "75 - PARIS 10",
          duration: "Temps plein",
        ));
  });

  test('search when response is valid with keywords and a commune location should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters["q"] != "keywords") return invalidHttpResponse();
      if (request.url.queryParameters["commune"] != "13202") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final location = Location(libelle: "Marseille 02", code: "13202", codePostal: "13002", type: LocationType.COMMUNE);
    final search = await repository.search(
      userId: "ID",
      keywords: "keywords",
      location: location,
      page: 1,
      filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
    );

    // Then
    expect(search!, isNotNull);
    expect(search.isMoreDataAvailable, false);
    expect(search.offres.length, 3);
    final offre = search.offres[0];
    expect(
        offre,
        OffreEmploi(
          id: "123YYCD",
          title: "Serveur / Serveuse de restaurant - chef de rang h/f   (H/F)",
          companyName: "BRASSERIE FLO",
          contractType: "CDI",
          location: "75 - PARIS 10",
          duration: "Temps plein",
        ));
  });

  test('search when response is valid with empty keyword and department parameters should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters.containsKey("q")) return invalidHttpResponse();
      if (request.url.queryParameters.containsKey("departement")) return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When

    final search = await repository.search(
      userId: "ID",
      keywords: "",
      location: null,
      page: 1,
      filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
    );

    // Then
    expect(search!, isNotNull);
    expect(search.isMoreDataAvailable, false);
    expect(search.offres.length, 3);
    final offre = search.offres[0];
    expect(
        offre,
        OffreEmploi(
          id: "123YYCD",
          title: "Serveur / Serveuse de restaurant - chef de rang h/f   (H/F)",
          companyName: "BRASSERIE FLO",
          contractType: "CDI",
          location: "75 - PARIS 10",
          duration: "Temps plein",
        ));
  });

  group("search when filtres are applied ...", () {
    void assertFiltres(
      String title,
      OffreEmploiSearchParametersFiltres filtres,
      bool Function(String query) assertion,
    ) {
      test('$title', () async {
        // Given
        final httpClient = MockClient((request) async {
          debugPrint(request.url.query);
          if (!assertion(request.url.query)) return invalidHttpResponse();
          return Response(loadTestAssets("offres_emploi.json"), 200);
        });
        final repository = OffreEmploiRepository("BASE_URL", httpClient, HeadersBuilderStub());

        // When
        final location =
            Location(libelle: "Issy-les-Moulineaux", code: "03129", codePostal: "92130", type: LocationType.COMMUNE);
        final search = await repository.search(
          userId: "ID",
          keywords: "keywords",
          location: location,
          page: 1,
          filtres: filtres,
        );

        // Then
        expect(search, isNotNull);
      });
    }

    group(("when distance is applied should set proper rayon"), () {
      assertFiltres(
        "when distance is 70",
        OffreEmploiSearchParametersFiltres.withFiltres(distance: 70),
        (query) => query.contains("rayon=70"),
      );

      assertFiltres(
        "when distance is 32",
        OffreEmploiSearchParametersFiltres.withFiltres(distance: 32),
        (query) => query.contains("rayon=32"),
      );

      assertFiltres(
        "when not filter is set should not set rayon",
        OffreEmploiSearchParametersFiltres.noFiltres(),
        (query) => !query.contains("rayon"),
      );
    });

    group(("when experience filtre is applied should set proper values"), () {
      assertFiltres(
        "when experience is De 0 à 1 an",
        OffreEmploiSearchParametersFiltres.withFiltres(experience: [ExperienceFiltre.de_zero_a_un_an]),
        (query) => query.contains("experience=1"),
      );

      assertFiltres(
        "when experience is De 1 an à 3 ans",
        OffreEmploiSearchParametersFiltres.withFiltres(experience: [ExperienceFiltre.de_un_a_trois_ans]),
        (query) => query.contains("experience=2"),
      );

      assertFiltres(
        "when experience is 3 ans et +",
        OffreEmploiSearchParametersFiltres.withFiltres(experience: [ExperienceFiltre.trois_ans_et_plus]),
        (query) => query.contains("experience=3"),
      );

      assertFiltres(
        "when experience is De 0 à 1 an and De 1 an à 3 ans",
        OffreEmploiSearchParametersFiltres.withFiltres(
            experience: [ExperienceFiltre.de_zero_a_un_an, ExperienceFiltre.de_un_a_trois_ans]),
        (query) => query.contains("experience=1") && query.contains("experience=2"),
      );

      assertFiltres(
        "when all three experience values are selected",
        OffreEmploiSearchParametersFiltres.withFiltres(experience: [
          ExperienceFiltre.de_zero_a_un_an,
          ExperienceFiltre.de_un_a_trois_ans,
          ExperienceFiltre.trois_ans_et_plus
        ]),
        (query) => query.contains("experience=1") && query.contains("experience=2") && query.contains("experience=3"),
      );

      assertFiltres(
        "when no experience is selected",
        OffreEmploiSearchParametersFiltres.withFiltres(experience: []),
        (query) => !query.contains("experience"),
      );
      assertFiltres(
        "when no experience is selected - null",
        OffreEmploiSearchParametersFiltres.noFiltres(),
        (query) => !query.contains("experience"),
      );
    });

    group(("when contrat filtre is applied should set proper values"), () {
      assertFiltres(
        "when cdi is selected",
        OffreEmploiSearchParametersFiltres.withFiltres(contrat: [ContratFiltre.cdi]),
        (query) => query.contains("contrat=CDI"),
      );

      assertFiltres(
        "when cdd is selected",
        OffreEmploiSearchParametersFiltres.withFiltres(contrat: [ContratFiltre.cdd_interim_saisonnier]),
        (query) => query.contains("contrat=CDD-interim-saisonnier"),
      );

      assertFiltres(
        "when autre is selected",
        OffreEmploiSearchParametersFiltres.withFiltres(contrat: [ContratFiltre.autre]),
        (query) => query.contains("contrat=autre"),
      );

      assertFiltres(
        "when cdi and autre are selected",
        OffreEmploiSearchParametersFiltres.withFiltres(contrat: [ContratFiltre.cdi, ContratFiltre.autre]),
        (query) => query.contains("contrat=CDI") && query.contains("contrat=autre"),
      );

      assertFiltres(
        "when all three options are selected",
        OffreEmploiSearchParametersFiltres.withFiltres(
          contrat: [ContratFiltre.cdi, ContratFiltre.cdd_interim_saisonnier, ContratFiltre.autre],
        ),
        (query) =>
            query.contains("contrat=CDI") &&
            query.contains("contrat=CDD-interim-saisonnier") &&
            query.contains("contrat=autre"),
      );

      assertFiltres(
        "when no contrat is selected",
        OffreEmploiSearchParametersFiltres.withFiltres(contrat: []),
        (query) => !query.contains("contrat"),
      );

      assertFiltres(
        "when no contrat is selected - null",
        OffreEmploiSearchParametersFiltres.noFiltres(),
        (query) => !query.contains("contrat"),
      );
    });

    group("when duree filtre is applied should set proper values", () {
      assertFiltres(
        "when duree is temps plein",
        OffreEmploiSearchParametersFiltres.withFiltres(duree: [DureeFiltre.temps_plein]),
        (query) => query.contains("duree=1"),
      );

      assertFiltres(
        "when duree is temps partiel",
        OffreEmploiSearchParametersFiltres.withFiltres(duree: [DureeFiltre.temps_partiel]),
            (query) => query.contains("duree=2"),
      );

      assertFiltres(
        "when duree is both",
        OffreEmploiSearchParametersFiltres.withFiltres(duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel]),
            (query) => query.contains("duree=1") && query.contains("duree=2"),
      );

      assertFiltres(
        "when no duree is selected",
        OffreEmploiSearchParametersFiltres.withFiltres(duree : []),
            (query) => !query.contains("duree"),
      );

      assertFiltres(
        "when no duree is selected - null",
        OffreEmploiSearchParametersFiltres.noFiltres(),
        (query) => !query.contains("duree"),
      );
    });
  });

  test('search when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = OffreEmploiRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final search = await repository.search(
      userId: "ID",
      keywords: "keywords",
      location: null,
      page: 1,
      filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
    );

    // Then
    expect(search, isNull);
  });
}
