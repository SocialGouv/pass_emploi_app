import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/location/search_location_actions.dart';
import 'package:pass_emploi_app/features/location/search_location_state.dart';
import 'package:pass_emploi_app/presentation/autocomplete/location_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('locations should return locations from state', () {
    // Given
    final locations = [mockLocation()];
    final store = givenState().copyWith(searchLocationState: SearchLocationState(locations)).store();

    // When
    final viewModel = LocationViewModel.create(store);

    // Then
    expect(viewModel.locations, locations);
  });

  test('onInputLocation should dispatch proper action', () {
    // Given
    final store = StoreSpy();
    final viewModel = LocationViewModel.create(store);

    // When
    viewModel.onInputLocation('input', true);

    // Then
    expect(store.dispatchedAction, isA<SearchLocationRequestAction>());
    final action = store.dispatchedAction as SearchLocationRequestAction;
    expect(action.input, 'input');
    expect(action.villesOnly, true);
  });
}
