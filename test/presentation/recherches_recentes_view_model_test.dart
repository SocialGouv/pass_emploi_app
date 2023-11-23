import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/recherches_recentes_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('should not display recents searches when there is no recent search', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([]).store();
    // When
    final viewModel = RecherchesRecentesViewModel.create(store);
    // Then
    expect(viewModel.rechercheRecente, null);
  });

  test('should display recents searches', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches(getMockedAlerte()).store();
    // When
    final viewModel = RecherchesRecentesViewModel.create(store);
    // Then
    expect(viewModel.rechercheRecente, getMockedAlerte().first);
  });

  test('should only display recents offer searches', () {
    // Given
    final searches = getMockedAlerte();
    searches.insert(0, mockEvenementEmploiAlerte());
    final store = givenState().loggedInUser().withRecentsSearches(searches).store();
    // When
    final viewModel = RecherchesRecentesViewModel.create(store);
    // Then
    expect(viewModel.rechercheRecente, getMockedAlerte().first);
  });
}
