import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/mots_cles_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';

void main() {
  test('create view model without recherches recentes and without metiers favoris', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .withRecentsSearches([]) //
        .withDiagorientePreferencesMetierSuccessState(metiersFavoris: []) //
        .store();
    // When
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, []);
    expect(result.containsDiagorienteFavoris, false);
    expect(result.containsMotsClesRecents, false);
  });

  test('create view model with metiers favoris in alphabetic order', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .withRecentsSearches([]) //
        .withDiagorientePreferencesMetierSuccessState(metiersFavoris: mockAutocompleteMetiers()) //
        .store();
    // When
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Vos préférences métiers"),
      MotsClesSuggestionItem(
          "Cavalier dresseur / Cavalière dresseuse de chevaux", MotCleSource.diagorienteMetiersFavoris),
      MotsClesSuggestionItem("Céréalier / Céréalière", MotCleSource.diagorienteMetiersFavoris),
      MotsClesSuggestionItem("Chevrier / Chevrière", MotCleSource.diagorienteMetiersFavoris),
    ]);
    expect(result.containsDiagorienteFavoris, true);
    expect(result.containsMotsClesRecents, false);
  });

  test('create view model with both metiers favoris and recherches recentes', () {
    // Given
    final store = givenState() //
        .loggedInUser() //
        .withRecentsSearches(getMockedSavedSearch()) //
        .withDiagorientePreferencesMetierSuccessState(metiersFavoris: mockAutocompleteMetiers()) //
        .store();
    // When
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Vos préférences métiers"),
      MotsClesSuggestionItem(
          "Cavalier dresseur / Cavalière dresseuse de chevaux", MotCleSource.diagorienteMetiersFavoris),
      MotsClesSuggestionItem("Céréalier / Céréalière", MotCleSource.diagorienteMetiersFavoris),
      MotsClesSuggestionItem("Chevrier / Chevrière", MotCleSource.diagorienteMetiersFavoris),
      MotsClesTitleItem("Dernières recherches"),
      MotsClesSuggestionItem("Boulangerie", MotCleSource.recherchesRecentes),
      MotsClesSuggestionItem("Flutter", MotCleSource.recherchesRecentes),
    ]);
    expect(result.containsDiagorienteFavoris, true);
    expect(result.containsMotsClesRecents, true);
  });

  test('create view model with 1 recherche recente', () {
    // Given
    final store = givenState().loggedInUser().withRecentsSearches([
      mockOffreEmploiSavedSearch(keyword: "chevalier"),
    ]).store();
    // When
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Dernière recherche"),
      MotsClesSuggestionItem("chevalier", MotCleSource.recherchesRecentes),
    ]);
    expect(result.containsDiagorienteFavoris, false);
    expect(result.containsMotsClesRecents, true);
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
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Dernières recherches"),
      MotsClesSuggestionItem("1", MotCleSource.recherchesRecentes),
      MotsClesSuggestionItem("2", MotCleSource.recherchesRecentes),
      MotsClesSuggestionItem("3", MotCleSource.recherchesRecentes),
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
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Dernières recherches"),
      MotsClesSuggestionItem("1", MotCleSource.recherchesRecentes),
      MotsClesSuggestionItem("2", MotCleSource.recherchesRecentes),
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
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Dernières recherches"),
      MotsClesSuggestionItem("1", MotCleSource.recherchesRecentes),
      MotsClesSuggestionItem("2", MotCleSource.recherchesRecentes),
    ]);
  });
}
