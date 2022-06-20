import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step1_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when state is not initialized should display form', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(searchDemarcheState: SearchDemarcheNotInitializedState()),
    );

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.shouldGoToStep2, isFalse);
  });

  test('create when state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(searchDemarcheState: SearchDemarcheLoadingState()),
    );

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.shouldGoToStep2, isFalse);
  });

  test('create when state is failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(searchDemarcheState: SearchDemarcheFailureState()),
    );

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.shouldGoToStep2, isFalse);
  });

  test('create when state is success should go to step 2', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(searchDemarcheState: SearchDemarcheSuccessState([])),
    );

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.shouldGoToStep2, isTrue);
  });

  test('onSearchDemarche should trigger action', () {
    // Given
    final store = StoreSpy();
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // When
    viewModel.onSearchDemarche('query');

    // Then
    expect(store.dispatchedAction, isA<SearchDemarcheRequestAction>());
    expect((store.dispatchedAction as SearchDemarcheRequestAction).query, 'query');
  });
}
