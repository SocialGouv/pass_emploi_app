import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../utils/test_setup.dart';

void main() {
  test('create when action state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionListState: UserActionListLoadingState()),
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
      initialState: loggedInState().copyWith(userActionListState: UserActionListNotInitializedState()),
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
      initialState: loggedInState().copyWith(userActionListState: UserActionListFailureState()),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, true);
  });

  test('retry, after view model was created with failure, should dispatch a RequestUserActionsAction', () {
    // Given
    final storeSpy = LocalStoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState().copyWith(userActionListState: UserActionListFailureState()),
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
        userActionListState: UserActionListSuccessState(
          [
            _userAction(status: UserActionStatus.DONE),
            _userAction(status: UserActionStatus.CANCELED),
            _userAction(status: UserActionStatus.IN_PROGRESS),
            _userAction(status: UserActionStatus.DONE),
            _userAction(status: UserActionStatus.NOT_STARTED),
            _userAction(status: UserActionStatus.IN_PROGRESS),
            _userAction(status: UserActionStatus.NOT_STARTED),
            _userAction(status: UserActionStatus.DONE),
            _userAction(status: UserActionStatus.IN_PROGRESS),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 10);
    for (var i = 0; i < 5; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status.isCanceledOrDone(), false);
    }
    expect(viewModel.items[5] is UserActionListSubtitle, isTrue);
    expect((viewModel.items[5] as UserActionListSubtitle).title, "Actions terminées et annulées");
    for (var i = 6; i < 10; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status.isCanceledOrDone(), true);
    }
  });

  test(
      'create when action state is success but there are no actions and no campagne neither should display an empty message',
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionListState: UserActionListSuccessState([], null)),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, true);
    expect(viewModel.items.length, 0);
  });

  test('create when action state is success but there are no actions but with campagne should display campagne card',
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionListState: UserActionListSuccessState([], campagne())),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, false);
    expect(viewModel.items.length, 1);
    expect(viewModel.items[0] is UserActionCampagneItemViewModel, isTrue);
  });

  test("create when action state is success with only active actions should display them", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState(
          [
            _userAction(status: UserActionStatus.IN_PROGRESS),
            _userAction(status: UserActionStatus.NOT_STARTED),
            _userAction(status: UserActionStatus.IN_PROGRESS),
            _userAction(status: UserActionStatus.NOT_STARTED),
            _userAction(status: UserActionStatus.IN_PROGRESS),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 5);
    for (var i = 0; i < 5; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status.isCanceledOrDone(), false);
    }
  });

  test("create when all actions are done/canceled should set item count to actions count + 1 to display title", () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState(
          [
            _userAction(status: UserActionStatus.DONE),
            _userAction(status: UserActionStatus.DONE),
            _userAction(status: UserActionStatus.CANCELED),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 4);
    expect(viewModel.items[0] is UserActionListSubtitle, isTrue);
    expect((viewModel.items[0] as UserActionListSubtitle).title, "Actions terminées et annulées");
    for (var i = 1; i < 4; ++i) {
      expect(viewModel.items[i] is UserActionListItemViewModel, isTrue);
      expect((viewModel.items[i] as UserActionListItemViewModel).viewModel.status.isCanceledOrDone(), true);
    }
  });

  test('create when action state is success and coming from deeplink', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_ACTION, DateTime.now(), 'id'),
        userActionListState: UserActionListSuccessState([_userAction(status: UserActionStatus.NOT_STARTED)]),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.actionDetails?.id, 'id');
  });

  test('return isNull when action state is success and coming from deeplink but ID is not valid anymore', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        deepLinkState: DeepLinkState(DeepLink.ROUTE_TO_ACTION, DateTime.now(), '1'),
        userActionListState: UserActionListSuccessState([_userAction(status: UserActionStatus.NOT_STARTED)]),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.actionDetails?.id, isNull);
  });

  test('onUserActionDetailsDismissed should dispatch DismissUserActionDetailsAction', () {
    // Given
    final storeSpy = LocalStoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState(),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);
    viewModel.onUserActionDetailsDismissed();

    // Then
    expect(storeSpy.calledWithResetCreate, true);
    expect(storeSpy.calledWithResetUpdate, true);
  });

  test('onCreateUserActionDismissed should dispatch DismissCreateUserAction', () {
    // Given
    final storeSpy = LocalStoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState(),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);
    viewModel.onCreateUserActionDismissed();

    // Then
    expect(storeSpy.calledWithResetCreate, true);
  });

  test('onDeeplinkUsed should trigger ResetDeeplinkAction', () {
    // Given
    final store = StoreSpy();

    final viewModel = UserActionListPageViewModel.create(store);

    // When
    viewModel.onDeeplinkUsed();

    // Then
    expect(store.dispatchedAction, isA<ResetDeeplinkAction>());
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

class LocalStoreSpy {
  var calledWithRetry = false;
  var calledWithUpdate = false;
  var calledWithResetUpdate = false;
  var calledWithResetCreate = false;
  var calledWithResetDelete = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionListRequestAction) calledWithRetry = true;
    if (action is UserActionUpdateRequestAction) calledWithUpdate = true;
    if (action is UserActionUpdateResetAction) calledWithResetUpdate = true;
    if (action is UserActionCreateResetAction) calledWithResetCreate = true;
    if (action is UserActionDeleteResetAction) calledWithResetCreate = true;
    return currentState;
  }
}
