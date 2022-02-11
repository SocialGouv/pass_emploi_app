import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search_extractors.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

main() {
  test("tests offre emploi search extractor", () {
    // Given
    final testStoreFactory = TestStoreFactory();
    var filtres = OffreEmploiSearchParametersFiltres.withFiltres(
      distance: 12,
      experience: [ExperienceFiltre.de_un_a_trois_ans],
      duree: [DureeFiltre.temps_partiel],
      contrat: [ContratFiltre.cdd_interim_saisonnier],
    );
    OffreEmploiSearchParametersState searchParametersState = OffreEmploiSearchParametersState.initialized(
        keywords: "Je suis un keyword", location: mockLocation(), onlyAlternance: false, filtres: filtres);
    AppState state = AppState.initialState().copyWith(
      offreEmploiSearchParametersState: searchParametersState,
    );
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    // When
    final result = OffreEmploiSearchExtractor().getSearchFilters(store);

    // Then
    final expected = OffreEmploiSavedSearch(
      title: "Je suis un keyword",
      metier: "Je suis un keyword",
      location: mockLocation(),
      keywords: "Je suis un keyword",
      isAlternance: false,
      filters: filtres,
    );
    expect(result, expected);
  });

  test("tests immersion search extractor", () {
    // Given
    final testStoreFactory = TestStoreFactory();
    final immersionState = State.success([
      Immersion(
        id: "id",
        metier: "metier",
        nomEtablissement: "nomEtablissement",
        secteurActivite: "secteurActivite",
        ville: "ville",
      )
    ]);
    AppState state = AppState.initialState().copyWith(
        immersionSearchState: immersionState,
        immersionSearchRequestState: RequestedImmersionSearchRequestState(
          codeRome: "codeRome",
          latitude: 12,
          longitude: 34,
        ));
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    // When
    final result = ImmersionSearchExtractor().getSearchFilters(store);

    // Then
    final expected = ImmersionSavedSearch(
      title: "metier - ville",
      metier: "metier",
      location: "ville",
      filters: ImmersionSearchParametersFilters.withFilters(
        codeRome: "codeRome",
        lat: 12,
        lon: 34,
      ),
    );
    expect(result, expected);
  });
}
