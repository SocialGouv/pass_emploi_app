import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/redux/actions/deep_link_action.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';

import '../utils/test_setup.dart';

void main() {
  group("deep links actions should properly update state", () {
    void assertState(DeepLinkAction action, DeepLinkState expectedState) {
      test("$action -> $expectedState", () async {
        // Given
        final testStoreFactory = TestStoreFactory();
        final store = testStoreFactory.initializeReduxStore(initialState: AppState.initialState());

        // When
        final outputAppState = store.onChange.firstWhere((element) => element.deepLinkState is DeepLinkState);
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
  });
}

bool _isNearlySameAs(DateTime d1, DateTime d2) => d1.difference(d2).inSeconds < 1;
