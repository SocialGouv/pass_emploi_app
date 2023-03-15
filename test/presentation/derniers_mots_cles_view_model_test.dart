import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/derniers_mots_cles_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('create view model with empty recherches recentes', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, []);
  });

  test('create view model with 1 recherche recente', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([
      mockOffreEmploiSavedSearch(keyword: "chevalier"),
    ]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, [
      DerniersMotsClesAutocompleteTitleItem("Dernière recherche"),
      DerniersMotsClesAutocompleteSuggestionItem("chevalier"),
    ]);
  });

  test('create view model with many recherche recente should only take 3', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([
      mockOffreEmploiSavedSearch(keyword: "1"),
      mockOffreEmploiSavedSearch(keyword: "2"),
      mockOffreEmploiSavedSearch(keyword: "3"),
      mockOffreEmploiSavedSearch(keyword: "4"),
    ]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, [
      DerniersMotsClesAutocompleteTitleItem("Dernières recherches"),
      DerniersMotsClesAutocompleteSuggestionItem("1"),
      DerniersMotsClesAutocompleteSuggestionItem("2"),
      DerniersMotsClesAutocompleteSuggestionItem("3"),
    ]);
  });

  test('create view model with duplicated keywords in dernières recherches should remove them', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([
      mockOffreEmploiSavedSearch(keyword: "1"),
      mockOffreEmploiSavedSearch(keyword: "2"),
      mockOffreEmploiSavedSearch(keyword: "1"),
    ]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, [
      DerniersMotsClesAutocompleteTitleItem("Dernières recherches"),
      DerniersMotsClesAutocompleteSuggestionItem("1"),
      DerniersMotsClesAutocompleteSuggestionItem("2"),
    ]);
  });

  test('create view model with null keyword in dernières recherches should remove them', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([
      mockOffreEmploiSavedSearch(keyword: "1"),
      mockOffreEmploiSavedSearch(keyword: null),
      mockOffreEmploiSavedSearch(keyword: "2"),
    ]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, [
      DerniersMotsClesAutocompleteTitleItem("Dernières recherches"),
      DerniersMotsClesAutocompleteSuggestionItem("1"),
      DerniersMotsClesAutocompleteSuggestionItem("2"),
    ]);
  });
}
