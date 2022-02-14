import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_assets.dart';

main() {
  group("When user want to get a saved search list, getSavedSearch should ...", () {
    test('return saved search offers when response is valid with all parameters', () async {
      // Given
      final httpClient = MockClient((request) async {
        if (request.method != "GET") return invalidHttpResponse();
        if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches")) return invalidHttpResponse();
        return Response.bytes(loadTestAssetsAsBytes("saved_search_data.json"), 200);
      });
      final repository = GetSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub(), DummyCrashlytics());

      // When
      final savedSearch = await repository.getSavedSearch("jeuneId");
      // Then
      expect(savedSearch, _getMockedSavedSearch());
    });

    test('return null when response is invalid should return null', () async {
      // Given
      final httpClient = MockClient((request) async => invalidHttpResponse());
      final repository = GetSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub(), DummyCrashlytics());

      // When
      final savedSearch = await repository.getSavedSearch("jeuneId");

      // Then
      expect(savedSearch, isNull);
    });
  });
}

List<Equatable> _getMockedSavedSearch() {
  return [
    OffreEmploiSavedSearch(
      title: "Boulangerie",
      metier: "Boulangerie",
      location: null,
      keywords: "Boulangerie",
      isAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiSavedSearch(
      title: "Boulangerie - NANTES",
      metier: "Boulangerie",
      location: Location(libelle: "NANTES", code: "44109", type: LocationType.COMMUNE),
      keywords: "Boulangerie",
      isAlternance: false,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    OffreEmploiSavedSearch(
      title: "Flutter",
      metier: "Flutter",
      location: null,
      keywords: "Flutter",
      isAlternance: true,
      filters: OffreEmploiSearchParametersFiltres.withFiltres(
        distance: null,
        experience: [],
        contrat: [],
        duree: [],
      ),
    ),
    ImmersionSavedSearch(
      title: "Boulangerie - viennoiserie - PARIS-14",
      metier: "Boulangerie - viennoiserie",
      location: "PARIS-14",
      filters: ImmersionSearchParametersFilters.withFilters(
        codeRome: "D1102",
        lat: 48.830108,
        lon: 2.323026,
      ),
    ),
  ];
}