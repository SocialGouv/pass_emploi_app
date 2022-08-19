import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/presentation/agenda/agenda_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('should display loading', () {
    // Given
    final store = givenState().loggedInUser().copyWith(agendaState: AgendaLoadingState()).store();

    // When
    final viewModel = AgendaPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });
}
