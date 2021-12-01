import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/models/user.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/offre_emploi_favoris_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_favoris_repository.dart';
import 'package:pass_emploi_app/repositories/user_repository.dart';

import '../doubles/dummies.dart';
import '../utils/test_setup.dart';

main() {
  test("favoris id should be loaded at app startup when logged in", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.offreEmploiFavorisRepository = OffreEmploiFavorisRepositorySuccessStub();
    testStoreFactory.userRepository = UserRepositoryLoggedInStub();
    final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

    final successState =
        store.onChange.firstWhere((element) => element.offreEmploiFavorisState is OffreEmploiFavorisIdLoadedState);

    // When
    store.dispatch(BootstrapAction());

    // Then
    final loadedFavoris = await successState;
    final favorisState = (loadedFavoris.offreEmploiFavorisState as OffreEmploiFavorisIdLoadedState);
    expect(favorisState.offreEmploiFavorisListId, ["1", "2", "4"]);
  });
}

class OffreEmploiFavorisRepositorySuccessStub extends OffreEmploiFavorisRepository {
  OffreEmploiFavorisRepositorySuccessStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<List<String>?> getOffreEmploiFavorisId(String userId) async {
    return ["1", "2", "4"];
  }
}

class UserRepositoryLoggedInStub extends UserRepository {
  UserRepositoryLoggedInStub() : super("", DummyHttpClient(), DummyHeadersBuilder());

  Future<User?> getUser() async {
    return User(id: "id", firstName: "F", lastName: "L");
  }
}
