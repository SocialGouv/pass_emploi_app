import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/create/create_demarche_state.dart';

import '../../doubles/dummies.dart';
import '../../doubles/fixtures.dart';
import '../../utils/test_setup.dart';

void main() {
  test("when modifying a demarche, it should update create demarche state with success", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState(),
    );

    final displayedLoading = store.onChange.any((e) => e.createDemarcheState is CreateDemarcheLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.createDemarcheState is CreateDemarcheSuccessState);

    // When
    await store.dispatch(CreateDemarcheRequestAction("commentaire", DateTime(2022)));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.createDemarcheState is CreateDemarcheSuccessState, true);
  });

  test("when modifying a demarche with error, it should update create demarche state with failure", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.createDemarcheRepository = MockFailureCreateDemarcheRepository();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState(),
    );

    final displayedLoading = store.onChange.any((e) => e.createDemarcheState is CreateDemarcheLoadingState);
    final failureAppState = store.onChange.firstWhere((e) => e.createDemarcheState is CreateDemarcheFailureState);

    // When
    await store.dispatch(CreateDemarcheRequestAction("commentaire", DateTime(2022)));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.createDemarcheState is CreateDemarcheFailureState, true);
  });

  test("on reset action, demarche state is properly reset", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(
      initialState: loggedInPoleEmploiState().copyWith(createDemarcheState: CreateDemarcheSuccessState()),
    );

    // When
    await store.dispatch(CreateDemarcheResetAction());

    // Then
    expect(store.state.createDemarcheState is CreateDemarcheNotInitializedState, true);
  });
}

class MockFailureCreateDemarcheRepository extends DummySuccessCreateDemarcheRepository {
  @override
  Future<bool> createDemarche(String commentaire, DateTime dateEcheance, String userId) async {
    return false;
  }
}
