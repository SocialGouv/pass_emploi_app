import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/favori_list_v2_view_model.dart';

import '../../doubles/fixtures.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  group('displayState', () {
    test('when state is loading should display loading', () {
      // Given
      final store = givenState().favoriListV2LoadingState().store();

      // When
      final viewModel = FavoriListV2ViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.LOADING);
    });

    test('when state is failure should display failure', () {
      // Given
      final store = givenState().favoriListV2FailureState().store();

      // When
      final viewModel = FavoriListV2ViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.FAILURE);
    });

    test('when state is successful with result should display content', () {
      // Given
      final store = givenState().favoriListV2SuccessState([mockFavori()]).store();

      // When
      final viewModel = FavoriListV2ViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.CONTENT);
    });

    test('when state is successful without result should display empty', () {
      // Given
      final store = givenState().favoriListV2SuccessState([]).store();

      // When
      final viewModel = FavoriListV2ViewModel.create(store);

      // Then
      expect(viewModel.displayState, DisplayState.EMPTY);
    });
  });

  test('favoris should return favoris from state', () {
    // Given
    final favoris = [mockFavori()];
    final store = givenState().favoriListV2SuccessState(favoris).store();

    // When
    final viewModel = FavoriListV2ViewModel.create(store);

    // Then
    expect(viewModel.favoris, favoris);
  });

  test('onRetry should dispatch proper action', () {
    // Given
    final store = givenState().spyStore();
    final viewModel = FavoriListV2ViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<FavoriListV2RequestAction>());
  });
}
