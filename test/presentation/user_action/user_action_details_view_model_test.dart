import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';

void main() {
  group("create when action has been updated ...", () {
    test("to not_started status should dismiss bottom sheet", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
          userActionUpdateState: UserActionUpdatedState(UserActionStatus.NOT_STARTED),
        ),
      );

      // When
      final viewModel = UserActionDetailsViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("to in_progress status should dismiss bottom sheet", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
          userActionUpdateState: UserActionUpdatedState(UserActionStatus.IN_PROGRESS),
        ),
      );

      // When
      final viewModel = UserActionDetailsViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE);
    });

    test("to done status should show success screen", () {
      // Given
      final store = Store<AppState>(
        reducer,
        initialState: AppState.initialState().copyWith(
          userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
          userActionUpdateState: UserActionUpdatedState(UserActionStatus.DONE),
        ),
      );

      // When
      final viewModel = UserActionDetailsViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_SUCCESS);
    });
  });

  test("when action is on time", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id', dateEcheance: DateTime(2041, 1, 1))]),
        userActionUpdateState: UserActionUpdatedState(UserActionStatus.IN_PROGRESS),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(
      viewModel.dateFormattedTexts,
      [
        FormattedText("À réaliser pour le "),
        FormattedText("mardi 1 janvier", bold: true),
      ],
    );
    expect(viewModel.dateBackgroundColor, AppColors.accent3Lighten);
    expect(viewModel.dateTextColor, AppColors.accent2);
    expect(viewModel.dateIcons, [Drawables.icClock]);
  });

  test("when action is late", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id', dateEcheance: DateTime(2021, 1, 1))]),
        userActionUpdateState: UserActionUpdatedState(UserActionStatus.IN_PROGRESS),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(
      viewModel.dateFormattedTexts,
      [
        FormattedText("À réaliser pour le "),
        FormattedText("vendredi 1 janvier", bold: true),
      ],
    );
    expect(viewModel.dateBackgroundColor, AppColors.warningLighten);
    expect(viewModel.dateTextColor, AppColors.warning);
    expect(viewModel.dateIcons, [Drawables.icImportantOutlined, Drawables.icClock]);
  });

  test("create when action is not updating should show content", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
        userActionUpdateState: UserActionNotUpdatingState(),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_CONTENT);
  });

  test("create when action is no update needed should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
        userActionUpdateState: UserActionNoUpdateNeededState(),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS);
  });

  test("create when delete action succeeds should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
        userActionDeleteState: UserActionDeleteSuccessState(),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION);
  });

  test("create when delete action loads should display loading", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
        userActionDeleteState: UserActionDeleteLoadingState(),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_LOADING);
  });

  test("create when delete action fails should display error", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id')]),
        userActionDeleteState: UserActionDeleteFailureState(),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

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
              dateEcheance: DateTime(2042),
              creator: JeuneActionCreator(),
            ),
            UserAction(
              id: "id2",
              content: "content2",
              comment: "",
              status: UserActionStatus.NOT_STARTED,
              lastUpdate: DateTime(2022, 11, 13, 0, 0, 0),
              dateEcheance: DateTime(2042),
              creator: JeuneActionCreator(),
            ),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');
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
              dateEcheance: DateTime(2042),
              creator: JeuneActionCreator(),
            ),
            UserAction(
              id: "id2",
              content: "content2",
              comment: "",
              status: UserActionStatus.NOT_STARTED,
              lastUpdate: DateTime(2022, 11, 13, 0, 0, 0),
              dateEcheance: DateTime(2042),
              creator: JeuneActionCreator(),
            ),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');
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
