import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/models/commentaire.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/commentaires/action_commentaire_view_model.dart';

import '../../../doubles/spies.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../utils/test_datetime.dart';

void main() {
  test("when action has comments should display the last comment", () {
    // Given
    final store = givenState().actionWithComments().store();

    // When
    final viewModel = ActionCommentaireViewModel.create(store, 'id');

    // Then
    expect(
      viewModel.lastComment,
      Commentaire(
        id: "8802034",
        content: "Deuxieme commentaire",
        creationDate: parseDateTimeUtcWithCurrentTimeZone("2022-07-23T17:08:10.000"),
        createdByAdvisor: false,
        creatorName: null,
      ),
    );
  });
  test("when action has comments should display the last comment", () {
    // Given
    final store = givenState().actionWithoutComments().store();

    // When
    final viewModel = ActionCommentaireViewModel.create(store, 'id');

    // Then
    expect(viewModel.lastComment, null);
  });

  group("when ActionCommentaireState is ...", () {
    test("successful should set display state to CONTENT", () {
      // Given
      final store = givenState().actionWithoutComments().store();

      // When
      final viewModel = ActionCommentaireViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.contenu);
    });

    test("failure should set display state to FAILURE", () {
      // Given
      final store = givenState().actionCommentsFailureState().store();

      // When
      final viewModel = ActionCommentaireViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.erreur);
    });

    test("loading should set display state to LOADING", () {
      // Given
      final store = givenState().actionCommentsLoadingState().store();

      // When
      final viewModel = ActionCommentaireViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });

    test("not initialized should set display state to LOADING", () {
      // Given
      final store = givenState().actionCommentsNotInitState().store();

      // When
      final viewModel = ActionCommentaireViewModel.create(store, 'id');

      // Then
      expect(viewModel.displayState, DisplayState.chargement);
    });
  });

  test('when onRetry is performed ActionCommentaireListRequestAction is dispatched', () {
    // Given
    final store = StoreSpy();
    final viewModel = ActionCommentaireViewModel.create(store, 'id');

    // When
    viewModel.onRetry();

    // Then
    expect(store.dispatchedAction is ActionCommentaireListRequestAction, isTrue);
  });
}
