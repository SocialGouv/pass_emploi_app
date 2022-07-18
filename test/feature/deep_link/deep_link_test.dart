import 'package:clock/clock.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../utils/test_setup.dart';

void main() {
  final fixedDateTime = DateTime(2021);

  group('deep links actions should properly update state', () {
    void assertState(dynamic action, DeepLinkState expectedState) {
      final testName = action is DeepLinkAction
          ? "${action.message.data["type"]} -> ${expectedState.runtimeType}"
          : "${action.runtimeType} -> ${expectedState.runtimeType}";

      test(testName, () {
        withClock(Clock.fixed(fixedDateTime), () async {
          // Given
          final testStoreFactory = TestStoreFactory();
          final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

          // When
          final outputAppState = store.onChange.first;
          await store.dispatch(action);

          // Then
          final appState = await outputAppState;
          expect(appState.deepLinkState, expectedState);
        });
      });
    }

    withClock(Clock.fixed(fixedDateTime), () async {
      assertState(
        DeepLinkAction(RemoteMessage()),
        NotInitializedDeepLinkState(),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "UNKNOWN"})),
        NotInitializedDeepLinkState(),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "NEW_ACTION"})),
        DetailActionDeepLinkState(idAction: null),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "NEW_ACTION", "id": "id"})),
        DetailActionDeepLinkState(idAction: 'id'),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "NEW_MESSAGE"})),
        NouveauMessageDeepLinkState(),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "DELETED_RENDEZVOUS"})),
        DetailRendezvousDeepLinkState(idRendezvous: null),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "NEW_RENDEZVOUS", "id": "id"})),
        DetailRendezvousDeepLinkState(idRendezvous: 'id'),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "RAPPEL_RENDEZVOUS", "id": "id"})),
        DetailRendezvousDeepLinkState(idRendezvous: 'id'),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "NOUVELLE_OFFRE", "id": "id"})),
        SavedSearchDeepLinkState(idSavedSearch: 'id'),
      );
      assertState(
        DeepLinkAction(RemoteMessage(data: {"type": "NOUVELLES_FONCTIONNALITES", "version": "1.9.0"})),
        NouvellesFonctionnalitesDeepLinkState(lastVersion: Version(1, 9, 0)),
      );
      assertState(
        ResetDeeplinkAction(),
        NotInitializedDeepLinkState(),
      );
      assertState(
        SavedSearchGetAction(''),
        NotInitializedDeepLinkState(),
      );
    });
  });

  test("Notification en foreground", () async {
    withClock(Clock.fixed(fixedDateTime), () async {
      // Given
      final testStoreFactory = TestStoreFactory();
      final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

      // When
      final outputAppState = store.onChange.first;
      await store.dispatch(LocalDeeplinkAction({"type": "NOUVELLE_OFFRE", "id": "id"}));

      // Then
      final expectedState = SavedSearchDeepLinkState(idSavedSearch: 'id');
      final appState = await outputAppState;
      expect(appState.deepLinkState, expectedState);
    });
  });
}
