import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../doubles/fixtures.dart';

main() {
  test('create when action state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionState: State<List<UserAction>>.loading()),
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
      initialState: loggedInState().copyWith(userActionState: State<List<UserAction>>.notInitialized()),
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
      initialState: loggedInState().copyWith(userActionState: State<List<UserAction>>.failure()),
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
      initialState: loggedInState().copyWith(userActionState: State<List<UserAction>>.failure()),
    );
    final viewModel = UserActionListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.calledWithRetry, true);
  });

  test(
      "create when action state is success with active and done actions should display them separated by done actions title",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
          userActionState: State<List<UserAction>>.success([
        _userAction(status: UserActionStatus.DONE),
        _userAction(status: UserActionStatus.IN_PROGRESS),
        _userAction(status: UserActionStatus.DONE),
        _userAction(status: UserActionStatus.NOT_STARTED),
        _userAction(status: UserActionStatus.IN_PROGRESS),
        _userAction(status: UserActionStatus.NOT_STARTED),
        _userAction(status: UserActionStatus.DONE),
        _userAction(status: UserActionStatus.IN_PROGRESS),
      ])),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 8);
    for (var i = 0; i < 5; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status != UserActionStatus.DONE, isTrue);
    }
    for (var i = 5; i < 8; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status == UserActionStatus.DONE, isTrue);
    }
  });

  test('create when action state is success but there are no actions should display an empty message', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionState: State<List<UserAction>>.success([])),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, true);
    expect(viewModel.items.length, 0);
  });

  test("create when action state is success with only active actions should display them", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
          userActionState: State<List<UserAction>>.success([
        _userAction(status: UserActionStatus.IN_PROGRESS),
        _userAction(status: UserActionStatus.NOT_STARTED),
        _userAction(status: UserActionStatus.IN_PROGRESS),
        _userAction(status: UserActionStatus.NOT_STARTED),
        _userAction(status: UserActionStatus.IN_PROGRESS),
      ])),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 5);
    for (var i = 0; i < 5; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status != UserActionStatus.DONE, isTrue);
    }
  });

  test("create when all actions are done should set item count to actions count + 1 to display title", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
          userActionState: State<List<UserAction>>.success([
        _userAction(status: UserActionStatus.DONE),
        _userAction(status: UserActionStatus.DONE),
      ])),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 2);
    for (var i = 0; i < 2; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status == UserActionStatus.DONE, isTrue);
    }
  });

  test('onUserActionDetailsDismissed should dispatch DismissUserActionDetailsAction', () {
    // Given
    var storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState(),
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
      initialState: loggedInState(),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);
    viewModel.onCreateUserActionDismissed();

    // Then
    expect(storeSpy.calledWithDismissCreate, true);
  });
}

UserAction _userAction({required UserActionStatus status}) {
  return UserAction(
    id: "id",
    content: "content",
    comment: "comment",
    status: status,
    lastUpdate: DateTime(2022, 12, 23, 0, 0, 0),
    creator: JeuneActionCreator(),
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
    if (action is UserActionUpdateStatusAction) {
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
