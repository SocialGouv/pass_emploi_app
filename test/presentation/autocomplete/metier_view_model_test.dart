import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/models/metier.dart';
import 'package:pass_emploi_app/presentation/autocomplete/metier_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('metiers should return metiers from state', () {
    // Given
    final metiers = mockAutocompleteMetiers();
    final store = givenState().copyWith(searchMetierState: SearchMetierState(metiers)).store();

    // When
    final viewModel = MetierViewModel.create(store);

    // Then
    expect(viewModel.metiers, [
      MetiersSuggestionItem(metiers[0], MetierSource.autocomplete),
      MetiersSuggestionItem(metiers[1], MetierSource.autocomplete),
      MetiersSuggestionItem(metiers[2], MetierSource.autocomplete),
    ]);
  });

  group('derniers métiers', () {
    test('with empty recherches recentes', () {
      // Given
      final store = givenState().loggedInUser().withRecentsSearches([]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.derniersMetiers, []);
    });

    test('with 1 recherche recente', () {
      // Given
      final store = givenState().loggedInUser().withRecentsSearches([
        mockImmersionSavedSearch(metier: "chevalier", codeRome: '1'),
      ]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.derniersMetiers, [
        MetiersTitleItem("Dernière recherche"),
        MetiersSuggestionItem(Metier(libelle: 'chevalier', codeRome: '1'), MetierSource.derniersMetiers),
      ]);
    });

    test('with many recherche recente should only take 3', () {
      // Given
      final store = givenState().loggedInUser().withRecentsSearches([
        mockImmersionSavedSearch(metier: '1', codeRome: '1'),
        mockImmersionSavedSearch(metier: '2', codeRome: '2'),
        mockImmersionSavedSearch(metier: '3', codeRome: '3'),
        mockImmersionSavedSearch(metier: '4', codeRome: '4'),
      ]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.derniersMetiers, [
        MetiersTitleItem("Dernières recherches"),
        MetiersSuggestionItem(Metier(libelle: '1', codeRome: '1'), MetierSource.derniersMetiers),
        MetiersSuggestionItem(Metier(libelle: '2', codeRome: '2'), MetierSource.derniersMetiers),
        MetiersSuggestionItem(Metier(libelle: '3', codeRome: '3'), MetierSource.derniersMetiers),
      ]);
    });

    test('with duplicated metiers in dernières recherches should remove them', () {
      // Given
      final store = givenState().loggedInUser().withRecentsSearches([
        mockImmersionSavedSearch(metier: '1', codeRome: '1'),
        mockImmersionSavedSearch(metier: '2', codeRome: '2'),
        mockImmersionSavedSearch(metier: '1', codeRome: '1'),
      ]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.derniersMetiers, [
        MetiersTitleItem("Dernières recherches"),
        MetiersSuggestionItem(Metier(libelle: '1', codeRome: '1'), MetierSource.derniersMetiers),
        MetiersSuggestionItem(Metier(libelle: '2', codeRome: '2'), MetierSource.derniersMetiers),
      ]);
    });
  });

  test('onInputMetier should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = MetierViewModel.create(store);

    // When
    viewModel.onInputMetier('input');

    // Then
    expect(store.dispatchedAction, isA<SearchMetierRequestAction>());
    final action = store.dispatchedAction as SearchMetierRequestAction;
    expect(action.input, 'input');
  });
}
