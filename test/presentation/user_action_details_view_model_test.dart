import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action_details_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_update_state.dart';
import 'package:redux/redux.dart';

main() {
  test("create when action has been updated should show success", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState:
          AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.updated()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.SHOW_SUCCESS);
  });

  test("create when action is not updating should show content", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.notUpdating()),
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
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.noUpdateNeeded()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS);
  });

  test("create when action is no update needed should dismiss details", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(userActionUpdateState: UserActionUpdateState.noUpdateNeeded()),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);

    // Then
    expect(viewModel.displayState, UserActionDetailsDisplayState.TO_DISMISS);
  });


  test('refreshStatus when update status has changed should dispatch a UpdateActionStatus', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: _loggedInState().copyWith(
          userActionState: UserActionState.success([
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
          ])),
    );

    // When
    final viewModel = UserActionDetailsViewModel.create(store);
    viewModel.onRefreshStatus("id", UserActionStatus.NOT_STARTED);

    // Then
    expect(storeSpy.calledWithUpdate, true);
  });

  test('refreshStatus when update status has not changed should dispatch UserActionNoUpdateNeededAction', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: _loggedInState().copyWith(
          userActionState: UserActionState.success([
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
          ])),
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
    if (action is UpdateActionStatus) {
      calledWithUpdate = true;
    }
    return currentState;
  }
}

AppState _loggedInState() {
  return AppState.initialState().copyWith(
    loginState: LoginState.loggedIn(User(
      id: "id",
      firstName: "F",
      lastName: "L",
    )),
  );
}