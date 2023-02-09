import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/metier/search_metier_actions.dart';
import 'package:pass_emploi_app/features/metier/search_metier_state.dart';
import 'package:pass_emploi_app/presentation/autocomplete/metier_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('metiers should return metiers from state', () {
    // Given
    final metiers = mockAutocompleteMetiers();
    final store = givenState().copyWith(searchMetierState: SearchMetierState(metiers)).store();

    // When
    final viewModel = MetierViewModel.create(store);

    // Then
    expect(viewModel.metiers, metiers);
  });

  test('onInputMetier should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = MetierViewModel.create(store);

    // When
    viewModel.onInputMetier('input');

    // Then
    expect(store.dispatchedAction, isA<SearchMetierRequestAction>());
    final action = store.dispatchedAction as SearchMetierRequestAction;
    expect(action.input, 'input');
  });
}
