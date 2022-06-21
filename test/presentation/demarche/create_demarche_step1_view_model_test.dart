import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step1_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when state is not initialized should display form', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .copyWith(searchDemarcheState: SearchDemarcheNotInitializedState()) //
        .store();

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.shouldGoToStep2, isFalse);
  });

  test('create when state is loading should display loading', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .copyWith(searchDemarcheState: SearchDemarcheLoadingState()) //
        .store();

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.shouldGoToStep2, isFalse);
  });

  test('create when state is failure should display failure', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .copyWith(searchDemarcheState: SearchDemarcheFailureState()) //
        .store();

    // When
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.shouldGoToStep2, isFalse);
  });

  test('create when state is success should go to step 2', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .searchDemarchesSuccess([]) //
        .store();

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
