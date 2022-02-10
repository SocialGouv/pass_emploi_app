import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/middlewares/user_action_middleware.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:pass_emploi_app/repositories/user_action_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';

main() {
  final repository = UserActionRepositoryMock();
  final middleware = UserActionMiddleware(repository);

  test('call should call create action repository with success dispatch', () async {
    // Given
    final storeSpy = StoreSpy();
    final createUserAction = CreateUserAction("content", "comment", UserActionStatus.DONE);
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: AppState.initialState().copyWith(loginState: successMiloUserState()),
    );

    // When
    await middleware.call(store, createUserAction, (action) => {});

    // Then
    expect(repository.wasCalled, true);
    expect(storeSpy.calledWithSuccess, true);
    expect(storeSpy.calledWithReloadData, true);
  });

  test('call should dispatch un error action', () async {
    // Given
    final storeSpy = StoreSpy();
    final createUserAction = CreateUserAction("content", "comment", UserActionStatus.DONE);
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: AppState.initialState().copyWith(
          loginState: State<User>.success(User(
        id: "error",
        firstName: "F",
        lastName: "L",
        email: null,
        loginMode: LoginMode.MILO,
      ))),
    );

    // When
    await middleware.call(store, createUserAction, (action) => {});

    // Then
    expect(repository.wasCalled, true);
    expect(storeSpy.calledWithFailure, true);
  });
}

class StoreSpy {
  var calledWithSuccess = false;
  var calledWithFailure = false;
  var calledWithReloadData = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionCreatedWithSuccessAction) {
      calledWithSuccess = true;
    }
    if (action is UserActionCreationFailed) {
      calledWithFailure = true;
    }
    if (action is RequestUserActionsAction) {
      calledWithReloadData = true;
    }
    return currentState;
  }
}

class UserActionRepositoryMock extends UserActionRepository {
  bool wasCalled = false;

  UserActionRepositoryMock() : super("string", DummyHttpClient(), DummyHeadersBuilder());

  @override
  Future<bool> createUserAction(String userId, String? content, String? comment, UserActionStatus status) async {
    wasCalled = true;
    return userId == "error" ? false : true;
  }

  @override
  Future<List<UserAction>?> getUserActions(String userId) async {
    return null;
  }

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    return;
  }
}
