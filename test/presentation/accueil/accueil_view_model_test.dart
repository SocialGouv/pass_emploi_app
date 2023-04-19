import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/accueil/accueil_actions.dart';
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
        ],
      );
    });
  });

  group('pe', () {
    test('should have all items', () {
      // Given
      final store = givenState().loggedInMiloUser().withAccueilPoleEmploiSuccess().store();

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
          AccueilProchainRendezvousItem(mockRendezvousPoleEmploi().id),
          AccueilAlertesItem(getMockedSavedSearch()),
          AccueilFavorisItem(mock3Favoris()),
        ],
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
