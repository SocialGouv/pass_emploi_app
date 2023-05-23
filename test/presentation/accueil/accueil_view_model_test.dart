import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
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
      final store = givenState().loggedInMiloUser().withAccueilMiloSuccess().store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(
        viewModel.items,
        [
          AccueilCetteSemaineItem(
            monSuiviType: MonSuiviType.actions,
            rendezVous: "3 rendez-vous",
            actionsDemarchesEnRetard: "2 actions en retard",
            actionsDemarchesARealiser: "1 action à réaliser",
          ),
          AccueilProchainRendezvousItem(mockRendezvousMiloCV().id),
          AccueilEvenementsItem([mockAnimationCollective().id]),
          AccueilAlertesItem(getMockedSavedSearch()),
          AccueilFavorisItem(mock3Favoris()),
          AccueilOutilsItem([Outils.diagoriente.withoutImage(), Outils.aides.withoutImage()]),
        ],
      );
    });
  });

  group('pe', () {
    test('should have all items', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().withAccueilPoleEmploiSuccess().store();

      // When
      final viewModel = AccueilViewModel.create(store);

      // Then
      expect(
        viewModel.items,
        [
          AccueilCetteSemaineItem(
            monSuiviType: MonSuiviType.demarches,
            rendezVous: "3 rendez-vous",
            actionsDemarchesEnRetard: "2 démarches en retard",
            actionsDemarchesARealiser: "1 démarche à réaliser",
          ),
          AccueilProchainRendezvousItem(mockRendezvousPoleEmploi().id),
          AccueilAlertesItem(getMockedSavedSearch()),
          AccueilFavorisItem(mock3Favoris()),
          AccueilOutilsItem([Outils.diagoriente.withoutImage(), Outils.aides.withoutImage()]),
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
        [Outils.diagoriente.withoutImage(), Outils.aides.withoutImage()],
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
        [Outils.emploiSolidaire.withoutImage(), Outils.emploiStore.withoutImage()],
      );
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
