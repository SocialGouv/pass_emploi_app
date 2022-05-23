import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_datetime.dart';

void main() {
  test('create when action state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionPEListState: UserActionPEListLoadingState()),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when action state is not initialized should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionPEListState: UserActionPEListNotInitializedState()),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when action state is a failure should display failure', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionPEListState: UserActionPEListFailureState()),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('retry, after view model was created with failure, should dispatch a RequestUserActionPEAction', () {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState().copyWith(userActionPEListState: UserActionPEListFailureState()),
    );
    final viewModel = UserActionPEListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.calledWithRetry, true);
  });

  test(
      "create when action state is success with active, retarded, done and cancelled actions should sort it correctly",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        userActionPEListState: UserActionPEListSuccessState(
          [
            _userAction(status: UserActionPEStatus.IN_PROGRESS),
            _userAction(status: UserActionPEStatus.NOT_STARTED),
            _userAction(status: UserActionPEStatus.RETARDED),
            _userAction(status: UserActionPEStatus.DONE),
            _userAction(status: UserActionPEStatus.CANCELLED),
            _userAction(status: UserActionPEStatus.IN_PROGRESS),
            _userAction(status: UserActionPEStatus.NOT_STARTED),
            _userAction(status: UserActionPEStatus.RETARDED),
            _userAction(status: UserActionPEStatus.DONE),
            _userAction(status: UserActionPEStatus.CANCELLED),
            _userAction(status: UserActionPEStatus.IN_PROGRESS),
            _userAction(status: UserActionPEStatus.NOT_STARTED),
            _userAction(status: UserActionPEStatus.RETARDED),
            _userAction(status: UserActionPEStatus.DONE),
            _userAction(status: UserActionPEStatus.CANCELLED),
          ],
        ),
      ),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 15);
    for (var i = 0; i < 3; ++i) {
      expect(viewModel.items[i].viewModel.status == UserActionPEStatus.RETARDED, isTrue);
    }

    for (var i = 3; i < 9; ++i) {
      expect(
          viewModel.items[i].viewModel.status == UserActionPEStatus.IN_PROGRESS ||
              viewModel.items[i].viewModel.status == UserActionPEStatus.NOT_STARTED,
          isTrue);
    }
    // 6 derniers => cancelled & done
    for (var i = 9; i < 15; ++i) {
      expect(viewModel.items[i].viewModel.status == UserActionPEStatus.DONE ||
          viewModel.items[i].viewModel.status == UserActionPEStatus.CANCELLED,
        isTrue);
    }
    // todo campagne
  });

  test('create when action state is success but there are no actions and no campagne neither should display an empty message', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionPEListState: UserActionPEListSuccessState([], null)),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.items.length, 0);
  });

  test('create when action state is success but there are no actions but a campagne should display a campagne card', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(userActionPEListState: UserActionPEListSuccessState([], campagne())),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items.length, 0);
    expect(viewModel.items[0] is UserActionPECampagneItemViewModel, isTrue);
  });
}

UserActionPE _userAction({required UserActionPEStatus status}) {
  return UserActionPE(
    id: "8802034",
    content: "Faire le CV",
    status: status,
    endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    createdByAdvisor: true,
  );
}

class StoreSpy {
  var calledWithRetry = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is UserActionPEListRequestAction) calledWithRetry = true;
    return currentState;
  }
}
