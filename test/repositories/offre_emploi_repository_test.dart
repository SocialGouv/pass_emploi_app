import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
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

  test('search when response is valid with keywords and a commune location should return offres', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-emploi")) return invalidHttpResponse();
      if (request.url.queryParameters["q"] != "keywords") return invalidHttpResponse();
      if (request.url.queryParameters["commune"] != "03129") return invalidHttpResponse();
      if (request.url.queryParameters["page"] != "1") return invalidHttpResponse();
      if (request.url.queryParameters["limit"] != "50") return invalidHttpResponse();
      if (request.url.queryParameters["rayon"] != "70") return invalidHttpResponse();
      return Response(loadTestAssets("offres_emploi.json"), 200);
    });
    final repository = OffreEmploiRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final location = Location(libelle: "Issy-les-Moulineaux", code: "03129", codePostal: "92130", type: LocationType.COMMUNE);
    final search = await repository.search(
      userId: "ID",
      keywords: "keywords",
      location: location,
      page: 1,
      filtres: OffreEmploiSearchParametersFiltres.withFiltres(distance: 70),
    );

    // Then
    expect(search!, isNotNull);
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
