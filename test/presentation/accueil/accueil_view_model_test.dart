import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
import 'package:pass_emploi_app/models/accompagnement.dart';
import 'package:pass_emploi_app/models/accueil/accueil.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

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
          .showRating()
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
          RatingAppItem(),
          CampagneRecrutementItem(onDismiss: () {}),
          CampagneEvaluationItem(titre: "Questionnaire", description: "Super test"),
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
            Outil.mesAidesFt.withoutImage(),
            Outil.benevolatCej.withoutImage(),
            Outil.formation.withoutImage(),
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
          CampagneEvaluationItem(titre: "Questionnaire", description: "Super test"),
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
            Outil.mesAidesFt.withoutImage(),
            Outil.benevolatCej.withoutImage(),
            Outil.formation.withoutImage(),
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
          CampagneRecrutementItem(onDismiss: () {}),
          CampagneEvaluationItem(titre: "Questionnaire", description: "Super test"),
          AccueilCetteSemaineItem(
            rendezvousCount: "3",
            actionsOuDemarchesCount: "1",
            actionsOuDemarchesLabel: "Démarche",
          ),
          AccueilProchainRendezvousItem(mockRendezvousPoleEmploi().id),
          AccueilAlertesItem(getMockedAlerte()),
          AccueilFavorisItem(mock3Favoris()),
          AccueilOutilsItem([
            Outil.mesAidesFt.withoutImage(),
            Outil.benevolatCej.withoutImage(),
            Outil.formation.withoutImage(),
          ]),
        ],
      );
    });
  });

  group('outils items…', () {
    test('on CEJ accompagnement should highlight Mes Aides FT, Benevolat CEJ and Formations', () {
      // Given
      final store = givenState() //
          .loggedInUser(accompagnement: Accompagnement.cej)
          .withAccueilPoleEmploiSuccess()
          .store();
      final viewModel = AccueilViewModel.create(store);

      // When
      final outilsItem = viewModel.items.firstWhereOrNull((item) => item is AccueilOutilsItem);

      // Then
      expect(outilsItem, isNotNull);
      expect(
        (outilsItem as AccueilOutilsItem).outils,
        [
          Outil.mesAidesFt.withoutImage(),
          Outil.benevolatCej.withoutImage(),
          Outil.formation.withoutImage(),
        ],
      );
    });

    test('on AIJ accompagnement should highlight Mes Aides FT, Benevolat Pass emploi and Formations', () {
      // Given
      final store = givenState() //
          .loggedInUser(accompagnement: Accompagnement.aij)
          .withAccueilPoleEmploiSuccess()
          .store();
      final viewModel = AccueilViewModel.create(store);

      // When
      final outilsItem = viewModel.items.firstWhereOrNull((item) => item is AccueilOutilsItem);

      // Then
      expect(outilsItem, isNotNull);
      expect(
        (outilsItem as AccueilOutilsItem).outils,
        [
          Outil.mesAidesFt.withoutImage(),
          Outil.benevolatPassEmploi.withoutImage(),
          Outil.formation.withoutImage(),
        ],
      );
    });

    test('on RSA accompagnement should highlight Mes Aides FT, Emploi solidaire and Emploi store', () {
      // Given
      final store = givenState() //
          .loggedInUser(accompagnement: Accompagnement.rsaFranceTravail)
          .withAccueilPoleEmploiSuccess()
          .store();
      final viewModel = AccueilViewModel.create(store);

      // When
      final outilsItem = viewModel.items.firstWhereOrNull((item) => item is AccueilOutilsItem);

      // Then
      expect(outilsItem, isNotNull);
      expect(
        (outilsItem as AccueilOutilsItem).outils,
        [
          Outil.mesAidesFt.withoutImage(),
          Outil.emploiSolidaire.withoutImage(),
          Outil.emploiStore.withoutImage(),
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

      test('BenevolatDeepLink > no double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(BenevolatDeepLink()).store();

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

      test('RappelCreationDemarcheDeepLink > double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(RappelCreationDemarcheDeepLink()).store();

        // When
        final viewModel = AccueilViewModel.create(store);

        // Then
        expect(viewModel.shouldResetDeeplink, isFalse);
      });

      test('RappelCreationActionDeepLink > double opening of pages required', () {
        // Given
        final store = givenState().withHandleDeepLink(RappelCreationActionDeepLink()).store();

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
