import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list/favori_list_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/src/store.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';
import '../favoris/offre_emploi_favoris_test.dart';

main() {
  test("after login, favoris id should be loaded", () async {
    // Given
    final initialState = AppState.initialState().copyWith(loginState: LoginFailureState());
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
    final Store<AppState> store = testStoreFactory.initializeReduxStore(initialState: initialState);
    final successState = store.onChange.firstWhere(
      (e) => e.offreEmploiFavorisState is FavoriListLoadedState<OffreEmploi>,
    );

    // When
    store.dispatch(LoginSuccessAction(mockUser()));

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.offreEmploiFavorisState as FavoriListLoadedState<OffreEmploi>);
    expect(favorisState.favoriIds, {"1", "2", "4"});
    expect(favorisState.data, null);
  });
}
