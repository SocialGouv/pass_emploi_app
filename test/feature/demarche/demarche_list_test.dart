import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  test("demarche should be fetched and displayed when screen loads", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageDemarcheRepository = PageDemarcheRepositorySuccessStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.demarcheListState is DemarcheListLoadingState);
    final successAppState = store.onChange.firstWhere((e) => e.demarcheListState is DemarcheListSuccessState);

    // When
    await store.dispatch(DemarcheListRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.demarcheListState is DemarcheListSuccessState, isTrue);
    expect((appState.demarcheListState as DemarcheListSuccessState).demarches.length, 1);
    expect((appState.demarcheListState as DemarcheListSuccessState).demarches[0].id, "id");
  });

  test("demarche should display an error when fetching failed", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    testStoreFactory.pageDemarcheRepository = PageDemarcheRepositoryFailureStub();
    final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());

    final displayedLoading = store.onChange.any((e) => e.demarcheListState is DemarcheListLoadingState);
    final failureAppState = store.onChange.firstWhere((e) => e.demarcheListState is DemarcheListFailureState);

    // When
    await store.dispatch(DemarcheListRequestAction());

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.demarcheListState is DemarcheListFailureState, isTrue);
  });
}
