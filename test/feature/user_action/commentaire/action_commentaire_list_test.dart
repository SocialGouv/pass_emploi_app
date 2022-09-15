import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../../doubles/stubs.dart';
import '../../../dsl/app_state_dsl.dart';
import '../../../dsl/sut_redux.dart';
import '../../../utils/expects.dart';

void main() {
  final sut = StoreSut();
  sut.setSkipFirstChange(true);

  group("when requesting list", () {
    sut.when(() => ActionCommentaireListRequestAction("actionId"));

    test("should display loading and list when fetching succeed", () {
      sut.givenStore = givenState()
          .loggedInMiloUser()
          .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositorySuccessStub()});

      sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldHaveCommentaireList]);
    });

    test("should display load and failure when fetching failed", () {
      sut.givenStore = givenState()
          .loggedInMiloUser()
          .store((factory) => {factory.actionCommentaireRepository = ActionCommentaireRepositoryFailureStub()});

      sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldFail]);
    });
  });
}

void _shouldLoad(AppState state) => expect(state.actionCommentaireListState, ActionCommentaireListLoadingState());

void _shouldFail(AppState state) => expect(state.actionCommentaireListState, ActionCommentaireListFailureState());

void _shouldHaveCommentaireList(AppState state) {
  expectTypeThen<ActionCommentaireListSuccessState>(state.actionCommentaireListState, (successState) {
    expect(successState.comments.length, 2);
    expect(successState.comments[0].content, "Premier commentaire");
  });
}
