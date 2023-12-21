import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/commentaires/action_commentaire_page_view_model.dart';

import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  group("send display state ...", () {
    test("is empty when ActionCommentCreateState is not initialized", () {
      // Given
      final store = givenState().createCommentNotInitState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.sendDisplayState, DisplayState.vide);
    });

    test("is loading when ActionCommentCreateState is loading", () {
      // Given
      final store = givenState().createCommentLoadingState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.sendDisplayState, DisplayState.chargement);
    });

    test("should show content when ActionCommentCreateState succeeds", () {
      // Given
      final store = givenState().createCommentSuccessState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.sendDisplayState, DisplayState.contenu);
    });

    test("should display an error when ActionCommentCreateState failed", () {
      // Given
      final store = givenState().createCommentFailureState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.sendDisplayState, DisplayState.erreur);
    });
  });

  group("When ActionCommentaireCreateState succeeds list display state ...", () {
    test("is loading when ActionCommentListState is not initialized", () {
      // Given
      final store = givenState().createCommentSuccessState().actionCommentsNotInitState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.chargement);
    });

    test("is loading when ActionCommentListState is loading", () {
      // Given
      final store = givenState().createCommentSuccessState().actionCommentsLoadingState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.chargement);
    });

    test("should show content when ActionCommentListState succeeds", () {
      // Given
      final store = givenState().createCommentSuccessState().actionWithComments().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.contenu);
    });

    test("should display an error when ActionCommentListState failed", () {
      // Given
      final store = givenState().createCommentSuccessState().actionCommentsFailureState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.listDisplayState, DisplayState.erreur);
    });
  });

  group('errorOnSend is...', () {
    test('false when ActionCommentaireCreateState not failed', () {
      // Given
      final store = givenState().createCommentSuccessState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.errorOnSend, isFalse);
    });

    test('true when ActionCommentaireCreateState failed', () {
      // Given
      final store = givenState().createCommentFailureState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.errorOnSend, isTrue);
    });
  });

  group('Draft is...', () {
    test('saved when ActionCommentaireCreateState failed', () {
      // Given
      final store = givenState().createCommentSuccessState().store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.draft, isNull);
    });

    test('null when ActionCommentaireCreateState not failed', () {
      // Given
      final store = givenState().createCommentFailureState("failedComment").store();

      // When
      final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

      // Then
      expect(viewModel.draft, isNotNull);
      expect(viewModel.draft, "failedComment");
    });
  });

  test('onSend should dispatch ActionCommentaireCreateRequestAction', () {
    // Given
    final store = StoreSpy();
    final viewModel = ActionCommentairePageViewModel.create(store, "actionId");

    // When
    viewModel.onSend("new comment");

    // Then
    expect(store.dispatchedAction, isA<ActionCommentaireCreateRequestAction>());
    expect((store.dispatchedAction as ActionCommentaireCreateRequestAction).actionId, "actionId");
    expect((store.dispatchedAction as ActionCommentaireCreateRequestAction).comment, "new comment");
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
