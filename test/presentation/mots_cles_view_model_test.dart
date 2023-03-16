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
  });

  test('create view model with metiers favoris', () {
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
      MotsClesSuggestionItem("Chevrier / Chevrière"),
      MotsClesSuggestionItem("Céréalier / Céréalière"),
      MotsClesSuggestionItem("Cavalier dresseur / Cavalière dresseuse de chevaux"),
    ]);
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
      MotsClesSuggestionItem("Chevrier / Chevrière"),
      MotsClesSuggestionItem("Céréalier / Céréalière"),
      MotsClesSuggestionItem("Cavalier dresseur / Cavalière dresseuse de chevaux"),
      MotsClesTitleItem("Dernières recherches"),
      MotsClesSuggestionItem("Boulangerie"),
      MotsClesSuggestionItem("Flutter"),
    ]);
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
      MotsClesSuggestionItem("chevalier"),
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
    final result = MotsClesViewModel.create(store);
    // Then
    expect(result.motsCles, [
      MotsClesTitleItem("Dernières recherches"),
      MotsClesSuggestionItem("1"),
      MotsClesSuggestionItem("2"),
      MotsClesSuggestionItem("3"),
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
      MotsClesSuggestionItem("1"),
      MotsClesSuggestionItem("2"),
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
      MotsClesSuggestionItem("1"),
      MotsClesSuggestionItem("2"),
    ]);
  });
}
