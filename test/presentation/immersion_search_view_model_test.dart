import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_state.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/immersion_search_view_model.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

main() {
  test("create when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionListState: ImmersionListLoadingState()),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_LOADER);
  });

  test("create when state is failure should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionListState: ImmersionListFailureState()),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_ERROR);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test(
      "create when state is success and not empty should display result (empty content is directly handled by result page)",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionListState: ImmersionListSuccessState([])),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_RESULTS);
  });

  test("create when state is success and not empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionListState: ImmersionListSuccessState([mockImmersion()]),
      ),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_RESULTS);
    expect(viewModel.immersions, [mockImmersion()]);
    expect(viewModel.errorMessage, "");
  });

  test("create returns location result properly formatted", () {
    // Given
    final department = Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT);
    final commune = Location(libelle: "Paris 1", code: "75111", codePostal: "75001", type: LocationType.COMMUNE);
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(searchLocationState: SearchLocationState([department, commune])),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_SEARCH_FORM);
    expect(viewModel.locations, [
      LocationViewModel("Paris (75)", department),
      LocationViewModel("Paris 1 (75001)", commune),
    ]);
  });

  test("create returns location result with proper toString value for autocomplete widget onSelected", () {
    // Given
    final department = Location(libelle: "Paris", code: "75", type: LocationType.DEPARTMENT);
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(searchLocationState: SearchLocationState([department])),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_SEARCH_FORM);
    expect(viewModel.locations.first.toString(), "Paris (75)");
  });

  test('View model triggers RequestLocationAction when onInputLocation is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionSearchViewModel.create(store);

    viewModel.onInputLocation("mars");

    expect(store.dispatchedAction, isA<SearchLocationRequestAction>());
    final action = (store.dispatchedAction as SearchLocationRequestAction);
    expect(action.input, "mars");
    expect(action.villesOnly, isTrue);
  });

  test('View model triggers SearchImmersionAction when onSearchingRequest is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionSearchViewModel.create(store);

    viewModel.onSearchingRequest("code-rome", mockLocation());

    expect(store.dispatchedAction, isA<ImmersionListRequestAction>());
    expect((store.dispatchedAction as ImmersionListRequestAction).request.codeRome, "code-rome");
    expect((store.dispatchedAction as ImmersionListRequestAction).request.location, mockLocation());
  });

  test('View model triggers ImmersionSearchFailureAction when onSearchingRequest is performed with null params', () {
    final store = StoreSpy();
    final viewModel = ImmersionSearchViewModel.create(store);

    viewModel.onSearchingRequest(null, null);

    expect(store.dispatchedAction, isA<ImmersionListFailureAction>());
  });

  test("create returns metier", () {
    // Given
    final metier = Metier.values.first;
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(searchMetierState: SearchMetierState([metier])),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_SEARCH_FORM);
    expect(viewModel.metiers, [metier]);
  });

  test('View model triggers RequestMetierAction when onInputMetier is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionSearchViewModel.create(store);

    viewModel.onInputMetier("boul");

    expect(store.dispatchedAction, isA<SearchMetierRequestAction>());
    final action = (store.dispatchedAction as SearchMetierRequestAction);
    expect(action.input, "boul");
  });
}
