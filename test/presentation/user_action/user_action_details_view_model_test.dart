import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';

void main() {
  group("create when action has been updated ...", () {
    test("to not_started status should dismiss bottom sheet", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          userActionUpdateState: UserActionUpdatedState(UserActionStatus.NOT_STARTED),
        ),
      );

      // When
      final viewModel = UserActionDetailsViewModel.create(store);

      // Then
      expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("to in_progress status should dismiss bottom sheet", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          userActionUpdateState: UserActionUpdatedState(UserActionStatus.IN_PROGRESS),
        ),
      );

      // When
      final viewModel = UserActionDetailsViewModel.create(store);

      // Then
      expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("to done status should show success screen", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          userActionUpdateState: UserActionUpdatedState(UserActionStatus.DONE),
        ),
      );

      // When
      final viewModel = UserActionDetailsViewModel.create(store);

      // Then
      expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    });
  });

  test("create when action is not updating should show content", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionNotUpdatingState()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_CONTENT);
  });

  test("create when action is no update needed should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionNoUpdateNeededState()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS);
  });

  test("create when delete action succeeds should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionDeleteState: UserActionDeleteSuccessState()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION);
  });

  test("create when delete action loads should display loading", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionDeleteState: UserActionDeleteLoadingState()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_LOADING);
  });

  test("create when delete action fails should display error", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionDeleteState: UserActionDeleteFailureState()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_DELETE_ERROR);
  });

  test('refreshStatus when update status has changed should dispatch a UpdateActionStatus', () {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState(
          [
            UserAction(
              id: "id",
              content: "content",
              comment: "comment",
              status: UserActionStatus.DONE,
              lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
              creator: JeuneActionCreator(),
            ),
            UserAction(
              id: "id2",
              content: "content2",
              comment: "",
              status: UserActionStatus.NOT_STARTED,
              lastUpdate: DateTime(2022, 11, 13, 0, 0, 0),
              creator: JeuneActionCreator(),
            ),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);
    viewModel.onRefreshStatus("id", UserActionStatus.NOT_STARTED);

    // Then
    expect(storeSpy.calledWithUpdate, true);
  });

  test('refreshStatus when update status has not changed should dispatch UserActionNoUpdateNeededAction', () {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState(
          [
            UserAction(
              id: "id",
              content: "content",
              comment: "comment",
              status: UserActionStatus.DONE,
              lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
              creator: JeuneActionCreator(),
            ),
            UserAction(
              id: "id2",
              content: "content2",
              comment: "",
              status: UserActionStatus.NOT_STARTED,
              lastUpdate: DateTime(2022, 11, 13, 0, 0, 0),
              creator: JeuneActionCreator(),
            ),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);
    viewModel.onRefreshStatus("id", UserActionStatus.DONE);

    // Then
    expect(storeSpy.calledWithNoUpdateNeeded, true);
    expect(storeSpy.calledWithUpdate, false);
  });
}

class StoreSpy {
  var calledWithNoUpdateNeeded = false;
  var calledWithUpdate = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionNoUpdateNeededAction) {
      calledWithNoUpdateNeeded = true;
    }
    if (action is UserActionUpdateRequestAction) {
      calledWithUpdate = true;
    }
    return currentState;
  }
}
