import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test("comments should be fetched and displayed when screen loads", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub()});

    final displayedLoading =
        store.onChange.any((e) => e.actionCommentaireListState is ActionCommentaireListLoadingState);
    final successAppState =
        store.onChange.firstWhere((e) => e.actionCommentaireListState is ActionCommentaireListSuccessState);

    // When
    await store.dispatch(ActionCommentaireListRequestAction("actionId"));

    // Then
    expect(await displayedLoading, true);
    final appState = await successAppState;
    expect(appState.actionCommentaireListState is ActionCommentaireListSuccessState, isTrue);
    expect((appState.actionCommentaireListState as ActionCommentaireListSuccessState).comments.length, 2);
    expect((appState.actionCommentaireListState as ActionCommentaireListSuccessState).comments[0].content,
        "Deuxieme commentaire");
  });

  test("comments should display an error when fetching failed", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositoryFailureStub()});
    final displayedLoading =
        store.onChange.any((e) => e.actionCommentaireListState is ActionCommentaireListLoadingState);
    final failureAppState =
        store.onChange.firstWhere((e) => e.actionCommentaireListState is ActionCommentaireListFailureState);

    // When
    await store.dispatch(ActionCommentaireListRequestAction("actionId"));

    // Then
    expect(await displayedLoading, true);
    final appState = await failureAppState;
    expect(appState.actionCommentaireListState is ActionCommentaireListFailureState, isTrue);
  });
}
