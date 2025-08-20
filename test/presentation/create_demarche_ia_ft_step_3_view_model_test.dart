import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/ia_ft_suggestions/ia_ft_suggestions_state.dart';
import 'package:pass_emploi_app/presentation/create_demarche_ia_ft_step_3_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../dsl/app_state_dsl.dart';

void main() {
  group('CreateDemarcheIaFtStep3ViewModel', () {
    test('should return loading when ia ft suggestions is initial', () {
      // Given
      final store =
          givenState().loggedInUser().copyWith(iaFtSuggestionsState: IaFtSuggestionsNotInitializedState()).store();

      // When
      final viewModel = CreateDemarcheIaFtStep3ViewModel.create(store);

      // Then
      expect(
        viewModel.loadDisplayState,
        DisplayState.LOADING,
      );
    });

    test('should return loading when ia ft suggestions is loading', () {
      // Given
      final store = givenState().loggedInUser().copyWith(iaFtSuggestionsState: IaFtSuggestionsLoadingState()).store();

      // When
      final viewModel = CreateDemarcheIaFtStep3ViewModel.create(store);

      // Then
      expect(
        viewModel.loadDisplayState,
        DisplayState.LOADING,
      );
    });

    test('should return error when ia ft suggestions is failure', () {
      // Given
      final store = givenState().loggedInUser().copyWith(iaFtSuggestionsState: IaFtSuggestionsFailureState()).store();

      // When
      final viewModel = CreateDemarcheIaFtStep3ViewModel.create(store);

      // Then
      expect(
        viewModel.loadDisplayState,
        DisplayState.FAILURE,
      );
    });

    test('should return content when ia ft suggestions is success', () {
      // Given
      final store = givenState().loggedInUser().copyWith(iaFtSuggestionsState: IaFtSuggestionsSuccessState([])).store();

      // When
      final viewModel = CreateDemarcheIaFtStep3ViewModel.create(store);

      // Then
      expect(
        viewModel.loadDisplayState,
        DisplayState.CONTENT,
      );
    });
  });
}
