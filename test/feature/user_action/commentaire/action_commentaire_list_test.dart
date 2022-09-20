import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/sut_redux.dart';

void main() {
  final sut = StoreSut();

  group("when requesting list", () {
    sut.when(() => ActionCommentaireListRequestAction("actionId"));

    test("should display loading and list when fetching succeed", () {
      sut.givenStore = givenState()
          .loggedInMiloUser()
          .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub()});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldHaveCommentaireList()]);
    });

    test("should display load and failure when fetching failed", () {
      sut.givenStore = givenState()
          .loggedInMiloUser()
          .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositoryFailureStub()});

      sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
    });
  });
}

Matcher _shouldLoad() => StateIs<ActionCommentaireListLoadingState>((state) => state.actionCommentaireListState);

Matcher _shouldFail() => StateIs<ActionCommentaireListFailureState>((state) => state.actionCommentaireListState);

Matcher _shouldHaveCommentaireList() {
  return StateIs<ActionCommentaireListSuccessState>(
    (state) => state.actionCommentaireListState,
    (state) {
      expect(state.comments.length, 2);
      expect(state.comments[0].content, "Premier commentaire");
    },
  );
}
