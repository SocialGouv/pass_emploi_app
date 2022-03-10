import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/repositories/immersion_repository.dart';

import '../doubles/fixtures.dart';
import '../doubles/stubs.dart';
import '../utils/test_assets.dart';

void main() {
  test('search when response is valid should return immersions', () async {
    // Given
    final httpClient = MockClient((request) async {
      if (request.method != "GET") return invalidHttpResponse();
      if (!request.url.toString().startsWith("BASE_URL/offres-immersion")) return invalidHttpResponse();
      if (request.url.queryParameters["rome"] != "J1301") return invalidHttpResponse();
      if (request.url.queryParameters["lat"] != "48.7") return invalidHttpResponse();
      if (request.url.queryParameters["lon"] != "7.7") return invalidHttpResponse();
      return Response(loadTestAssets("immersions.json"), 200);
    });
    final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersions = await repository.search(userId: "ID", request: _requestWithoutFiltres());

    // Then
    expect(immersions, isNotNull);
    expect(immersions!.length, 13);
    expect(
      immersions.first,
      Immersion(
        id: "036383f3-85ca-4dbd-b636-ae2657164439",
        metier: "xxxx",
        nomEtablissement: "ACCUEIL DE JOUR POUR PERSONNES AGEES",
        secteurActivite: "xxxx",
        ville: "xxxx",
      ),
    );
  });

  test('search when response is invalid should return null', () async {
    // Given
    final httpClient = MockClient((request) async => invalidHttpResponse());
    final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersions = await repository.search(userId: "ID", request: _requestWithoutFiltres());

    // Then
    expect(immersions, isNull);
  });

  test('search when response throws exception should return null', () async {
    // Given
    final httpClient = MockClient((request) async => throw Exception());
    final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

    // When
    final immersions = await repository.search(userId: "ID", request: _requestWithoutFiltres());

    // Then
    expect(immersions, isNull);
  });

  group("search when filtres are applied ...", () {
    void assertFiltres(
      String title,
      ImmersionSearchParametersFiltres filtres,
      bool Function(String query) assertion,
    ) {
      test(title, () async {
        // Given
        final httpClient = MockClient((request) async {
          if (!assertion(request.url.query)) return invalidHttpResponse();
          return Response(loadTestAssets("immersions.json"), 200);
        });
        final repository = ImmersionRepository("BASE_URL", httpClient, HeadersBuilderStub());

        // When
        final location =
            Location(libelle: "Issy-les-Moulineaux", code: "03129", codePostal: "92130", type: LocationType.COMMUNE);
        final search = await repository.search(
          userId: "ID",
          request: SearchImmersionRequest(
            location: location,
            filtres: filtres,
            codeRome: "J1301",
          ),
        );

        // Then
        expect(search, isNotNull);
      });
    }

    group(("when distance is applied should set proper distance"), () {
      assertFiltres(
        "when distance is 70",
        ImmersionSearchParametersFiltres.distance(70),
        (query) => query.contains("distance=70"),
      );

      assertFiltres(
        "when distance is 32",
        ImmersionSearchParametersFiltres.distance(32),
        (query) => query.contains("distance=32"),
      );

      assertFiltres(
        "when not filter is set should not set distance",
        ImmersionSearchParametersFiltres.noFiltres(),
        (query) => !query.contains("distance"),
      );
    });
  });
}

SearchImmersionRequest _requestWithoutFiltres() {
  return SearchImmersionRequest(
    codeRome: "J1301",
    location: Location(libelle: "Paris", code: "75", type: LocationType.COMMUNE, latitude: 48.7, longitude: 7.7),
    filtres: ImmersionSearchParametersFiltres.noFiltres(),
  );
}
