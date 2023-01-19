import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("create when state is success should convert data to view model", () {
    // Given
    final store = givenState() //
        .loggedInUser()
        .copyWith(immersionListState: ImmersionListSuccessState([mockImmersion()]))
        .store();

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items, [mockImmersion()]);
    expect(viewModel.errorMessage, isEmpty);
  });

  test("create when state is success but there is not data should correctly map it to view model", () {
    // Given
    final store = givenState() //
        .loggedInUser()
        .copyWith(immersionListState: ImmersionListSuccessState([]))
        .store();

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, isEmpty);
  });

  test("create when state is loading should convert data to view model", () {
    // Given
    final store = givenState() //
        .loggedInUser()
        .copyWith(immersionListState: ImmersionListLoadingState())
        .store();

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, isEmpty);
  });

  test("create when state is failure should convert data to view model", () {
    // Given
    final store = givenState() //
        .loggedInUser()
        .copyWith(immersionListState: ImmersionListFailureState())
        .store();

    // When
    final viewModel = ImmersionSearchResultsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.items, []);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });
  group("create should properly set filtre number ...", () {
    test("when state has no active filtre it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(ImmersionSearchParametersFiltres.noFiltres());

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active distance filtre but value is default it should not display a filtre number", () {
      // Given
      final store = _storeWithFiltres(ImmersionSearchParametersFiltres.distance(10));

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, isNull);
    });

    test("when state has active distance filtre and value is not default it should display 1 as filtre number", () {
      // Given
      final store = _storeWithFiltres(ImmersionSearchParametersFiltres.distance(90));

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.filtresCount, 1);
    });
  });

  group('with Entreprises Accueillantes header', () {
    test('when not any immersion is from entreprise accueillante should return false', () {
      // Given
      final store = givenState() //
          .loggedInUser()
          .copyWith(
            immersionListState: ImmersionListSuccessState([
              mockImmersion(fromEntrepriseAccueillante: false),
              mockImmersion(fromEntrepriseAccueillante: false),
            ]),
          )
          .store();

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.withEntreprisesAccueillantesHeader, isFalse);
    });

    test('when at least one immersion is from entreprise accueillante should return true', () {
      // Given
      final store = givenState() //
          .loggedInUser()
          .copyWith(
            immersionListState: ImmersionListSuccessState([
              mockImmersion(fromEntrepriseAccueillante: false),
              mockImmersion(fromEntrepriseAccueillante: true),
            ]),
          )
          .store();

      // When
      final viewModel = ImmersionSearchResultsViewModel.create(store);

      // Then
      expect(viewModel.withEntreprisesAccueillantesHeader, isTrue);
    });
  });
}

Store<AppState> _storeWithFiltres(ImmersionSearchParametersFiltres filtres) {
  return Store<AppState>(
    reducer,
    initialState: AppState.initialState().copyWith(
      immersionListState: ImmersionListSuccessState([mockImmersion()]),
      immersionSearchParametersState: ImmersionSearchParametersInitializedState(
        codeRome: "codeRome",
        location: mockCommuneLocation(),
        filtres: filtres,
      ),
    ),
  );
}
