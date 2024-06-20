import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/presentation/voir_suggestions_recherche_view_model.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  test("shoud display suggestions recherche if suggestions exist", () {
    final store = givenState().loggedIn().withSuggestionsRecherche().store();
    final viewModel = VoirSuggestionsRechercheViewModel.create(store);
    expect(viewModel.hasSuggestionsRecherche, true);
  });

  test("shoud hide suggestions recherche if empty", () {
    final store = givenState().loggedIn().emptySuggestionsRecherche().store();
    final viewModel = VoirSuggestionsRechercheViewModel.create(store);
    expect(viewModel.hasSuggestionsRecherche, false);
  });

  test("shoud hide suggestions recherche if loading", () {
    final store = givenState().loggedIn().loadingSuggestionsRecherche().store();
    final viewModel = VoirSuggestionsRechercheViewModel.create(store);
    expect(viewModel.hasSuggestionsRecherche, false);
  });

  test("shoud hide suggestions recherche if failed", () {
    final store = givenState().loggedIn().failedSuggestionsRecherche().store();
    final viewModel = VoirSuggestionsRechercheViewModel.create(store);
    expect(viewModel.hasSuggestionsRecherche, false);
  });
}
