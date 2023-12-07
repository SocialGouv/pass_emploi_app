import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/push/deep_link_factory.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../utils/test_setup.dart';

void main() {
  final fixedDateTime = DateTime(2021);

  group('deep links should properly update state', () {
    void assertStateWithAction(dynamic action, DeepLinkState expectedState) {
      final testName = action is HandleDeepLinkAction
          ? expectedState.runtimeType
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

    void assertStateWithJson(Map<String, dynamic> json, DeepLinkState expectedState) {
      final deepLink = DeepLinkFactory.fromJson(json)!;
      assertStateWithAction(HandleDeepLinkAction(deepLink, DeepLinkOrigin.pushNotification), expectedState);
    }

    void assertDeepLinkIsnotExisting(String testName, Map<String, dynamic> json) {
      test(testName, () {
        final deepLink = DeepLinkFactory.fromJson(json);
        expect(deepLink, isNull);
      });
    }

    withClock(Clock.fixed(fixedDateTime), () async {
      assertDeepLinkIsnotExisting(
        "with empty json",
        {},
      );
      assertDeepLinkIsnotExisting(
        "with unknown deeplink type",
        {"type": "UNKNOWN"},
      );
      assertStateWithJson(
        {"type": "FAVORIS"},
        HandleDeepLinkState(FavorisDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "SAVED_SEARCHES"},
        HandleDeepLinkState(AlertesDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "RECHERCHE"},
        HandleDeepLinkState(RechercheDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "OUTILS"},
        HandleDeepLinkState(OutilsDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "AGENDA"},
        HandleDeepLinkState(AgendaDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "NEW_ACTION"},
        HandleDeepLinkState(DetailActionDeepLink(idAction: null), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "NEW_ACTION", "id": "id"},
        HandleDeepLinkState(DetailActionDeepLink(idAction: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "DETAIL_ACTION", "id": "id"},
        HandleDeepLinkState(DetailActionDeepLink(idAction: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "NEW_MESSAGE"},
        HandleDeepLinkState(NouveauMessageDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "EVENT_LIST"},
        HandleDeepLinkState(EventListDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "ACTUALISATION_PE"},
        HandleDeepLinkState(ActualisationPeDeepLink(), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "DELETED_RENDEZVOUS"},
        HandleDeepLinkState(DetailRendezvousDeepLink(idRendezvous: null), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "DETAIL_RENDEZVOUS", "id": "id"},
        HandleDeepLinkState(DetailRendezvousDeepLink(idRendezvous: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "NEW_RENDEZVOUS", "id": "id"},
        HandleDeepLinkState(DetailRendezvousDeepLink(idRendezvous: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "RAPPEL_RENDEZVOUS", "id": "id"},
        HandleDeepLinkState(DetailRendezvousDeepLink(idRendezvous: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "DETAIL_SESSION_MILO", "id": "id"},
        HandleDeepLinkState(DetailSessionMiloDeepLink(idSessionMilo: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "NOUVELLE_OFFRE", "id": "id"},
        HandleDeepLinkState(AlerteDeepLink(idAlerte: 'id'), DeepLinkOrigin.pushNotification),
      );
      assertStateWithJson(
        {"type": "NOUVELLES_FONCTIONNALITES", "version": "1.9.0"},
        HandleDeepLinkState(
          NouvellesFonctionnalitesDeepLink(lastVersion: Version(1, 9, 0)),
          DeepLinkOrigin.pushNotification,
        ),
      );
      assertStateWithAction(
        ResetDeeplinkAction(),
        UsedDeepLinkState(),
      );
      assertStateWithAction(
        FetchAlerteResultsFromIdAction(''),
        UsedDeepLinkState(),
      );
    });
  });
}
