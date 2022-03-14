import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/auth/auth_token_response.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/auth/pole_emploi/pole_emploi_auth_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

main() {
  group("after login ...", () {
    test("with a Pole Emploi user, Pole Emploi token should be fetched and set", () async {
      // Given
      final initialState = AppState.initialState().copyWith(loginState: LoginFailureState());
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.poleEmploiAuthRepository = PoleEmploiAuthRepositorySuccessStub();
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      await store.dispatch(LoginSuccessAction(mockUser(loginMode: LoginMode.POLE_EMPLOI)));

      // Then
      expect(testStoreFactory.poleEmploiTokenRepository.getPoleEmploiAccessToken(), 'accessToken');
    });

    test("with a user not from Pole Emploi, Pole Emploi token should be cleared", () async {
      // Given
      final initialState = AppState.initialState().copyWith(loginState: successPoleEmploiUserState());
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.poleEmploiTokenRepository.setPoleEmploiAuthToken(
        AuthTokenResponse(idToken: 'i', accessToken: 'a', refreshToken: 'r'),
      );
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      await store.dispatch(LoginSuccessAction(mockUser(loginMode: LoginMode.MILO)));

      // Then
      expect(testStoreFactory.poleEmploiTokenRepository.getPoleEmploiAccessToken(), isNull);
    });
  });
}

class PoleEmploiAuthRepositorySuccessStub extends PoleEmploiAuthRepository {
  PoleEmploiAuthRepositorySuccessStub() : super("", DummyHttpClient());

  @override
  Future<AuthTokenResponse?> getPoleEmploiToken() async {
    return AuthTokenResponse(idToken: 'idToken', accessToken: 'accessToken', refreshToken: 'refreshToken');
  }
}
