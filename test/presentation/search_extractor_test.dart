import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search_extractors.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/immersion_search_request_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/search_metier_state.dart';
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
      id: "",
      title: "Je suis un keyword",
      metier: "Je suis un keyword",
      location: mockLocation(),
      keywords: "Je suis un keyword",
      isAlternance: false,
      filters: filtres,
    );
    expect(result, expected);
  });

  test("tests immersion search extractor when immersion result is not empty", () {
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
    final searchedMetier = Metier.values.first;
    AppState state = AppState.initialState().copyWith(
      searchMetierState: SearchMetierState([searchedMetier]),
      immersionSearchState: immersionState,
      immersionSearchRequestState: RequestedImmersionSearchRequestState(
        codeRome: searchedMetier.codeRome,
        latitude: 12,
        longitude: 34,
        ville: "ville",
      ),
    );
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    // When
    final result = ImmersionSearchExtractor().getSearchFilters(store);

    // Then
    expect(
      result,
      ImmersionSavedSearch(
        id: "",
        title: "Conduite d'engins agricoles et forestiers - ville",
        metier: "Conduite d'engins agricoles et forestiers",
        location: "ville",
        filters: ImmersionSearchParametersFilters.withFilters(
          codeRome: searchedMetier.codeRome,
          lat: 12,
          lon: 34,
        ),
      ),
    );
  });

  test("tests immersion search extractor when immersion result is empty", () {
    // Given
    final testStoreFactory = TestStoreFactory();
    final immersionState = State.success(<Immersion>[
      Immersion(
          id: "id",
          metier: "metier",
          nomEtablissement: "nomEtablissement",
          secteurActivite: "secteurActivite",
          ville: "ville"),
    ]);
    final searchedMetier = Metier.values.first;
    AppState state = AppState.initialState().copyWith(
      searchMetierState: SearchMetierState([searchedMetier]),
      immersionSearchState: immersionState,
      immersionSearchRequestState: RequestedImmersionSearchRequestState(
        codeRome: searchedMetier.codeRome,
        latitude: 12,
        longitude: 34,
        ville: "ville",
      ),
    );
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    // When
    final result = ImmersionSearchExtractor().getSearchFilters(store);

    // Then
    expect(
      result,
      ImmersionSavedSearch(
        id: "",
        title: "${searchedMetier.libelle} - ville",
        metier: searchedMetier.libelle,
        location: "ville",
        filters: ImmersionSearchParametersFilters.withFilters(
          codeRome: searchedMetier.codeRome,
          lat: 12,
          lon: 34,
        ),
      ),
    );
  });
}
