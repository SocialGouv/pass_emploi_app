import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/matchers.dart';
import '../../../dsl/sut_redux.dart';
import '../../../utils/test_setup.dart';

void main() {
  final sut = StoreSut();

  group("when creating commentaire action", () {
    sut.when(() => ActionCommentaireCreateRequestAction(actionId: "actionId", comment: "new comment"));

    group("given request succeed", () {
      void injectedRepository(TestStoreFactory? factory) {
        factory?.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub();
      }

      test("should load and display success", () {
        sut.givenStore = givenState().actionWithComments().loggedInMiloUser().store(injectedRepository);
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldSucceed()]);
      });

      test("should load and add commentaire in list", () {
        sut.givenStore = givenState().actionWithComments().loggedInMiloUser().store(injectedRepository);
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldAddCommentInList()]);
      });
    });

    group("given request fail", () {
      void injectedRepository(TestStoreFactory? factory) {
        factory?.actionCommentaireRepository = ActionCommentaireRepositoryFailureStub();
      }

      test("should load and display failure", () {
        sut.givenStore = givenState().actionWithComments().loggedInMiloUser().store(injectedRepository);
        sut.thenExpectChangingStatesThroughOrder([_shouldLoad(), _shouldFail()]);
      });
    });
  });
}

Matcher _shouldLoad() => StateIs<ActionCommentaireCreateLoadingState>((state) => state.actionCommentaireCreateState);

Matcher _shouldFail() {
  return StateIs<ActionCommentaireCreateFailureState>(
    (state) => state.actionCommentaireCreateState,
    (state) => expect(state.comment, "new comment"),
  );
}

Matcher _shouldSucceed() => StateIs<ActionCommentaireCreateSuccessState>((state) => state.actionCommentaireCreateState);

Matcher _shouldAddCommentInList() {
  return StateIs<ActionCommentaireListSuccessState>(
    (state) => state.actionCommentaireListState,
    (state) {
      expect(state.comments, isNotEmpty);
      expect(state.comments.last.content, "new comment");
    },
  );
}
