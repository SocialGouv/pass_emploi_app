import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_preferences_metier/diagoriente_preferences_metier_actions.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('onRetry should dispatch DiagorienteUrlsRequestAction and force no cache', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<DiagorientePreferencesMetierRequestAction>());
    final action = store.dispatchedAction as DiagorientePreferencesMetierRequestAction;
    expect(action.forceNoCacheOnFavoris, true);
  });

  group('withMetiersFavoris', () {
    test('should be true when success state has favoris', () {
      // Given
      final store = givenState() //
          .loggedIn()
          .withDiagorientePreferencesMetierSuccessState(metiersFavoris: mockAutocompleteMetiers())
          .store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.withMetiersFavoris, true);
    });

    test('should be false when success state does not have favoris', () {
      // Given
      final store = givenState() //
          .loggedIn()
          .withDiagorientePreferencesMetierSuccessState(metiersFavoris: []).store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.withMetiersFavoris, false);
    });
  });

  group('displayState', () {
    test('when diagoriente preferences metier state is not initialized should return initial', () {
      // Given
      final store = givenState().loggedIn().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when diagoriente preferences metier state is loading should display loading', () {
      // Given
      final store = givenState().loggedIn().withDiagorientePreferencesMetierLoadingState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when diagoriente preferences metier state is failure should display failure', () {
      // Given
      final store = givenState().loggedIn().withDiagorientePreferencesMetierFailureState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when diagoriente preferences metier state is success should display chat bot page', () {
      // Given
      final store = givenState().loggedIn().withDiagorientePreferencesMetierSuccessState().store();

      // When
      final viewModel = DiagorienteEntryPageViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });
  });
}
