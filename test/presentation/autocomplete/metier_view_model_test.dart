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
    expect(viewModel.metiersAutocomplete, [
      MetierSuggestionItem(metiers[0], MetierSource.autocomplete),
      MetierSuggestionItem(metiers[1], MetierSource.autocomplete),
      MetierSuggestionItem(metiers[2], MetierSource.autocomplete),
    ]);
  });

  group('suggestions métiers', () {
    test('with both metiers favoris and recherches recentes', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .withRecentsSearches(getMockedAlerte()) //
          .withDiagorientePreferencesMetierSuccessState(metiersFavoris: mockAutocompleteMetiers()) //
          .store();
      // When
      final result = MetierViewModel.create(store);
      // Then
      expect(result.metiersSuggestions, [
        MetierTitleItem("Dernière recherche"),
        MetierSuggestionItem(
          Metier(libelle: 'Boulangerie - viennoiserie', codeRome: 'D1102'),
          MetierSource.dernieresRecherches,
        ),
        MetierTitleItem("Vos préférences métiers"),
        MetierSuggestionItem(
          Metier(codeRome: "L1401", libelle: "Cavalier dresseur / Cavalière dresseuse de chevaux"),
          MetierSource.diagorienteMetiersFavoris,
        ),
        MetierSuggestionItem(
          Metier(codeRome: "A1416", libelle: "Céréalier / Céréalière"),
          MetierSource.diagorienteMetiersFavoris,
        ),
        MetierSuggestionItem(
          Metier(codeRome: "A1410", libelle: "Chevrier / Chevrière"),
          MetierSource.diagorienteMetiersFavoris,
        ),
      ]);
      expect(result.containsDiagorienteFavoris, true);
      expect(result.containsMetiersRecents, true);
    });

    test('with metiers favoris in alphabetic order', () {
      // Given
      final store = givenState() //
          .loggedIn() //
          .withRecentsSearches([]) //
          .withDiagorientePreferencesMetierSuccessState(metiersFavoris: mockAutocompleteMetiers()) //
          .store();
      // When
      final result = MetierViewModel.create(store);
      // Then
      expect(result.metiersSuggestions, [
        MetierTitleItem("Vos préférences métiers"),
        MetierSuggestionItem(
          Metier(codeRome: "L1401", libelle: "Cavalier dresseur / Cavalière dresseuse de chevaux"),
          MetierSource.diagorienteMetiersFavoris,
        ),
        MetierSuggestionItem(
          Metier(codeRome: "A1416", libelle: "Céréalier / Céréalière"),
          MetierSource.diagorienteMetiersFavoris,
        ),
        MetierSuggestionItem(
          Metier(codeRome: "A1410", libelle: "Chevrier / Chevrière"),
          MetierSource.diagorienteMetiersFavoris,
        ),
      ]);
      expect(result.containsDiagorienteFavoris, true);
      expect(result.containsMetiersRecents, false);
    });

    test('with empty recherches recentes', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.metiersSuggestions, []);
      expect(viewModel.containsDiagorienteFavoris, false);
      expect(viewModel.containsMetiersRecents, false);
    });

    test('with 1 recherche recente', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockImmersionAlerte(metier: "chevalier", codeRome: '1'),
      ]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.metiersSuggestions, [
        MetierTitleItem("Dernière recherche"),
        MetierSuggestionItem(Metier(libelle: 'chevalier', codeRome: '1'), MetierSource.dernieresRecherches),
      ]);
      expect(viewModel.containsDiagorienteFavoris, false);
      expect(viewModel.containsMetiersRecents, true);
    });

    test('with many recherches recentes should only take 3', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockImmersionAlerte(metier: '1', codeRome: '1'),
        mockImmersionAlerte(metier: '2', codeRome: '2'),
        mockImmersionAlerte(metier: '3', codeRome: '3'),
        mockImmersionAlerte(metier: '4', codeRome: '4'),
      ]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.metiersSuggestions, [
        MetierTitleItem("Dernières recherches"),
        MetierSuggestionItem(Metier(libelle: '1', codeRome: '1'), MetierSource.dernieresRecherches),
        MetierSuggestionItem(Metier(libelle: '2', codeRome: '2'), MetierSource.dernieresRecherches),
        MetierSuggestionItem(Metier(libelle: '3', codeRome: '3'), MetierSource.dernieresRecherches),
      ]);
    });

    test('with duplicated metiers in recherches recentes should remove them', () {
      // Given
      final store = givenState().loggedIn().withRecentsSearches([
        mockImmersionAlerte(metier: '1', codeRome: '1'),
        mockImmersionAlerte(metier: '2', codeRome: '2'),
        mockImmersionAlerte(metier: '1', codeRome: '1'),
      ]).store();
      // When
      final viewModel = MetierViewModel.create(store);
      // Then
      expect(viewModel.metiersSuggestions, [
        MetierTitleItem("Dernières recherches"),
        MetierSuggestionItem(Metier(libelle: '1', codeRome: '1'), MetierSource.dernieresRecherches),
        MetierSuggestionItem(Metier(libelle: '2', codeRome: '2'), MetierSource.dernieresRecherches),
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
