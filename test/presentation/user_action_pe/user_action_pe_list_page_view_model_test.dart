import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_list_page_view_model.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';
import '../../utils/test_datetime.dart';

void main() {
  test('create when demarche state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(demarcheListState: DemarcheListLoadingState()),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when demarche state is not initialized should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(demarcheListState: DemarcheListNotInitializedState()),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when demarche state is a failure should display failure', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(demarcheListState: DemarcheListFailureState()),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('retry, after view model was created with failure, should dispatch a DemarcheListRequestAction', () {
    // Given
    final storeSpy = StoreSpy();
    final store = Store<AppState>(
      storeSpy.reducer,
      initialState: loggedInState().copyWith(demarcheListState: DemarcheListFailureState()),
    );
    final viewModel = UserActionPEListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.calledWithRetry, true);
  });

  test(
      "create when demarche state is success with active, retarded, done, cancelled actions and campagne should sort it correctly and put campagne in first position",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        demarcheListState: DemarcheListSuccessState(
          [
            _demarche(status: DemarcheStatus.IN_PROGRESS),
            _demarche(status: DemarcheStatus.NOT_STARTED),
            _demarche(status: DemarcheStatus.DONE),
            _demarche(status: DemarcheStatus.CANCELLED),
            _demarche(status: DemarcheStatus.IN_PROGRESS),
            _demarche(status: DemarcheStatus.NOT_STARTED),
            _demarche(status: DemarcheStatus.DONE),
            _demarche(status: DemarcheStatus.CANCELLED),
            _demarche(status: DemarcheStatus.IN_PROGRESS),
            _demarche(status: DemarcheStatus.NOT_STARTED),
            _demarche(status: DemarcheStatus.DONE),
            _demarche(status: DemarcheStatus.CANCELLED),
          ],
          false,
        ),
        campagneState: CampagneState(campagne(), []),
      ),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 13);
    expect(viewModel.items[0] is UserActionPECampagneItemViewModel, isTrue);

    for (var i = 1; i < 7; ++i) {
      expect(
          (viewModel.items[i] as UserActionPEListItemViewModel).viewModel.status == DemarcheStatus.IN_PROGRESS ||
              (viewModel.items[i] as UserActionPEListItemViewModel).viewModel.status == DemarcheStatus.NOT_STARTED,
          isTrue);
    }
    // 6 derniers => cancelled & done
    for (var i = 7; i < 12; ++i) {
      final demarcheStatus = (viewModel.items[i] as UserActionPEListItemViewModel).viewModel.status;
      expect(demarcheStatus == DemarcheStatus.DONE || demarcheStatus == DemarcheStatus.CANCELLED, isTrue);
    }
  });

  test(
      'create when demarche state is success but there are no actions and no campagne neither should display an empty message',
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        demarcheListState: DemarcheListSuccessState([], false),
        campagneState: CampagneState(null, []),
      ),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.items.length, 0);
  });

  test('create when demarche state is success but there are no actions but a campagne should display a campagne card',
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        demarcheListState: DemarcheListSuccessState([], false),
        campagneState: CampagneState(campagne(), []),
      ),
    );

    // When
    final viewModel = UserActionPEListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items.length, 1);
    expect(viewModel.items[0] is UserActionPECampagneItemViewModel, isTrue);
  });
}

Demarche _demarche({required DemarcheStatus status}) {
  return Demarche(
    id: "8802034",
    content: "Faire le CV",
    status: status,
    endDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    deletionDate: parseDateTimeUtcWithCurrentTimeZone('2022-03-28T16:06:48.396Z'),
    createdByAdvisor: true,
    label: "label",
    possibleStatus: [],
    creationDate: DateTime(2022, 12, 23, 0, 0, 0),
    modifiedByAdvisor: false,
    sousTitre: "sous titre",
    titre: "titre",
    modificationDate: DateTime(2022, 12, 23, 0, 0, 0),
    attributs: [],
  );
}

class StoreSpy {
  var calledWithRetry = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is DemarcheListRequestAction) calledWithRetry = true;
    return currentState;
  }
}
