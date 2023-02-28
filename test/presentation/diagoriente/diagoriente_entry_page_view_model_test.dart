import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/diagoriente_metiers_favoris/diagoriente_metiers_favoris_state.dart';
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
    expectShowError(urlState: DiagorienteUrlsFailureState(), expected: true);
    expectShowError(urlState: DiagorienteUrlsLoadingState(), expected: false);
    expectShowError(urlState: DiagorienteUrlsSuccessState(mockDiagorienteUrls()), expected: false);
    expectShowError(urlState: DiagorienteUrlsNotInitializedState(), expected: false);

    expectShowError(favorisState: DiagorienteMetiersFavorisFailureState(), expected: true);
    expectShowError(favorisState: DiagorienteMetiersFavorisLoadingState(), expected: false);
    expectShowError(favorisState: DiagorienteMetiersFavorisSuccessState(true), expected: false);
    expectShowError(favorisState: DiagorienteMetiersFavorisNotInitializedState(), expected: false);
  });

  group('shouldDisableButtons', () {
    expectShouldDisableButtons(urlState: DiagorienteUrlsLoadingState(), expected: true);
    expectShouldDisableButtons(urlState: DiagorienteUrlsFailureState(), expected: false);
    expectShouldDisableButtons(urlState: DiagorienteUrlsSuccessState(mockDiagorienteUrls()), expected: false);
    expectShouldDisableButtons(urlState: DiagorienteUrlsNotInitializedState(), expected: false);

    expectShouldDisableButtons(favorisState: DiagorienteMetiersFavorisLoadingState(), expected: true);
    expectShouldDisableButtons(favorisState: DiagorienteMetiersFavorisFailureState(), expected: false);
    expectShouldDisableButtons(favorisState: DiagorienteMetiersFavorisSuccessState(true), expected: false);
    expectShouldDisableButtons(favorisState: DiagorienteMetiersFavorisNotInitializedState(), expected: false);
  });

  group('navigatingTo', () {
    expectNavigatingTo(DiagorienteUrlsFailureState(), null);
    expectNavigatingTo(DiagorienteUrlsLoadingState(), null);
    expectNavigatingTo(DiagorienteUrlsSuccessState(mockDiagorienteUrls()), DiagorienteNavigatingTo.chatBotPage);
    expectNavigatingTo(DiagorienteUrlsNotInitializedState(), null);
  });

  group("showMetiersFavoris", () {
    expectShowMetiersFavoris(DiagorienteMetiersFavorisSuccessState(true), true);
    expectShowMetiersFavoris(DiagorienteMetiersFavorisFailureState(), false);
    expectShowMetiersFavoris(DiagorienteMetiersFavorisLoadingState(), false);
    expectShowMetiersFavoris(DiagorienteMetiersFavorisNotInitializedState(), false);
  });
}

void expectShowError({
  DiagorienteUrlsState? urlState,
  DiagorienteMetiersFavorisState? favorisState,
  required bool expected,
}) {
  test('when state is $urlState + $favorisState then error should be $expected', () {
    // Given
    final store = givenState()
        .loggedInUser()
        .copyWith(
          diagorienteUrlsState: urlState,
          diagorienteMetiersFavorisState: favorisState,
        )
        .store();

    // When
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // Then
    expect(viewModel.showError, expected);
  });
}

void expectShouldDisableButtons({
  DiagorienteUrlsState? urlState,
  DiagorienteMetiersFavorisState? favorisState,
  required bool expected,
}) {
  test('when state is $urlState + $favorisState then shouldDisableButtons should be $expected', () {
    // Given
    final store = givenState()
        .loggedInUser()
        .copyWith(
          diagorienteUrlsState: urlState,
          diagorienteMetiersFavorisState: favorisState,
        )
        .store();

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

void expectShowMetiersFavoris(DiagorienteMetiersFavorisState state, bool expected) {
  test('when state is $state showMetiersFavoris should be $expected', () {
    // Given
    final store = givenState().loggedInUser().copyWith(diagorienteMetiersFavorisState: state).store();

    // When
    final viewModel = DiagorienteEntryPageViewModel.create(store);

    // Then
    expect(viewModel.showMetiersFavoris, expected);
  });
}
