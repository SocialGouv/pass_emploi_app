import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/create_demarche_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when state is in error should display error', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(createDemarcheState: CreateDemarcheFailureState()),
    );

    // When
    final viewModel = CreateDemarcheViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.shouldGoBack, isFalse);
  });

  test('create when state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(createDemarcheState: CreateDemarcheLoadingState()),
    );

    // When
    final viewModel = CreateDemarcheViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.shouldGoBack, isFalse);
  });

  test('create when state is success should go back to previous page', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(createDemarcheState: CreateDemarcheSuccessState()),
    );

    // When
    final viewModel = CreateDemarcheViewModel.create(store);

    // Then
    expect(viewModel.shouldGoBack, isTrue);
  });
}
