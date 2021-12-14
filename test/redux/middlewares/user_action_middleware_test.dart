import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/middlewares/user_action_middleware.dart';
import 'package:pass_emploi_app/redux/reducers/app_reducer.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../doubles/stubs.dart';

main() {
  final repository = UserActionRepositorySuccessStub();
  final middleware = UserActionMiddleware(repository);
  final action = RequestUserActionsAction();

  test("call should send action untouched to next middleware", () {
    // Given
    final nextActionSpy = NextDispatcherSpy(expectedAction: action);
    final store = Store<AppState>(reducer, initialState: loggedInState());

    // When
    middleware.call(store, action, nextActionSpy.performAction);

    // Then
    expect(nextActionSpy.wasCalled, true);
  });

  test("call when repository returns action list should dispatch loading and then success", () async {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(storeSpy.reducer, initialState: loggedInState());

    // When
    await middleware.call(store, action, (action) => {});

    // Then
    expect(storeSpy.actionsReceived, 2);
    expect(storeSpy.calledWithLoading, true);
    expect(storeSpy.calledWithSuccess, true);
  });

  test("call when repository returns null should dispatch loading and then failure", () async {
    // Given
    final middleware = UserActionMiddleware(UserActionRepositoryFailureStub());
    final storeSpy = StoreSpy();
    final store = Store<AppState>(storeSpy.reducer, initialState: loggedInState());

    // When
    await middleware.call(store, action, (action) => {});

    // Then
    expect(storeSpy.actionsReceived, 2);
    expect(storeSpy.calledWithLoading, true);
    expect(storeSpy.calledWithFailure, true);
  });
}

class StoreSpy {
  var actionsReceived = 0;
  var calledWithLoading = false;
  var calledWithSuccess = false;
  var calledWithFailure = false;

  AppState reducer(AppState currentState, dynamic action) {
    actionsReceived++;
    if (action is UserActionLoadingAction) {
      calledWithLoading = true;
    }
    if (action is UserActionSuccessAction && action.actions[0].id == "id") {
      calledWithSuccess = true;
    }
    if (action is UserActionFailureAction) {
      calledWithFailure = true;
    }
    return currentState;
  }
}
