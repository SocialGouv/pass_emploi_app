import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/derniers_mots_cles_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test('create view model with empty mots cles', () {
    // Given
    final store = givenState().loggedInUser().withRecherchesDerniersMotsCles([]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, []);
  });

  test('create view model with 1 mot clé', () {
    // Given
    final store = givenState().loggedInUser().withRecherchesDerniersMotsCles(["chevalier"]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, [
      DerniersMotsClesAutocompleteTitleItem("Dernière recherche"),
      DerniersMotsClesAutocompleteSuggestionItem("chevalier"),
    ]);
  });

  test('create view model with mots cles', () {
    // Given
    final store = givenState().loggedInUser().withRecherchesDerniersMotsCles(["chevalier", "roi"]).store();
    // When
    final result = DerniersMotsClesViewModel.create(store);
    // Then
    expect(result.derniersMotsCles, [
      DerniersMotsClesAutocompleteTitleItem("Dernières recherches"),
      DerniersMotsClesAutocompleteSuggestionItem("chevalier"),
      DerniersMotsClesAutocompleteSuggestionItem("roi"),
    ]);
  });
}
