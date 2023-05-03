import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/saved_search/get/saved_search_get_action.dart';
import 'package:pass_emploi_app/presentation/saved_search_card_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';
import '../utils/expects.dart';

void main() {
  test('fetchSavedSearchResult should dispatch FetchSavedSearchResultsAction with saved search', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = SavedSearchCardViewModel.create(store);

    // When
    viewModel.fetchSavedSearchResult(mockOffreEmploiSavedSearch());

    // Then
    expectTypeThen<FetchSavedSearchResultsAction>(store.dispatchedAction, (action) {
      expect(action.savedSearch, mockOffreEmploiSavedSearch());
    });
  });
}
