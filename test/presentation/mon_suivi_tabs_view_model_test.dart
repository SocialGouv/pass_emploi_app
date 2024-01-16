import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/mon_suivi_tabs_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('Create MonSuiviViewModel when user logged in…', () {
    test('via Pôle Emploi should set proper tabs', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = MonSuiviTabsViewModel.create(store);

      // Then
      expect(viewModel.tabs, [MonSuiviTab.AGENDA, MonSuiviTab.DEMARCHE, MonSuiviTab.RENDEZVOUS]);
      expect(viewModel.tabTitles, ['Cette semaine', 'Démarches', 'Rendez-vous']);
    });

    test('via Milo should set proper tabs', () {
      // Given
      final store = givenState().loggedInMiloUser().store();

      // When
      final viewModel = MonSuiviTabsViewModel.create(store);

      // Then
      expect(viewModel.tabs, [MonSuiviTab.AGENDA, MonSuiviTab.ACTIONS, MonSuiviTab.RENDEZVOUS]);
      expect(viewModel.tabTitles, ['Cette semaine', 'Actions', 'Rendez-vous']);
    });
  });

  test('MonSuiviViewModel.create with initial tab should return it', () {
    // Given
    final store = givenState().loggedInPoleEmploiUser().store();

    // When
    final viewModel = MonSuiviTabsViewModel.create(store, MonSuiviTab.RENDEZVOUS);

    // Then
    expect(viewModel.initialTabIndex, 2);
  });

  test('MonSuiviViewModel.create with initial tab should return it', () {
    // Given
    final store = givenState().withDemoMode().store();

    // When
    final viewModel = MonSuiviTabsViewModel.create(store);

    // Then
    expect(viewModel.isModeDemo, isTrue);
  });
}
