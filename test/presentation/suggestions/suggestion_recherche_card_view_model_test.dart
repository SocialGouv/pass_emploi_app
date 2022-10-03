import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/accepter/accepter_suggestion_recherche_actions.dart';
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
    expect(viewModel, isNotNull);
    expect(viewModel?.type, "Emploi");
    expect(viewModel?.titre, "Cariste");
    expect(viewModel?.metier, "Conduite d'engins de déplacement des charges");
    expect(viewModel?.localisation, "Nord");
  });

  test("should be null without a suggestion", () {
    // Given
    final store = givenState().store();

    // When
    final viewModel = SuggestionRechercheCardViewModel.create(store, "void");

    // Then
    expect(viewModel, isNull);
  });

  test("should dispatch accepter suggestion", () {
    // Given
    final store = givenState().withSuggestionsRecherche().spyStore();
    final viewModel = SuggestionRechercheCardViewModel.create(store, suggestionCariste().id);

    // When
    viewModel?.ajouterSuggestion();

    // Then
    expect(viewModel, isNotNull);
    expect(store.dispatchedAction, AccepterSuggestionRechercheRequestAction(suggestionCariste()));
  });
}
