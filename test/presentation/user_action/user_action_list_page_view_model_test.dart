import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
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
      "create when action state is success with active and done user_action and campagne should display them separated by done user_action title and campagne in first position",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState(
          [
            mockUserAction(id: 'DONE', status: UserActionStatus.DONE),
            mockUserAction(id: 'CANCELED', status: UserActionStatus.CANCELED),
            mockUserAction(id: 'IN_PROGRESS', status: UserActionStatus.IN_PROGRESS),
            mockUserAction(id: 'DONE', status: UserActionStatus.DONE),
            mockUserAction(id: 'NOT_STARTED', status: UserActionStatus.NOT_STARTED),
            mockUserAction(id: 'IN_PROGRESS', status: UserActionStatus.IN_PROGRESS),
            mockUserAction(id: 'NOT_STARTED', status: UserActionStatus.NOT_STARTED),
            mockUserAction(id: 'DONE', status: UserActionStatus.DONE),
            mockUserAction(id: 'IN_PROGRESS', status: UserActionStatus.IN_PROGRESS),
          ],
        ),
        campagneState: CampagneState(campagne(), []), //TODO: remove + in title
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 11); //TODO: 10 ?
    expect(viewModel.items[0] is CampagneItem, isTrue); //TODO: remove
    for (var i = 1; i < 6; ++i) {
      expect(viewModel.items[i] is IdItem, isTrue);
      expect((viewModel.items[i] as IdItem).userActionId, isIn(['IN_PROGRESS', 'NOT_STARTED']));
    }
    expect(viewModel.items[6] is SubtitleItem, isTrue);
    expect((viewModel.items[6] as SubtitleItem).title, "Actions terminées et annulées");
    for (var i = 7; i < 11; ++i) {
      expect(viewModel.items[i] is IdItem, isTrue);
      expect((viewModel.items[i] as IdItem).userActionId, isIn(['DONE', 'CANCELED']));
    }
  });

  test(
      'create when action state is success but there are no user_action and no campagne neither should display an empty message',
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState([]),
        campagneState: CampagneState(null, []), //TODO: remove + title
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, true);
    expect(viewModel.items.length, 0);
  });

//TODO: remove the whole test ?
  test(
      'create when action state is success but there are no user_action but with campagne should display campagne card',
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        userActionListState: UserActionListSuccessState([]),
        campagneState: CampagneState(campagne(), []), //TODO: remove + title
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.withLoading, false);
    expect(viewModel.withFailure, false);
    expect(viewModel.withEmptyMessage, false);
    expect(viewModel.items.length, 1);
    expect(viewModel.items[0] is CampagneItem, isTrue); //TODO: remove
  });

  test("create when action state is success with only active user_action should display them", () {
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
      expect(viewModel.items[i] is IdItem, isTrue);
    }
  });

  test("create when all user_action are done/canceled should set item count to user_action count + 1 to display title",
      () {
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
    expect(viewModel.items[0] is SubtitleItem, isTrue);
    expect((viewModel.items[0] as SubtitleItem).title, "Actions terminées et annulées");
    for (var i = 1; i < 4; ++i) {
      expect(viewModel.items[i] is IdItem, isTrue);
    }
  });

  test('create when action state is success and coming from deeplink', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        deepLinkState: DetailActionDeepLinkState(idAction: 'id'),
        userActionListState: UserActionListSuccessState([_userAction(status: UserActionStatus.NOT_STARTED)]),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.deeplinkActionId, 'id');
  });

  test('return isNull when action state is success and coming from deeplink but ID is not valid anymore', () {
    // Given
    final store = TestStoreFactory().initializeReduxStore(
      initialState: loggedInState().copyWith(
        deepLinkState: DetailActionDeepLinkState(idAction: '1'),
        userActionListState: UserActionListSuccessState([_userAction(status: UserActionStatus.NOT_STARTED)]),
      ),
    );

    // When
    final viewModel = UserActionListPageViewModel.create(store);

    // Then
    expect(viewModel.deeplinkActionId, isNull);
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
    dateEcheance: DateTime(2042),
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
