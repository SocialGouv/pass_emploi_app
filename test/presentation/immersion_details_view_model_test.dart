import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/immersion_details.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  test("create when state is loading should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionDetailsState: State<ImmersionDetails>.loading()),
    );

    // When
    final viewModel = ImmersionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test("create when state is failure should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(immersionDetailsState: State<ImmersionDetails>.failure()),
    );

    // When
    final viewModel = ImmersionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    //expect(viewModel.errorMessage, "Erreur lors de la recherche. Veuillez réessayer");
  });

  test("create when state is success should set display state properly", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        immersionDetailsState: State<ImmersionDetails>.success(mockImmersionDetails()),
      ),
    );

    // When
    final viewModel = ImmersionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
  });
}
