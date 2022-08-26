import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/page_action_repository.dart';
import 'package:redux/redux.dart';

import '../../doubles/dummies.dart';
import '../../dsl/app_state_dsl.dart';
import '../../utils/expects.dart';
import '../../utils/test_setup.dart';

void main() {
  test("an unedited action should not update the list", () async {
    // Given
    final reducerSpy = _UpdateActionReducerSpy();
    final store = Store<AppState>(
      reducerSpy.reducer,
      initialState: givenState().loggedInUser().copyWith(
            userActionListState: UserActionListSuccessState(
              [
                _notStartedAction(actionId: "1"),
                _notStartedAction(actionId: "2"),
                _notStartedAction(actionId: "3"),
                _notStartedAction(actionId: "4"),
              ],
            ),
          ),
    );

    // When
    await store.dispatch(
      UserActionUpdateRequestAction(
        actionId: "3",
        newStatus: UserActionStatus.NOT_STARTED,
      ),
    );

    expect(reducerSpy.updateWasCalled, false);
  });

  group("an edited action should be updated", () {
    final actions = [
      _notStartedAction(actionId: "1"),
      _notStartedAction(actionId: "2"),
      _notStartedAction(actionId: "3"),
      _notStartedAction(actionId: "4"),
    ];

    final state = givenState() //
        .loggedInUser()
        .agenda(actions: actions, rendezvous: []).copyWith(userActionListState: UserActionListSuccessState(actions));

    final testStoreFactory = TestStoreFactory();
    final repositorySpy = PageActionRepositorySpy();
    testStoreFactory.pageActionRepository = repositorySpy;
    final store = testStoreFactory.initializeReduxStore(initialState: state);

    void whenUpdatingAction() async {
      await store.dispatch(
        UserActionUpdateRequestAction(
          actionId: "3",
          newStatus: UserActionStatus.DONE,
        ),
      );
    }

    test("on repository", () async {
      // When
      whenUpdatingAction();

      // Then
      expect(repositorySpy.isActionUpdated, true);
    });

    test("on user action update state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.userActionUpdateState is UserActionUpdatedState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expect(appState.userActionUpdateState is UserActionUpdatedState, isTrue);
    });

    test("on user action list state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.userActionListState is UserActionListSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expect(appState.userActionListState is UserActionListSuccessState, isTrue);
      expect((appState.userActionListState as UserActionListSuccessState).userActions[0].id, "3");
      expect((appState.userActionListState as UserActionListSuccessState).userActions[0].status, UserActionStatus.DONE);
    });

    test("on agenda state", () async {
      final successAppState = store.onChange.firstWhere((e) => e.agendaState is AgendaSuccessState);

      // When
      whenUpdatingAction();

      // Then
      final appState = await successAppState;
      expectTypeThen<AgendaSuccessState>(appState.agendaState, (agendaState) {
        expect(agendaState.agenda.actions[0].id, "3");
        expect(agendaState.agenda.actions[0].status, UserActionStatus.DONE);
      });
    });
  });
}

UserAction _notStartedAction({required String actionId}) {
  return UserAction(
    id: actionId,
    content: "content",
    comment: "comment",
    status: UserActionStatus.NOT_STARTED,
    dateEcheance: DateTime(2042),
    creator: JeuneActionCreator(),
  );
}

class PageActionRepositorySpy extends PageActionRepository {
  var isActionUpdated = false;

  PageActionRepositorySpy() : super("", DummyHttpClient());

  @override
  Future<void> updateActionStatus(String userId, String actionId, UserActionStatus newStatus) async {
    isActionUpdated = true;
  }
}

class _UpdateActionReducerSpy {
  var updateWasCalled = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionUpdateNeededAction) {
      updateWasCalled = true;
    }
    return currentState;
  }
}
