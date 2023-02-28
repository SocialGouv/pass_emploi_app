import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_actions.dart';
import 'package:pass_emploi_app/features/diagoriente_urls/diagoriente_urls_state.dart';
import 'package:pass_emploi_app/presentation/diagoriente/diagoriente_entry_page_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('navigatingTo should dispatch DiagorienteUrlsRequestAction', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // When
    viewModel.requestUrls();

    // Then
    expect(store.dispatchedAction, isA<DiagorienteUrlsRequestAction>());
  });

  group('showError', () {
    expectShowError(DiagorienteUrlsFailureState(), true);
    expectShowError(DiagorienteUrlsLoadingState(), false);
    expectShowError(DiagorienteUrlsSuccessState(mockDiagorienteUrls()), false);
    expectShowError(DiagorienteUrlsNotInitializedState(), false);
  });

  group('shouldDisableButtons', () {
    expectShouldDisableButtons(DiagorienteUrlsFailureState(), false);
    expectShouldDisableButtons(DiagorienteUrlsLoadingState(), true);
    expectShouldDisableButtons(DiagorienteUrlsSuccessState(mockDiagorienteUrls()), false);
    expectShouldDisableButtons(DiagorienteUrlsNotInitializedState(), false);
  });

  group('navigatingTo', () {
    expectNavigatingTo(DiagorienteUrlsFailureState(), null);
    expectNavigatingTo(DiagorienteUrlsLoadingState(), null);
    expectNavigatingTo(DiagorienteUrlsSuccessState(mockDiagorienteUrls()), DiagorienteNavigatingTo.chatBotPage);
    expectNavigatingTo(DiagorienteUrlsNotInitializedState(), null);
  });
}

void expectShowError(DiagorienteUrlsState state, bool expected) {
  test('when state is $state show error should be $expected', () {
    // Given
    final store = givenState().loggedInUser().copyWith(diagorienteUrlsState: state).store();

    // When
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // Then
    expect(viewModel.showError, expected);
  });
}

void expectShouldDisableButtons(DiagorienteUrlsState state, bool expected) {
  test('when state is $state shouldDisableButtons should be $expected', () {
    // Given
    final store = givenState().loggedInUser().copyWith(diagorienteUrlsState: state).store();

    // When
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // Then
    expect(viewModel.shouldDisableButtons, expected);
  });
}

void expectNavigatingTo(DiagorienteUrlsState state, DiagorienteNavigatingTo? expected) {
  test('when state is $state navigatingTo should be $expected', () {
    // Given
    final store = givenState().loggedInUser().copyWith(diagorienteUrlsState: state).store();

    // When
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // Then
    expect(viewModel.navigatingTo, expected);
  });
}
