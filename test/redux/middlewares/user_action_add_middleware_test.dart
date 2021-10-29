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
import 'package:pass_emploi_app/repositories/user_action_creation_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';

main() {
  final createActionSpy = CreateUserActionRepositorySpy();

  final middleware = ApiMiddleware(
    DummyUserRepository(),
    DummyHomeRepository(),
    DummyUserActionRepository(),
    DummyChatRepository(),
    createActionSpy,
  );

  test('call should call create action repository', () {
    // Given
    final createUserAction = CreateUserAction("content", "comment", UserActionStatus.DONE);
    final store = Store<AppState>(reducer,
        initialState: AppState.initialState().copyWith(
            loginState: LoggedInState(User(id: "id", firstName: "firstName", lastName: "lastName"))));

    // When
    middleware.call(store, createUserAction, (action) => {});

    // Then
    expect(createActionSpy.wasCalled, true);
  });
}

class CreateUserActionRepositorySpy extends UserActionCreationRepository {
  bool wasCalled = false;

  CreateUserActionRepositorySpy() : super("string", DummyHeadersBuilder());

  @override
  Future<void> createAction(String userId, String? content, String? comment, UserActionStatus status) async {
    wasCalled = true;
  }
}
