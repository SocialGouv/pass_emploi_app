import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_state.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_delete_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when alerte delete state is not initialized should display content', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        alerteDeleteState: AlerteDeleteNotInitializedState(),
      ),
    );

    // When
    final viewModel = AlerteDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, AlerteDeleteDisplayState.CONTENT);
  });

  test('create when alerte delete state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        alerteDeleteState: AlerteDeleteLoadingState(),
      ),
    );

    // When
    final viewModel = AlerteDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, AlerteDeleteDisplayState.LOADING);
  });

  test('create when alerte delete state is failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        alerteDeleteState: AlerteDeleteFailureState(),
      ),
    );

    // When
    final viewModel = AlerteDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, AlerteDeleteDisplayState.FAILURE);
  });

  test('create when alerte delete state is successr should display successr', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        alerteDeleteState: AlerteDeleteSuccessState(),
      ),
    );

    // When
    final viewModel = AlerteDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, AlerteDeleteDisplayState.SUCCESS);
  });

  test('View model triggers AlerteDeleteRequestAction when onDeleteConfirm is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = AlerteDeleteViewModel.create(store);

    // When
    viewModel.onDeleteConfirm("id");

    // Then
    expect(store.dispatchedAction is AlerteDeleteRequestAction, isTrue);
    expect((store.dispatchedAction as AlerteDeleteRequestAction).alerteId, "id");
  });
}
