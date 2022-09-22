import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/service_civique_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test("shoud display suggestions recherche if suggestions exist", () {
    // Given
    final store = givenState().loggedInUser().withSuggestionsRecherche().store();

    // When
    final viewModel = ServiceCiviqueViewModel.create(store);

    // Then
    expect(viewModel.hasSuggestionsRecherche, true);
  });

  test("shoud hide suggestions recherche if empty", () {
    // Given
    final store = givenState().loggedInUser().emptySuggestionsRecherche().store();

    // When
    final viewModel = ServiceCiviqueViewModel.create(store);

    // Then
    expect(viewModel.hasSuggestionsRecherche, false);
  });

  test("shoud hide suggestions recherche if loading", () {
    // Given
    final store = givenState().loggedInUser().loadingSuggestionsRecherche().store();

    // When
    final viewModel = ServiceCiviqueViewModel.create(store);

    // Then
    expect(viewModel.hasSuggestionsRecherche, false);
  });

  test("shoud hide suggestions recherche if failed", () {
    // Given
    final store = givenState().loggedInUser().failedSuggestionsRecherche().store();

    // When
    final viewModel = ServiceCiviqueViewModel.create(store);

    // Then
    expect(viewModel.hasSuggestionsRecherche, false);
  });
}
