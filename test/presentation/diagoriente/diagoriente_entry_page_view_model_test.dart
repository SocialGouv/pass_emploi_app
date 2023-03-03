import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../dsl/app_state_dsl.dart';

void main() {
  test('onRetry should dispatch DiagorienteUrlsRequestAction', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<DiagorientePreferencesMetierRequestAction>());
  });

  group('withMetiersFavoris', () {
    test('should be true when success state has favoris', () {
      // Given
      final store = givenState() //
          .loggedInUser()
          .diagorientePreferencesMetierSuccessState(aDesMetiersFavoris: true)
          .store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.withMetiersFavoris, true);
    });

    test('should be false when success state does not have favoris', () {
      // Given
      final store = givenState() //
          .loggedInUser()
          .diagorientePreferencesMetierSuccessState(aDesMetiersFavoris: false)
          .store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.withMetiersFavoris, false);
    });
  });

  group('displayState', () {
    test('when diagoriente preferences metier state is not initialized should return initial', () {
      // Given
      final store = givenState().loggedInUser().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when diagoriente preferences metier state is loading should display loading', () {
      // Given
      final store = givenState().loggedInUser().diagorientePreferencesMetierLoadingState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when diagoriente preferences metier state is failure should display failure', () {
      // Given
      final store = givenState().loggedInUser().diagorientePreferencesMetierFailureState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when diagoriente preferences metier state is success should display chat bot page', () {
      // Given
      final store = givenState().loggedInUser().diagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });
}
