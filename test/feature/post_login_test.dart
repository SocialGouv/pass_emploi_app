import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/login_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:redux/src/store.dart';

import '../doubles/fixtures.dart';
import '../redux/middlewares/register_push_notification_token_middleware_test.dart';
import '../utils/test_setup.dart';
import 'offre_emploi_favoris_test.dart';

main() {
  group("after login ...", () {
    final initialState = AppState.initialState().copyWith(loginState: LoginState.notLoggedIn());

    test("push notification token should be registered", () {
      // Given
      final tokenRepositorySpy = RegisterTokenRepositorySpy();
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
      testStoreFactory.registerTokenRepository = tokenRepositorySpy;
      final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);

      // When
      store.dispatch(LoggedInAction(mockUser(id: "1")));

      // Then
      expect(tokenRepositorySpy.wasCalled, true);
    });

    test("favoris id should be loaded", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
      final Store<AppState> store = testStoreFactory.initializeReduxStore(
        initialState: initialState,
      );

      final successState =
          store.onChange.firstWhere((element) => element.offreEmploiFavorisState is OffreEmploiFavorisLoadedState);

      // When
      store.dispatch(LoggedInAction(mockUser()));

      // Then
      final loadedFavoris = await successState;
      final favorisState = (loadedFavoris.offreEmploiFavorisState as OffreEmploiFavorisLoadedState);
      expect(favorisState.offreEmploiFavorisId, {"1", "2", "4"});
      expect(favorisState.data, null);
    });
  });
}
