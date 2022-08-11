import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
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
import '../../dsl/app_state_dsl.dart';
import '../../utils/test_datetime.dart';

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

  test("when action is on time should properly set texts, icons and active color", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id', dateEcheance: DateTime(2041, 1, 1))]),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(
      viewModel.dateEcheanceViewModel,
      UserActionDetailDateEcheanceViewModel(
        formattedTexts: [FormattedText("À réaliser pour le "), FormattedText("mardi 1 janvier", bold: true)],
        icons: [Drawables.icClock],
        textColor: AppColors.accent2,
        backgroundColor: AppColors.accent3Lighten,
      ),
    );
  });

  test("when action is late should properly set texts, icons and warning color", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id', dateEcheance: DateTime(2021, 1, 1))]),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(
      viewModel.dateEcheanceViewModel,
      UserActionDetailDateEcheanceViewModel(
        formattedTexts: [FormattedText("À réaliser pour le "), FormattedText("vendredi 1 janvier", bold: true)],
        icons: [Drawables.icImportantOutlined, Drawables.icClock],
        textColor: AppColors.warning,
        backgroundColor: AppColors.warningLighten,
      ),
    );
  });

  test("when action is DONE should not display date echeance", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id', status: UserActionStatus.DONE)]),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.dateEcheanceViewModel, isNull);
  });

  test("when action is CANCELED should not display date echeance", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(
        userActionListState: UserActionListSuccessState([mockUserAction(id: 'id', status: UserActionStatus.CANCELED)]),
      ),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.dateEcheanceViewModel, isNull);
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
              dateEcheance: DateTime(2042),
              creator: JeuneActionCreator(),
            ),
            UserAction(
              id: "id2",
              content: "content2",
              comment: "",
              status: UserActionStatus.NOT_STARTED,
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
              dateEcheance: DateTime(2042),
              creator: JeuneActionCreator(),
            ),
            UserAction(
              id: "id2",
              content: "content2",
              comment: "",
              status: UserActionStatus.NOT_STARTED,
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

  test("when action has comments should display the last comment", () {
    // Given
    final store = givenState().actionWithComments().store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(
      viewModel.lastComment,
      Commentaire(
        id: "8802034",
        content: "Deuxieme commentaire",
        creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T17:08:10.000"),
        creator: JeuneActionCreator(),
      ),
    );
  });
  test("when action has comments should display the last comment", () {
    // Given
    final store = givenState().actionWithoutComments().store();

    // When
    final viewModel = UserActionDetailsViewModel.create(store, 'id');

    // Then
    expect(viewModel.lastComment, null);
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
