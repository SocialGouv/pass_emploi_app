import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/saved_search/delete/presentation/saved_search_delete_view_model.dart';
import 'package:pass_emploi_app/features/saved_search/delete/slice/actions.dart';
import 'package:pass_emploi_app/features/saved_search/delete/slice/state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';

import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

main() {
  test('create when saved search delete state is not initialized should display content', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchDeleteState: SavedSearchDeleteNotInitializedState(),
      ),
    );

    // When
    final viewModel = SavedSearchDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, SavedSearchDeleteDisplayState.CONTENT);
  });

  test('create when saved search delete state is loading should display loading', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchDeleteState: SavedSearchDeleteLoadingState(),
      ),
    );

    // When
    final viewModel = SavedSearchDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, SavedSearchDeleteDisplayState.LOADING);
  });

  test('create when saved search delete state is failure should display failure', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchDeleteState: SavedSearchDeleteFailureState(),
      ),
    );

    // When
    final viewModel = SavedSearchDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, SavedSearchDeleteDisplayState.FAILURE);
  });

  test('create when saved search delete state is successr should display successr', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: AppState.initialState().copyWith(
        savedSearchDeleteState: SavedSearchDeleteSuccessState(),
      ),
    );

    // When
    final viewModel = SavedSearchDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, SavedSearchDeleteDisplayState.SUCCESS);
  });

  test('View model triggers SavedSearchDeleteRequestAction when onDeleteConfirm is performed', () {
    // Given
    final store = StoreSpy();
    final viewModel = SavedSearchDeleteViewModel.create(store);

    // When
    viewModel.onDeleteConfirm("id");

    // Then
    expect(store.dispatchedAction is SavedSearchDeleteRequestAction, isTrue);
    expect((store.dispatchedAction as SavedSearchDeleteRequestAction).savedSearchId, "id");
  });
}
