import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step1_view_model.dart';

import '../../doubles/spies.dart';

void main() {
  test('onSearchDemarche should trigger action', () {
    // Given
    final store = StoreSpy();
    final viewModel = CreateDemarcheStep1ViewModel.create(store);

    // When
    viewModel.onSearchDemarche('query');

    // Then
    expect(store.dispatchedAction, isA<SearchDemarcheRequestAction>());
    expect((store.dispatchedAction as SearchDemarcheRequestAction).query, 'query');
  });
}
