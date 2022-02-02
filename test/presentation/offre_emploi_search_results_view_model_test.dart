import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_parameters_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_results_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_search_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  group("create when state is success should convert data to view model", () {
    Store<AppState> _successSetUp({required bool moreData}) {
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          offreEmploiSearchState: OffreEmploiSearchState.success(),
          offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
              offres: [mockOffreEmploi()], loadedPage: 1, isMoreDataAvailable: moreData),
        ),
      );
      return store;
    }

    test("and more data is available", () {
      // Given
      final store = _successSetUp(moreData: true);

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [mockOffreEmploiItemViewModel()]);
      expect(viewModel.displayLoaderAtBottomOfList, true);
    });

    test("and no more data available", () {
      // Given
      final store = _successSetUp(moreData: false);

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
      expect(viewModel.items, [mockOffreEmploiItemViewModel()]);
      expect(viewModel.displayLoaderAtBottomOfList, false);
    });
  });

  test("create when state is loading should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.loading(),
        offreEmploiSearchResultsState:
            OffreEmploiSearchResultsState.data(offres: [mockOffreEmploi()], loadedPage: 2, isMoreDataAvailable: false),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.items, [mockOffreEmploiItemViewModel()]);
  });

  test("create when state is failure should convert data to view model", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
        offreEmploiSearchResultsState: OffreEmploiSearchResultsState.data(
          offres: [mockOffreEmploi()],
          loadedPage: 3,
          isMoreDataAvailable: false,
        ),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.items, [mockOffreEmploiItemViewModel()]);
  });

  group("create should properly set filtre number ...", () {
    test("when state has no active filtre it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(OffreEmploiSearchParametersFiltres.noFiltres());

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active distance filtre it should display 1 as filtre number", () {
      // Given
      final store = _storeWithFiltres(OffreEmploiSearchParametersFiltres.withFiltres(distance: 40));

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test("when state has active distance filtre but value is default it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(OffreEmploiSearchParametersFiltres.withFiltres(distance: 10));

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active experience filtre it should display 1 as filtre number", () {
      // Given
      final store = _storeWithFiltres(
        OffreEmploiSearchParametersFiltres.withFiltres(experience: [ExperienceFiltre.trois_ans_et_plus]),
      );

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test("when state has 2 active experience filtres it should display 2 as filtre number", () {
      // Given
      final store = _storeWithFiltres(
        OffreEmploiSearchParametersFiltres.withFiltres(
          experience: [ExperienceFiltre.de_un_a_trois_ans, ExperienceFiltre.trois_ans_et_plus],
        ),
      );

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 2);
    });

    test("when state has empty experience filtre it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(
        OffreEmploiSearchParametersFiltres.withFiltres(experience: []),
      );

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active contrat filtre it should display 1 as filtre number", () {
      // Given
      final store = _storeWithFiltres(OffreEmploiSearchParametersFiltres.withFiltres(contrat: [ContratFiltre.autre]));

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test("when state has 3 active contrat filtres it should display 3 as filtre number", () {
      // Given
      final store = _storeWithFiltres(OffreEmploiSearchParametersFiltres.withFiltres(contrat: [
        ContratFiltre.autre,
        ContratFiltre.cdd_interim_saisonnier,
        ContratFiltre.cdi,
      ]));

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 3);
    });

    test("when state has active duree filtre it should display 1 as filtre number", () {
      // Given
      final store = _storeWithFiltres(
        OffreEmploiSearchParametersFiltres.withFiltres(duree: [DureeFiltre.temps_plein]),
      );

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });

    test("when state has multiple active duree filtres it should display 2 as filtre number", () {
      // Given
      final store = _storeWithFiltres(
        OffreEmploiSearchParametersFiltres.withFiltres(duree: [DureeFiltre.temps_plein, DureeFiltre.temps_partiel]),
      );

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 2);
    });

    test(
        "when state has multiple filtres active at the same time it should display the total count of active filtre as filtre number",
        () {
      // Given
      final store = _storeWithFiltres(
        OffreEmploiSearchParametersFiltres.withFiltres(
            distance: 40,
            contrat: [ContratFiltre.cdi],
            experience: [ExperienceFiltre.trois_ans_et_plus, ExperienceFiltre.de_un_a_trois_ans],
            duree: [DureeFiltre.temps_plein]),
      );

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 5);
    });
  });

  test("create when search state is failure should display failure", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        offreEmploiSearchState: OffreEmploiSearchState.failure(),
      ),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("create when search state is success but empty should display empty message", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
          offreEmploiSearchState: OffreEmploiSearchState.success(),
          offreEmploiSearchResultsState:
              OffreEmploiSearchResultsState.data(offres: [], loadedPage: 1, isMoreDataAvailable: false)),
    );

    // When
    final viewModel = OffreEmploiSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.errorMessage, "Aucune offre ne correspond à votre recherche");
  });

  group("Filtre button…", () {
    test('when search is not only for alternance should be displayed', () {
      // Given
      Store<AppState> store = _storeWithParams(onlyAlternance: false, location: null);

      // When
      final viewModel = OffreEmploiSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.withFiltreButton, true);
    });

    group('when search is only for alternance…', () {
      test('and location is null should not be displayed', () {
        // Given
        Store<AppState> store = _storeWithParams(onlyAlternance: true, location: null);

        // When
        final viewModel = OffreEmploiSearchResultsViewModel.create(store);

        // Then
        expect(viewModel.withFiltreButton, false);
      });

      test('and location is DEPARTMENT should not be displayed', () {
        // Given
        Store<AppState> store = _storeWithParams(
          onlyAlternance: true,
          location: Location(libelle: '', code: '', type: LocationType.DEPARTMENT),
        );

        // When
        final viewModel = OffreEmploiSearchResultsViewModel.create(store);

        // Then
        expect(viewModel.withFiltreButton, false);
      });

      test('and location is COMMUNE should be displayed', () {
        // Given
        Store<AppState> store = _storeWithParams(
          onlyAlternance: true,
          location: Location(libelle: '', code: '', type: LocationType.COMMUNE),
        );

        // When
        final viewModel = OffreEmploiSearchResultsViewModel.create(store);

        // Then
        expect(viewModel.withFiltreButton, true);
      });
    });
  });
}

Store<AppState> _storeWithFiltres(OffreEmploiSearchParametersFiltres filtres) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
        keywords: "keyWords",
        location: mockLocation(),
        onlyAlternance: false,
        filtres: filtres,
      ),
    ),
  );
}

Store<AppState> _storeWithParams({required bool onlyAlternance, required Location? location}) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(
      offreEmploiSearchParametersState: OffreEmploiSearchParametersState.initialized(
        keywords: "",
        location: location,
        onlyAlternance: onlyAlternance,
        filtres: OffreEmploiSearchParametersFiltres.noFiltres(),
      ),
    ),
  );
}