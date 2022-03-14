import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/register_token_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';
import '../favoris/offre_emploi_favoris_test.dart';

main() {
  test("push notification token should be registered", () async {
    // Given
    final initialState = AppState.initialState().copyWith(loginState: LoginFailureState());
    final tokenRepositorySpy = _RegisterTokenRepositorySpy();
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
    testStoreFactory.registerTokenRepository = tokenRepositorySpy;
    final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

    // When
    await store.dispatch(LoginSuccessAction(mockUser(id: "1")));

    // Then
    expect(tokenRepositorySpy.wasCalled, true);
  });
}

class _RegisterTokenRepositorySpy extends RegisterTokenRepository {
  bool wasCalled = false;

  _RegisterTokenRepositorySpy() : super("", DummyHttpClient(), DummyHeadersBuilder(), DummyPushNotificationManager());

  @override
  Future<void> registerToken(String userId) async {
    expect(userId, "1");
    wasCalled = true;
  }
}
