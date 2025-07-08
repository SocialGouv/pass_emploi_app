import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/version.dart';
import 'package:pass_emploi_app/push/deep_link_factory.dart';

import '../../dsl/app_state_dsl.dart';
import '../../dsl/matchers.dart';
import '../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();
  final fixedDateTime = DateTime(2021);

  group('deep links should properly update state', () {
    void assertStateWithAction(dynamic action, DeepLinkState expectedState) {
      final testName = action is HandleDeepLinkAction
          ? "${action.runtimeType} ${action.deepLink.runtimeType} -> ${expectedState.runtimeType} with deeplink"
          : "${action.runtimeType} -> ${expectedState.runtimeType}";

      group("when dispatching…", () {
        sut.whenDispatchingAction(() => action);

        test(testName, () async {
          await withClock(Clock.fixed(fixedDateTime), () async {
            sut.givenStore = givenState().store();

            sut.thenExpectChangingStatesThroughOrder([_shouldHaveDeepLinkState(expectedState)]);
          });
        });
      });
    }

    void assertStateWithJson(
      Map<String, dynamic> json,
      DeepLink expectedDeepLink,
      DeepLinkOrigin origin,
    ) {
      final deepLink = DeepLinkFactory.fromJson(json);

      if (deepLink == null) {
        test("with $json", () {
          fail("Avec cet fonction assert, le JSON doit être un DeepLink valide. Sinon, utiliser un autre assert.");
        });
        return;
      }

      assertStateWithAction(
        HandleDeepLinkAction(deepLink, origin),
        HandleDeepLinkState(expectedDeepLink, origin),
      );
    }

    void assertDeepLinkIsNotExisting(String testName, Map<String, dynamic> json) {
      test(testName, () {
        final deepLink = DeepLinkFactory.fromJson(json);
        expect(deepLink, isNull);
      });
    }

    group('Deeplink from issuer…', () {
      group('Backend', () {
        assertStateWithJson(
          {"type": "NEW_ACTION", "id": "id"},
          ActionDeepLink('id'),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "DETAIL_ACTION", "id": "id"},
          ActionDeepLink('id'),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "NEW_MESSAGE"},
          NouveauMessageDeepLink(),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "NEW_RENDEZVOUS", "id": "id"},
          RendezvousDeepLink('id'),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "RAPPEL_RENDEZVOUS", "id": "id"},
          RendezvousDeepLink('id'),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "DETAIL_SESSION_MILO", "id": "id"},
          SessionMiloDeepLink('id'),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "NOUVELLE_OFFRE", "id": "id"},
          AlerteDeepLink(idAlerte: 'id'),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "RAPPEL_CREATION_DEMARCHE"},
          CreationDemarcheDeepLink(),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "RAPPEL_CREATION_ACTION"},
          CreationActionDeepLink(),
          DeepLinkOrigin.pushNotification,
        );
        assertStateWithJson(
          {"type": "CAMPAGNE"},
          CampagneDeepLink(),
          DeepLinkOrigin.pushNotification,
        );
      });

      group('Firebase', () {
        assertStateWithJson(
          {"type": "ACTUALISATION_PE"},
          ActualisationPeDeepLink(),
          DeepLinkOrigin.pushNotification,
        );

        assertStateWithJson(
          {"type": "NOUVELLES_FONCTIONNALITES", "version": "1.9.0"},
          NouvellesFonctionnalitesDeepLink(lastVersion: Version(1, 9, 0)),
          DeepLinkOrigin.pushNotification,
        );

        assertStateWithJson(
          {"type": "BENEVOLAT"},
          BenevolatDeepLink(),
          DeepLinkOrigin.pushNotification,
        );

        assertStateWithJson(
          {"type": "LA_BONNE_ALTERNANCE"},
          LaBonneAlternanceDeepLink(),
          DeepLinkOrigin.pushNotification,
        );
      });

      group('In app', () {
        assertStateWithJson(
          {"type": "DETAIL_RENDEZVOUS", "id": "id"},
          RendezvousDeepLink('id'),
          DeepLinkOrigin.inAppNavigation,
        );

        assertStateWithJson(
          {"type": "EVENT_LIST"},
          EventListDeepLink(),
          DeepLinkOrigin.inAppNavigation,
        );

        assertStateWithJson(
          {"type": "MON_SUIVI"},
          MonSuiviDeepLink(),
          DeepLinkOrigin.inAppNavigation,
        );

        assertStateWithJson(
          {"type": "RECHERCHE"},
          RechercheDeepLink(),
          DeepLinkOrigin.inAppNavigation,
        );

        assertStateWithJson(
          {"type": "OFFRES_ENREGISTREES"},
          OffresEnregistreesDeepLink(),
          DeepLinkOrigin.pushNotification,
        );

        assertStateWithJson(
          {"type": "OUTILS"},
          OutilsDeepLink(),
          DeepLinkOrigin.inAppNavigation,
        );
      });

      group('Unknown… Kept "just in case"', () {
        assertStateWithJson(
          {"type": "SAVED_SEARCHES"},
          AlertesDeepLink(),
          DeepLinkOrigin.pushNotification,
        );
      });
    });

    group('Obsolete deep links - not handled anymore', () {
      assertDeepLinkIsNotExisting(
        "Type NEW_ACTION without id",
        {"type": "NEW_ACTION"},
      );

      assertDeepLinkIsNotExisting(
        "Type DELETED_RENDEZVOUS without id",
        {"type": "DELETED_RENDEZVOUS"},
      );

      assertDeepLinkIsNotExisting(
        "Type DETAIL_SESSION_MILO without id",
        {"type": "DETAIL_SESSION_MILO"},
      );
    });

    group('Special cases', () {
      assertDeepLinkIsNotExisting(
        "with empty json",
        {},
      );
      assertDeepLinkIsNotExisting(
        "with unknown deeplink type",
        {"type": "UNKNOWN"},
      );

      withClock(Clock.fixed(fixedDateTime), () {
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
  });
}

Matcher _shouldHaveDeepLinkState(DeepLinkState expectedState) {
  return StateMatch((p0) => p0.deepLinkState == expectedState);
}
