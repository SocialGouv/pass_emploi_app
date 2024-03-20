import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/configuration_application_repository.dart';
import 'package:redux/src/store.dart';

import '../../doubles/dio_mock.dart';
import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../doubles/mocks.dart';
import '../../utils/test_setup.dart';
import '../favoris/offre_emploi_favoris_test.dart';

void main() {
  test("push notification token should be registered", () async {
    // Given
    final initialState = AppState.initialState().copyWith(loginState: LoginGenericFailureState(''));
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

class _RegisterTokenRepositorySpy extends ConfigurationApplicationRepository {
  bool wasCalled = false;

  _RegisterTokenRepositorySpy() : super(DioMock(), DummyFirebaseInstanceIdGetter(), MockPushNotificationManager());

  @override
  Future<void> configureApplication(String userId, String fuseauHoraire) async {
    expect(userId, "1");
    wasCalled = true;
  }
}
