import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/firebase_auth_wrapper.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/src/store.dart';

import '../../utils/test_setup.dart';

main() {
  test("After logout user should be signed out from Firebase Auth", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final firebaseAuthWrapperSpy = FirebaseAuthWrapperSpy();
    testStoreFactory.firebaseAuthWrapper = firebaseAuthWrapperSpy;
    final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

    // When
    await store.dispatch(RequestLogoutAction(LogoutRequester.USER));

    // Then
    expect(firebaseAuthWrapperSpy.signOutHasBeenCalled, isTrue);
  });
}

class FirebaseAuthWrapperSpy extends FirebaseAuthWrapper {
  bool signOutHasBeenCalled = false;

  @override
  Future<void> signOut() async {
    signOutHasBeenCalled = true;
    return;
  }
}
