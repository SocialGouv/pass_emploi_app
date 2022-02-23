import 'package:async_redux/async_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_delete_view_model.dart';
import 'package:pass_emploi_app/redux/actions/saved_search_delete_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/saved_search_delete_state.dart';

main() {
  test('create when saved search delete state is not initialized should display content', () {
    // Given
    final store = Store<AppState>(
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
    final store = Store<AppState>(
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
    final store = Store<AppState>(
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
    final store = Store<AppState>(
      initialState: AppState.initialState().copyWith(
        savedSearchDeleteState: SavedSearchDeleteSuccessState(),
      ),
    );

    // When
    final viewModel = SavedSearchDeleteViewModel.create(store);

    // Then
    expect(viewModel.displayState, SavedSearchDeleteDisplayState.SUCCESS);
  });

  test('View model triggers SavedSearchDeleteRequestAction when onDeleteConfirm is performed', () async {
    // Given
    final storeTester = StoreTester<AppState>(
      initialState: AppState.initialState(),
      mocks: {SavedSearchDeleteRequestAction: MockedAction()},
    );
    final viewModel = SavedSearchDeleteViewModel.create(storeTester.store);

    // When
    viewModel.onDeleteConfirm("id");

    // Then
    TestInfo<AppState> info = await storeTester.wait(MockedAction);
    expect((info.action as MockedAction).data, "id");
  });
}

class MockedAction extends MockAction<AppState> {
  dynamic data;

  @override
  AppState reduce() {
    data = (action as SavedSearchDeleteRequestAction).savedSearchId;
    return state;
  }
}
