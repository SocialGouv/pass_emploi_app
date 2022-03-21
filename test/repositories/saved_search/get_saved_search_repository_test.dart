import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/repositories/saved_search/get_saved_searchs_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_assets.dart';

void main() {
  group("When user want to get a saved search list, getSavedSearch should ...", () {
    test('return saved search offers when response is valid with all parameters', () async {
      // Given
      final httpClient = MockClient((request) async {
        if (request.method != "GET") return invalidHttpResponse();
        if (!request.url.toString().startsWith("BASE_URL/jeunes/jeuneId/recherches")) return invalidHttpResponse();
        return Response.bytes(loadTestAssetsAsBytes("saved_search_data.json"), 200);
      });
      final repository = GetSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

      // When
      final savedSearch = await repository.getSavedSearch("jeuneId");

      // Then
      expect(savedSearch, _getMockedSavedSearch());
    });

    test('return null when response is invalid should return null', () async {
      // Given
      final httpClient = MockClient((request) async => invalidHttpResponse());
      final repository = GetSavedSearchRepository("BASE_URL", httpClient, HeadersBuilderStub());

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
      id: "9ea85cc4-c92f-4f91-b5a3-b600f364faf1",
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
      id: "25f317c7-f28a-4f50-a629-013bb960484d",
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
      id: "6b51e128-000b-4125-a09a-c38a32a8b886",
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
      id: "670c413e-b669-4228-850a-9a7307fe79ea",
      title: "Boulangerie - viennoiserie - PARIS-14",
      metier: "Boulangerie - viennoiserie",
      ville: "PARIS-14",
      codeRome: "D1102",
      location: Location(
        libelle: "PARIS-14",
        code: "",
        codePostal: null,
        latitude: 48.830108,
        longitude: 2.323026,
        type: LocationType.COMMUNE,
      ),
      filtres: ImmersionSearchParametersFiltres.noFiltres(),
    ),
  ];
}
