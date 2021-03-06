import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/parameters/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/models/saved_search/immersion_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/offre_emploi_saved_search.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search_extractors.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../doubles/fixtures.dart';
import '../utils/test_setup.dart';

void main() {
  test("tests offre emploi search extractor", () {
    // Given
    final testStoreFactory = TestStoreFactory();
    final filtres = OffreEmploiSearchParametersFiltres.withFiltres(
      distance: 12,
      experience: [ExperienceFiltre.de_un_a_trois_ans],
      duree: [DureeFiltre.temps_partiel],
      contrat: [ContratFiltre.cdd_interim_saisonnier],
    );
    final OffreEmploiSearchParametersState searchParametersState = OffreEmploiSearchParametersState.initialized(
        keywords: "Je suis un keyword", location: mockLocation(), onlyAlternance: false, filtres: filtres);
    final AppState state = AppState.initialState().copyWith(
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
    final immersionState = ImmersionListSuccessState([
      Immersion(
        id: "id",
        metier: "metier",
        nomEtablissement: "nomEtablissement",
        secteurActivite: "secteurActivite",
        ville: "ville",
      )
    ]);
    final searchedMetier = Metier.values.first;
    final AppState state = AppState.initialState().copyWith(
      searchMetierState: SearchMetierState([searchedMetier]),
      immersionListState: immersionState,
      immersionSearchParametersState: ImmersionSearchParametersInitializedState(
        codeRome: searchedMetier.codeRome,
        location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
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
        codeRome: searchedMetier.codeRome,
        location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
        ville: "ville",
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
      ),
    );
  });

  test("tests immersion search extractor when immersion result is empty", () {
    // Given
    final testStoreFactory = TestStoreFactory();
    final immersionState = ImmersionListSuccessState(<Immersion>[
      Immersion(
          id: "id",
          metier: "metier",
          nomEtablissement: "nomEtablissement",
          secteurActivite: "secteurActivite",
          ville: "ville"),
    ]);
    final searchedMetier = Metier.values.first;
    final AppState state = AppState.initialState().copyWith(
      searchMetierState: SearchMetierState([searchedMetier]),
      immersionListState: immersionState,
      immersionSearchParametersState: ImmersionSearchParametersInitializedState(
        codeRome: searchedMetier.codeRome,
        location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
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
        ville: "ville",
        codeRome: searchedMetier.codeRome,
        location: mockCommuneLocation(label: "ville", lat: 12, lon: 34),
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
      ),
    );
  });
}
