import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';

import '../../doubles/stubs.dart';
import '../../dsl/app_state_dsl.dart';
import '../../dsl/sut_redux.dart';
import '../../utils/expects.dart';

void main() {
  final sut = StoreSut();
  sut.setSkipFirstChange(true);

  group("when todo", () {
    sut.when(() => UserActionCreateRequestAction(_request()));

    group("when request succeed", () {
      test("should display loading and success", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.pageActionRepository = PageActionRepositorySuccessStub()});
        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldSucceed]);
      });
      test("should update list", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.pageActionRepository = PageActionRepositorySuccessStub()});
        // TODO : ce test met en lumière le problème avec le emitInOrder. Qui n'est peut-être pas la bonne façon de faire.
        // Pourquoi ? Parce que lorsqu'un dispatch d'action provoque plusieurs autres dispatch d'action, ça peut faire changer beaucoup de fois le state pour d'autres raisons qu'on ne veut pas tester ici
        // Cf. user_action_create_middleware, on y dispatch pas mal de choses
        // Dailleurs je viens de voir un problème des tests actuels : on peut inverser l'ordre loadingState/successState, ça ne fail pas.
        sut.thenExpectChangingStatesInOrder(
            [_shouldLoad, _shouldSucceed, _shouldSucceed, _shouldLoadList, _shouldLoadList, _shouldUpdateList]);
      });
    });

    group("when request fail", () {
      test("should display loading and failure", () {
        sut.givenStore = givenState()
            .loggedInUser() //
            .store((f) => {f.pageActionRepository = PageActionRepositoryFailureStub()});
        sut.thenExpectChangingStatesInOrder([_shouldLoad, _shouldFail]);
      });
    });
  });
}

void _shouldLoad(AppState state) => expect(state.userActionCreateState, isA<UserActionCreateLoadingState>());

void _shouldFail(AppState state) => expect(state.userActionCreateState, isA<UserActionCreateFailureState>());

void _shouldSucceed(AppState state) => expect(state.userActionCreateState, isA<UserActionCreateSuccessState>());

void _shouldLoadList(AppState state) => expect(state.userActionListState, isA<UserActionListLoadingState>());

void _shouldUpdateList(AppState state) {
  expectTypeThen<UserActionListSuccessState>(state.userActionListState, (successState) {
    expect(successState.userActions, isNotEmpty);
  });
}

UserActionCreateRequest _request() {
  return UserActionCreateRequest(
    "content",
    "comment",
    DateTime.now(),
    true,
    UserActionStatus.NOT_STARTED,
  );
}
