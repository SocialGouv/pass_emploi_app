import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("should be created with a suggestion", () {
    // Given
    final store = givenState().withSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionRechercheCardViewModel.create(store, suggestionCariste().id);

    // Then
    expect(viewModel, SuggestionRechercheCardViewModel(
      type: "Emploi",
      titre: "Cariste",
      metier: "Conduite d'engins de déplacement des charges",
      localisation: "Nord",
    ));
  });

  test("should be null without a suggestion", () {
    // Given
    final store = givenState().store();

    // When
    final viewModel = SuggestionRechercheCardViewModel.create(store, "void");

    // Then
    expect(viewModel, isNull);
  });
}
