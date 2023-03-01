import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('onStartPressed should dispatch DiagorientePreferencesMetierRequestAction', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // When
    viewModel.requestUrls();

    // Then
    expect(store.dispatchedAction, isA<DiagorientePreferencesMetierRequestAction>());
  });

  group('displayState', () {
    test('when diagoriente urls state is not initialized should return initial', () {
      // Given
      final store = givenState().loggedInUser().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DiagorienteEntryPageDisplayState.initial);
    });

    test('when diagoriente urls state is loading should display loading', () {
      // Given
      final store = givenState().loggedInUser().diagorientePreferencesMetierLoadingState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DiagorienteEntryPageDisplayState.loading);
    });

    test('when diagoriente urls state is failure should display failure', () {
      // Given
      final store = givenState().loggedInUser().diagorientePreferencesMetierFailureState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DiagorienteEntryPageDisplayState.failure);
    });

    test('when diagoriente urls state is success should display chat bot page', () {
      // Given
      final store = givenState().loggedInUser().diagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DiagorienteEntryPageDisplayState.chatBotPage);
    });
  });
}
