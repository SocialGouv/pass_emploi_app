import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_personnalisee_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_creation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when state is in error should display error', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(createDemarcheState: CreateDemarcheFailureState()),
    );

    // When
    final viewModel = CreateDemarchePersonnaliseeViewModel.create(store, false);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
    expect(viewModel.demarcheCreationState, isA<DemarcheCreationPendingState>());
  });

  test('create when state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(createDemarcheState: CreateDemarcheLoadingState()),
    );

    // When
    final viewModel = CreateDemarchePersonnaliseeViewModel.create(store, false);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
    expect(viewModel.demarcheCreationState, isA<DemarcheCreationPendingState>());
  });

  test('create when state is success should go back to previous page', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(createDemarcheState: CreateDemarcheSuccessState('DEMARCHE-ID')),
    );

    // When
    final viewModel = CreateDemarchePersonnaliseeViewModel.create(store, false);

    // Then
    expect(viewModel.demarcheCreationState, isA<DemarcheCreationSuccessState>());
    expect((viewModel.demarcheCreationState as DemarcheCreationSuccessState).demarcheCreatedId, 'DEMARCHE-ID');
  });

  test('onSearchDemarche should trigger action with estDuplicata to false', () {
    // Given
    final store = StoreSpy();
    final viewModel = CreateDemarchePersonnaliseeViewModel.create(store, false);
    final now = DateTime.now();

    // When
    viewModel.onCreateDemarche('commentaire', now);

    // Then
    expect(store.dispatchedAction, isA<CreateDemarchePersonnaliseeRequestAction>());
    final action = store.dispatchedAction as CreateDemarchePersonnaliseeRequestAction;
    expect(action.commentaire, 'commentaire');
    expect(action.dateEcheance, now);
    expect(action.estDuplicata, false);
  });

  test('onSearchDemarche should trigger action with estDuplicata to true', () {
    // Given
    final store = StoreSpy();
    final viewModel = CreateDemarchePersonnaliseeViewModel.create(store, true);
    final now = DateTime.now();

    // When
    viewModel.onCreateDemarche('commentaire', now);

    // Then
    expect(store.dispatchedAction, isA<CreateDemarchePersonnaliseeRequestAction>());
    final action = store.dispatchedAction as CreateDemarchePersonnaliseeRequestAction;
    expect(action.commentaire, 'commentaire');
    expect(action.estDuplicata, true);
  });
}
