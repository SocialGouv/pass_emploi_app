import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_PE/list/user_action_pe_list_actions.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/stubs.dart';
import '../../utils/test_setup.dart';

void main() {
  group('On Milo user', () {
    test("campagne should be fetched and displayed if any", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final repository = PageActionRepositorySuccessStub();
      repository.withCampagne(campagne('id-campagne'));
      testStoreFactory.pageActionRepository = repository;
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInMiloState());
      final successAppState = store.onChange.firstWhere((e) => e.campagneState.campagne != null);

      // When
      await store.dispatch(UserActionListRequestAction());

      // Then
      final appState = await successAppState;
      expect(appState.campagneState.campagne!.id, 'id-campagne');
    });
  });

  group('On Pôle Emploi user', () {
    test("campagne should be fetched and displayed if any", () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final repository = PageActionPERepositorySuccessStub();
      repository.withCampagne(campagne('id-campagne'));
      testStoreFactory.pageActionPERepository = repository;
      final store = testStoreFactory.initializeReduxStore(initialState: loggedInPoleEmploiState());
      final successAppState = store.onChange.firstWhere((e) => e.campagneState.campagne != null);

      // When
      await store.dispatch(UserActionPEListRequestAction());

      // Then
      final appState = await successAppState;
      expect(appState.campagneState.campagne!.id, 'id-campagne');
    });
  });
}
