import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';

import '../utils/test_setup.dart';

void main() {
  test("State is reset on logout", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: AppState.initialState()
          .copyWith(loginState: LoginState.notLoggedIn(), rendezvousState: RendezvousState.loading()),
    );
    final result = store.onChange.firstWhere((element) => element is AppState);
    store.dispatch(LogoutAction());

    // When
    final AppState resultState = await result;

    // Then
    expect(resultState.loginState, isA<LoginNotInitializedState>());
    expect(resultState.rendezvousState, isA<RendezvousNotInitializedState>());
  });
}
