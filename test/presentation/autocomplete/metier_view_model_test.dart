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
      MetiersAutocompleteSuggestionItem(metiers[0]),
      MetiersAutocompleteSuggestionItem(metiers[1]),
      MetiersAutocompleteSuggestionItem(metiers[2]),
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
        MetiersAutocompleteTitleItem("Dernière recherche"),
        MetiersAutocompleteSuggestionItem(Metier(libelle: 'chevalier', codeRome: '1')),
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
        MetiersAutocompleteTitleItem("Dernières recherches"),
        MetiersAutocompleteSuggestionItem(Metier(libelle: '1', codeRome: '1')),
        MetiersAutocompleteSuggestionItem(Metier(libelle: '2', codeRome: '2')),
        MetiersAutocompleteSuggestionItem(Metier(libelle: '3', codeRome: '3')),
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
        MetiersAutocompleteTitleItem("Dernières recherches"),
        MetiersAutocompleteSuggestionItem(Metier(libelle: '1', codeRome: '1')),
        MetiersAutocompleteSuggestionItem(Metier(libelle: '2', codeRome: '2')),
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
