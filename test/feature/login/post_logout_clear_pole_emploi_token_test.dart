import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  test("After logout Pole Emploi auth token should be cleared", () async {
    // Given
    final initialState = AppState.initialState().copyWith(loginState: successPoleEmploiUserState());
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.poleEmploiTokenRepository.setPoleEmploiAuthToken(
      AuthTokenResponse(idToken: 'i', accessToken: 'a', refreshToken: 'r'),
    );
    final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

    // When
    await store.dispatch(RequestLogoutAction(LogoutRequester.USER));

    // Then
    expect(testStoreFactory.poleEmploiTokenRepository.getPoleEmploiAccessToken(), isNull);
  });
}
