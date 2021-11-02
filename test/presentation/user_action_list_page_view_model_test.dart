import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

main() {
  test('create when user is not logged in should throw exception', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: AppState.initialState().copyWith(loginState: LoginState.notLoggedIn()),
    );

    // When / Then
    expect(() => UserActionListPageViewModel.create(store), throwsException);
  });

  test('create when action state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(userActionState: UserActionState.loading()),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, true);
    expect(viewModel.withFailure, false);
  });

  test('create when action state is not initialized should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(userActionState: UserActionState.notInitialized()),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, true);
    expect(viewModel.withFailure, false);
  });

  test('create when action state is a failure should display failure', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(userActionState: UserActionState.failure()),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, true);
  });

  test('retry, after view model was created with failure, should dispatch a RequestUserActionsAction', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: _loggedInState().copyWith(userActionState: UserActionState.failure()),
    );
    final viewModel = UserActionListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.calledWithRetry, true);
  });

  test('create when action state is success with actions should display them', () {
    // Given
    final store = Store<AppState>(
      reducer,
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
          creator: ConseillerActionCreator(name: "Nils Tavernier"),
        ),
      ])),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.items.length, 2);
    expect(viewModel.items[0].id, "id");
    expect(viewModel.items[0].content, "content");
    expect(viewModel.items[0].comment, "comment");
    expect(viewModel.items[0].withComment, true);
    expect(viewModel.items[0].status, UserActionStatus.DONE);
    expect(viewModel.items[0].lastUpdate, DateTime(2022, 12, 23, 0, 0, 0));
    expect(viewModel.items[0].creator, Strings.you);
    expect(viewModel.items[1].id, "id2");
    expect(viewModel.items[1].content, "content2");
    expect(viewModel.items[1].comment, "");
    expect(viewModel.items[1].withComment, false);
    expect(viewModel.items[1].status, UserActionStatus.NOT_STARTED);
    expect(viewModel.items[1].lastUpdate, DateTime(2022, 11, 13, 0, 0, 0));
    expect(viewModel.items[1].creator, "Nils Tavernier");
  });

  test('create when action state is success but there are no actions should display an empty message', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: _loggedInState().copyWith(userActionState: UserActionState.success([])),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, true);
    expect(viewModel.items.length, 0);
  });

  test('onUserActionDetailsDismissed should dispatch DismissUserActionDetailsAction', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: _loggedInState(),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);
    viewModel.onUserActionDetailsDismissed();

    // Then
    expect(storeSpy.calledWithDismissDetails, true);
  });

  test('onCreateUserActionDismissed should dispatch DismissCreateUserAction', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: _loggedInState(),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);
    viewModel.onCreateUserActionDismissed();

    // Then
    expect(storeSpy.calledWithDismissCreate, true);
  });
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

class StoreSpy {
  var calledWithRetry = false;
  var calledWithUpdate = false;
  var calledWithDismissDetails = false;
  var calledWithDismissCreate = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is RequestUserActionsAction) {
      calledWithRetry = true;
    }
    if (action is UpdateActionStatus) {
      calledWithUpdate = true;
    }
    if (action is DismissUserActionDetailsAction) {
      calledWithDismissDetails = true;
    }
    if (action is DismissCreateUserAction) {
      calledWithDismissCreate = true;
    }
    return currentState;
  }
}
