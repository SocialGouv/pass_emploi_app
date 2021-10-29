import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/middlewares/api_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';

main() {
  final middleware = ApiMiddleware(
    DummyUserRepository(),
    DummyHomeRepository(),
    DummyUserActionRepository(),
    DummyChatRepository(),
  );

  test('call should call create action repository', () {
    // Given
    final store = Store<AppState>(reducer, initialState: AppState.initialState());

    // When
    middleware.call(store, CreateUserAction("content", "comment"), (action) => {});

    // Then


  });
}

class CreateUserActionRepositorySpy {
  void createUserAction() {}
}
