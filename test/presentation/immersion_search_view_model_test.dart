import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/presentation/immersion_search_view_model.dart';
import 'package:pass_emploi_app/presentation/location_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/actions/search_location_action.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/search_location_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';
import '../doubles/spies.dart';

main() {
  test("create when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionSearchState: State<List<Immersion>>.loading()),
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
      initialState: AppState.initialState().copyWith(immersionSearchState: State<List<Immersion>>.failure()),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_ERROR);
    expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("create when state is success and not empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionSearchState: State<List<Immersion>>.success([])),
    );

    // When
    final viewModel = ImmersionSearchViewModel.create(store);

    // Then
    expect(viewModel.displayState, ImmersionSearchDisplayState.SHOW_EMPTY_ERROR);
    expect(viewModel.errorMessage, "Aucune offre ne correspond à votre recherche");
  });

  test("create when state is success and not empty should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionSearchState: State<List<Immersion>>.success([mockImmersion()]),
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

    expect(store.dispatchedAction, isA<RequestLocationAction>());
    final action = (store.dispatchedAction as RequestLocationAction);
    expect(action.input, "mars");
    expect(action.villesOnly, isTrue);
  });

  test('View model triggers SearchImmersionAction when onSearchingRequest is performed', () {
    final store = StoreSpy();
    final viewModel = ImmersionSearchViewModel.create(store);

    viewModel.onSearchingRequest("code-rome", mockLocation());

    expect((store.dispatchedAction as ImmersionAction).isRequest(), isTrue);
    expect((store.dispatchedAction as ImmersionAction).getRequestOrThrow().codeRome, "code-rome");
    expect((store.dispatchedAction as ImmersionAction).getRequestOrThrow().location, mockLocation());
  });

  test('View model triggers ImmersionSearchFailureAction when onSearchingRequest is performed with null params', () {
    final store = StoreSpy();
    final viewModel = ImmersionSearchViewModel.create(store);

    viewModel.onSearchingRequest(null, null);

    expect((store.dispatchedAction as ImmersionAction).isFailure(), isTrue);
  });
}
