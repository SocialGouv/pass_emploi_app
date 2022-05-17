import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../utils/test_setup.dart';

void main() {
  group("deep links actions should properly update state", () {
    void assertState(DeepLinkAction action, DeepLinkState expectedState) {
      test("${action.message.data["type"]} -> ${expectedState.deepLink}",
          () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        final store = testStoreFactory.initializeReduxStore(
            initialState: AppState.initialState());

        // When
        final outputAppState = store.onChange.first;
        await store.dispatch(action);

        // Then
        final appState = await outputAppState;
        expect(appState.deepLinkState.deepLink, expectedState.deepLink);
        expect(_isNearlySameAs(appState.deepLinkState.deepLinkOpenedAt, expectedState.deepLinkOpenedAt), true);
      });
    }

    assertState(
      DeepLinkAction(RemoteMessage()),
      DeepLinkState(DeepLink.NOT_SET, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "UNKNOWN"})),
      DeepLinkState(DeepLink.NOT_SET, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "NEW_ACTION"})),
      DeepLinkState(DeepLink.ROUTE_TO_ACTION, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "NEW_MESSAGE"})),
      DeepLinkState(DeepLink.ROUTE_TO_CHAT, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "NEW_RENDEZVOUS"})),
      DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "DELETED_RENDEZVOUS"})),
      DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "RAPPEL_RENDEZVOUS"})),
      DeepLinkState(DeepLink.ROUTE_TO_RENDEZVOUS, DateTime.now()),
    );
    assertState(
      DeepLinkAction(RemoteMessage(data: {"type": "NOUVELLE_OFFRE", "id": "Bonjour je suis un id"})),
      DeepLinkState(DeepLink.SAVED_SEARCH_RESULTS, DateTime.now(), "Bonjour je suis un id"),
    );
  });

  test("notification en foreground", () async {
    // Given
    final testStoreFactory = TestStoreFactory();
    final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

    // When
    final outputAppState = store.onChange.first;
    await store.dispatch(LocalDeeplinkAction({"type": "NOUVELLE_OFFRE", "id": "Bonjour je suis un id"}));

    // Then
    final expectedState = DeepLinkState(DeepLink.SAVED_SEARCH_RESULTS, DateTime.now(), "Bonjour je suis un id");
    final appState = await outputAppState;
    expect(appState.deepLinkState.deepLink, expectedState.deepLink);
    expect(_isNearlySameAs(appState.deepLinkState.deepLinkOpenedAt, expectedState.deepLinkOpenedAt), true);
  });
}

bool _isNearlySameAs(DateTime d1, DateTime d2) => d1.difference(d2).inSeconds < 1;
