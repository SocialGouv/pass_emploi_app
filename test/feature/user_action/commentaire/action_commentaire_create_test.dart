import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/create/action_commentaire_create_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/sut_redux.dart';
import '../../../utils/expects.dart';
import '../../../utils/test_setup.dart';

void main() {
  final sut = StoreSut();
  sut.setSkipFirstChange(true);

  group("when creating commentaire action", () {
    sut.when(() => ActionCommentaireCreateRequestAction(actionId: "actionId", comment: "new comment"));

    group("given request succeed", () {
      void injectedRepository(TestStoreFactory? factory) {
        factory?.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub();
      }

      test("should load and display success", () {
        sut.givenStore = givenState().actionWithComments().loggedInMiloUser().store(injectedRepository);
        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldSucceed]);
      });

      test("should load and add commentaire in list", () {
        sut.givenStore = givenState().actionWithComments().loggedInMiloUser().store(injectedRepository);
        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldAddCommentInList]);
      });
    });

    group("given request fail", () {
      void injectedRepository(TestStoreFactory? factory) {
        factory?.actionCommentaireRepository = ActionCommentaireRepositoryFailureStub();
      }

      test("should load and display failure", () {
        sut.givenStore = givenState().actionWithComments().loggedInMiloUser().store(injectedRepository);
        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldFail]);
      });
    });
  });
}

void _shouldLoad(AppState state) => expect(state.actionCommentaireCreateState, ActionCommentaireCreateLoadingState());

void _shouldFail(AppState state) =>
    expect(state.actionCommentaireCreateState, ActionCommentaireCreateFailureState("new comment"));

void _shouldSucceed(AppState state) {
  expect(state.actionCommentaireCreateState, isA<ActionCommentaireCreateSuccessState>());
}

void _shouldAddCommentInList(AppState state) {
  expectTypeThen<ActionCommentaireListSuccessState>(state.actionCommentaireListState, (successState) {
    expect(successState.comments, isNotEmpty);
    expect(successState.comments.last.content, "new comment");
  });
}
