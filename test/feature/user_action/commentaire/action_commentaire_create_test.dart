import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';

void main() {
  test("create comment for action when repo succeeds should display loading and then create comment", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub()});
    final displayedLoading =
        store.onChange.any((e) => e.actionCommentaireCreateState is ActionCommentaireCreateLoadingState);
    final successAppState =
        store.onChange.firstWhere((e) => e.actionCommentaireCreateState is ActionCommentaireCreateSuccessState);

    // When
    store.dispatch(ActionCommentaireCreateRequestAction(actionId: "actionId", comment: "commentaire"));

    // Then
    expect(await displayedLoading, true);
    final success = await successAppState;
    expect(success.actionCommentaireCreateState is ActionCommentaireCreateSuccessState, isTrue);
  });

  test("create comment for action when repo succeeds refresh list of comments", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub()});
    final displayedLoading =
        store.onChange.any((e) => e.actionCommentaireListState is ActionCommentaireListLoadingState);
    final successAppState =
        store.onChange.firstWhere((e) => e.actionCommentaireListState is ActionCommentaireListSuccessState);

    // When
    store.dispatch(ActionCommentaireCreateRequestAction(actionId: "actionId", comment: "commentaire"));

    // Then
    expect(await displayedLoading, true);
    final success = await successAppState;
    expect(success.actionCommentaireListState is ActionCommentaireListSuccessState, isTrue);
    expect((success.actionCommentaireListState as ActionCommentaireListSuccessState).comments, isNotEmpty);
  });

  test("create comment for action when repo fails should display loading and then show failure", () async {
    // Given
    final store = givenState()
        .loggedInMiloUser()
        .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositoryFailureStub()});
    final displayedLoading =
        store.onChange.any((e) => e.actionCommentaireCreateState is ActionCommentaireCreateLoadingState);
    final failureAppState =
        store.onChange.firstWhere((e) => e.actionCommentaireCreateState is ActionCommentaireCreateFailureState);

    // When
    store.dispatch(ActionCommentaireCreateRequestAction(actionId: "actionId", comment: "commentaire"));

    // Then
    expect(await displayedLoading, true);
    final failure = await failureAppState;
    expect(failure.actionCommentaireCreateState is ActionCommentaireCreateFailureState, isTrue);
    expect((failure.actionCommentaireCreateState as ActionCommentaireCreateFailureState).comment, "commentaire");
  });
}
