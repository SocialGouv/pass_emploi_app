import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test("should have suggestions", () {
    // Given
    final store = givenState().withSuggestionsRecherche().store();

    // When
    final viewModel = SuggestionsRechercheListViewModel.create(store);

    // Then
    expect(viewModel.suggestions, mockSuggestionsRecherche());
  });
}
