import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_actions.dart';
import 'package:pass_emploi_app/features/immersion/parameters/immersion_search_parameters_state.dart';
import 'package:pass_emploi_app/models/immersion_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_filtres_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';

void main() {
  test("create when search state is success should display success", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([mockImmersion()]),
      ),
    );

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });

  test("create when search state is loading should display loading", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListLoadingState(),
      ),
    );

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when search state is failure should display failure", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListFailureState(),
      ),
    );

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test(
      "create when search state is success but empty should display content (empty content is directly handled by result page)",
      () {
    // Given
    final store = Store<AppState>(reducer,
        initialState: AppState.initialState().copyWith(
          immersionListState: ImmersionListSuccessState([]),
        ));

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.errorMessage, '');
  });

  test("create when state has no filtre should set distance to 10km", () {
    // Given
    final store = _storeWithNoFiltres();

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 10);
  });

  test("create when state distance filtre set should set distance", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionSearchParametersState: ImmersionSearchParametersInitializedState(
          codeRome: "ROME",
          location: mockCommuneLocation(),
          filtres: ImmersionSearchParametersFiltres.distance(20),
        ),
      ),
    );

    // When
    final viewModel = ImmersionFiltresViewModel.create(store);

    // Then
    expect(viewModel.initialDistanceValue, 20);
  });

  test("updateFiltres should map view model input into action", () {
    // Given
    final store = StoreSpy();

    final viewModel = ImmersionFiltresViewModel.create(store);
    // When

    viewModel.updateFiltres(
      20,
    );

    // Then
    final ImmersionSearchUpdateFiltresRequestAction action =
        store.dispatchedAction as ImmersionSearchUpdateFiltresRequestAction;
    expect(action.updatedFiltres.distance, 20);
  });
}

Store<AppState> _storeWithNoFiltres({Reducer<AppState> customReducer = reducer}) {
  return Store<AppState>(
    customReducer,
    initialState: AppState.initialState().copyWith(
      immersionSearchParametersState: ImmersionSearchParametersInitializedState(
        codeRome: "ROME",
        location: mockCommuneLocation(),
        filtres: ImmersionSearchParametersFiltres.noFiltres(),
      ),
    ),
  );
}
