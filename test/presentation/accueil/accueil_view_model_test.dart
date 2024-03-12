import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/repositories/local_outil_repository.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group("display state", (() {
    test('should be loading when accueil is loading', () {
      // Given
      final store = givenState().loggedInMiloUser().withAccueilLoading().store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('should be content when accueil is success', () {
      // Given
      final store = givenState().loggedInMiloUser().withAccueilMiloSuccess().store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('should be failure when accueil is failure', () {
      // Given
      final store = givenState().loggedInMiloUser().withAccueilFailure().store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });
  }));

  group('milo', () {
    test('should have all items', () {
      // Given
      final store = givenState() //
          .loggedInMiloUser()
          .withAccueilMiloSuccess()
          .withFeatureFlip(withCampagneRecrutement: true)
          .withCampagne(campagne())
          .store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(
        viewModel.items,
        [
          CampagneRecrutementCej(onDismiss: () {}),
          AccueilCampagneItem(titre: "Questionnaire", description: "Super test"),
          AccueilCetteSemaineItem(
            rendezvousCount: "3",
            actionsOuDemarchesCount: "1",
            actionsOuDemarchesLabel: "Action",
          ),
          AccueilProchainRendezvousItem(mockRendezvousMiloCV().id),
          AccueilEvenementsItem([
            (mockAnimationCollective().id, AccueilEvenementsType.animationCollective),
            (mockSessionMiloAtelierDecouverte().id, AccueilEvenementsType.sessionMilo),
          ]),
          AccueilAlertesItem(getMockedAlerte()),
          AccueilFavorisItem(mock3Favoris()),
          AccueilOutilsItem([
            Outils.diagoriente.withoutImage(),
            Outils.aides.withoutImage(),
            Outils.benevolatCej.withoutImage(),
          ]),
        ],
      );
    });

    test('should have prochaine session instead of prochain rendezvous when date is before', () {
      // Given
      final rdv = mockRendezvous(date: DateTime(2030));
      final sessionMilo = mockSessionMilo(dateDeDebut: DateTime(2025));
      final store = givenState() //
          .loggedInMiloUser()
          .withAccueilMiloSuccess(
            mockAccueilMilo().copyWith(
              prochainRendezVous: rdv,
              prochaineSessionMilo: sessionMilo,
              cetteSemaine: AccueilCetteSemaine(
                nombreRendezVous: 3,
                nombreActionsDemarchesARealiser: 2,
              ),
            ),
          )
          .withCampagne(campagne())
          .store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(
        viewModel.items,
        [
          AccueilCampagneItem(titre: "Questionnaire", description: "Super test"),
          AccueilCetteSemaineItem(
            rendezvousCount: "3",
            actionsOuDemarchesCount: "2",
            actionsOuDemarchesLabel: "Actions",
          ),
          AccueilProchaineSessionMiloItem(sessionMilo.id),
          AccueilEvenementsItem([
            (mockAnimationCollective().id, AccueilEvenementsType.animationCollective),
            (mockSessionMiloAtelierDecouverte().id, AccueilEvenementsType.sessionMilo),
          ]),
          AccueilAlertesItem(getMockedAlerte()),
          AccueilFavorisItem(mock3Favoris()),
          AccueilOutilsItem([
            Outils.diagoriente.withoutImage(),
            Outils.aides.withoutImage(),
            Outils.benevolatCej.withoutImage(),
          ]),
        ],
      );
    });
  });

  group('pe', () {
    test('should have all items', () {
      // Given
      final store = givenState() //
          .loggedInPoleEmploiUser()
          .withAccueilPoleEmploiSuccess()
          .withFeatureFlip(withCampagneRecrutement: true)
          .withCampagne(campagne())
          .store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(
        viewModel.items,
        [
          CampagneRecrutementCej(onDismiss: () {}),
          AccueilCampagneItem(titre: "Questionnaire", description: "Super test"),
          AccueilCetteSemaineItem(
            rendezvousCount: "3",
            actionsOuDemarchesCount: "1",
            actionsOuDemarchesLabel: "Démarche",
          ),
          AccueilProchainRendezvousItem(mockRendezvousPoleEmploi().id),
          AccueilAlertesItem(getMockedAlerte()),
          AccueilFavorisItem(mock3Favoris()),
          AccueilOutilsItem([
            Outils.diagoriente.withoutImage(),
            Outils.aides.withoutImage(),
            Outils.benevolatCej.withoutImage(),
          ]),
        ],
      );
    });
  });

  group('outils items…', () {
    test('on CEJ app should highlight Diagoriente and Aides', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().withAccueilPoleEmploiSuccess().store();
      final viewModel = AccueilViewModel.create(store);

      // When
      final outilsItem = viewModel.items.firstWhereOrNull((item) => item is AccueilOutilsItem);

      // Then
      expect(outilsItem, isNotNull);
      expect(
        (outilsItem as AccueilOutilsItem).outils,
        [
          Outils.diagoriente.withoutImage(),
          Outils.aides.withoutImage(),
          Outils.benevolatCej.withoutImage(),
        ],
      );
    });

    test('on BRSA app should highlight Diagoriente and Aides', () {
      // Given
      final store = givenBrsaState().loggedInPoleEmploiUser().withAccueilPoleEmploiSuccess().store();
      final viewModel = AccueilViewModel.create(store);

      // When
      final outilsItem = viewModel.items.firstWhereOrNull((item) => item is AccueilOutilsItem);

      // Then
      expect(outilsItem, isNotNull);
      expect(
        (outilsItem as AccueilOutilsItem).outils,
        [
          Outils.emploiSolidaire.withoutImage(),
          Outils.emploiStore.withoutImage(),
          Outils.benevolatBrsa.withoutImage(),
        ],
      );
    });
  });

  group('shouldResetDeeplink', () {
    group('should return true when deeplink only needs one page to be opened', () {
      test('ActionDeepLink > no double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(ActionDeepLink('id')).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isTrue);
      });

      test('RendezvousDeepLink > no double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(RendezvousDeepLink('id')).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isTrue);
      });

      test('SessionMiloDeepLink > no double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(SessionMiloDeepLink('id')).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isTrue);
      });

      test('FavorisDeepLink > no double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(FavorisDeepLink()).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isTrue);
      });

      test('AlertesDeepLink > no double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(AlertesDeepLink()).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isTrue);
      });
    });

    group('should return false when deeplink needs two pages to be opened', () {
      test('AlerteDeepLink > double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(AlerteDeepLink(idAlerte: 'id')).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isFalse);
      });
    });
  });

  test('should retry', () {
    // Given
    final store = StoreSpy();
    final viewModel = AccueilViewModel.create(store);

    // When
    viewModel.retry();

    // Then
    expect(store.dispatchedAction, isA<AccueilRequestAction>());
  });
}
