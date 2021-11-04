import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/network/headers.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/middlewares/api_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/repositories/create_user_action_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';

main() {
  final createActionSpy = CreateUserActionRepositoryMock();

  final middleware = ApiMiddleware(
    DummyUserRepository(),
    DummyHomeRepository(),
    DummyUserActionRepository(),
    DummyChatRepository(),
    createActionSpy,
  );

  test('call should call create action repository with success dispatch', () async {
    // Given
    final storeSpy = StoreSpy();
    final createUserAction = CreateUserAction("content", "comment", UserActionStatus.DONE);
    final store = Store<AppState>(storeSpy.reducer,
        initialState: AppState.initialState().copyWith(
            loginState: LoggedInState(User(id: "id", firstName: "firstName", lastName: "lastName"))));

    // When
    await middleware.call(store, createUserAction, (action) => {});

    // Then
    expect(createActionSpy.wasCalled, true);
    expect(storeSpy.calledWithSuccess, true);
  });

  test('call should dispatch un error action', () async {
    // Given
    final storeSpy = StoreSpy();
    final createUserAction = CreateUserAction("content", "comment", UserActionStatus.DONE);
    final store = Store<AppState>(storeSpy.reducer,
        initialState: AppState.initialState().copyWith(
            loginState: LoggedInState(User(id: "error", firstName: "firstName", lastName: "lastName"))));

    // When
    await middleware.call(store, createUserAction, (action) => {});

    // Then
    expect(createActionSpy.wasCalled, true);
    expect(storeSpy.calledWithFailure, true);
  });

}

class StoreSpy {
  var calledWithSuccess = false;
  var calledWithFailure = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionCreatedWithSuccessAction) {
      calledWithSuccess = true;
    }
    if (action is UserActionCreationFailed) {
      calledWithFailure = true;
    }
    return currentState;
  }
}

class CreateUserActionRepositoryMock extends CreateUserActionRepository {
  bool wasCalled = false;

  CreateUserActionRepositoryMock() : super("string", DummyHeadersBuilder());

  @override
  Future<bool> createUserAction(String userId, String? content, String? comment, UserActionStatus status) async {
    wasCalled = true;
    return userId == "error" ? false : true;
  }
}
