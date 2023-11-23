import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/alerte/get/alerte_get_action.dart';
import 'package:pass_emploi_app/presentation/alerte_card_view_model.dart';

import '../doubles/fixtures.dart';
import '../dsl/app_state_dsl.dart';
import '../utils/expects.dart';

void main() {
  test('fetchAlerteResult should dispatch FetchAlerteResultsAction with saved search', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = AlerteCardViewModel.create(store);

    // When
    viewModel.fetchAlerteResult(mockOffreEmploiAlerte());

    // Then
    expectTypeThen<FetchAlerteResultsAction>(store.dispatchedAction, (action) {
      expect(action.alerte, mockOffreEmploiAlerte());
    });
  });
}
