import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/events/event_tab_page_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  group('tabs', () {
    test('when login mode is PE should only display recherche tab', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = EventsTabPageViewModel.create(store);

      // Then
      expect(viewModel.tabs, [EventTab.rechercheExternes]);
    });

    test('when login mode is Milo should display milo and recherche tab', () {
      // Given
      final store = givenState().loggedInPoleEmploiUser().store();

      // When
      final viewModel = EventsTabPageViewModel.create(store);

      // Then
      expect(viewModel.tabs, [EventTab.rechercheExternes]);
    });
  });
}
