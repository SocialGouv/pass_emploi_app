import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/commentaires/action_commentaire_page_view_model.dart';

import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group("When ActionCommentaireCreateState succeeds list display state ...", () {
    test("is loading when ActionCommentListState is not initialized", () {
      // Given
      final store = givenState().actionWithComments().actionCommentsNotInitState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.LOADING);
    });

    test("is loading when ActionCommentListState is loading", () {
      // Given
      final store = givenState().actionWithComments().actionCommentsLoadingState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.LOADING);
    });

    test("should show content when ActionCommentListState succeeds", () {
      // Given
      final store = givenState().actionWithComments().actionWithComments().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.CONTENT);
    });

    test("should display an error when ActionCommentListState failed", () {
      // Given
      final store = givenState().actionWithComments().actionCommentsFailureState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.FAILURE);
    });
  });

  test('onRetry should dispatch ActionCommentaireListRequestAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction, isA<ActionCommentaireListRequestAction>());
    expect((store.dispatchedAction as ActionCommentaireListRequestAction).actionId, "actionId");
  });
}
