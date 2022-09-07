import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_reducer.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../doubles/fixtures.dart';

void main() {
  test('create when demarche state is loading should display loader', () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(demarcheListState: DemarcheListLoadingState()),
    );

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

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
    final viewModel = DemarcheListPageViewModel.create(store);

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
    final viewModel = DemarcheListPageViewModel.create(store);

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
    final viewModel = DemarcheListPageViewModel.create(store);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.calledWithRetry, true);
  });

  test(
      "create when demarche state is success with active, retarded, done, cancelled demarche and campagne should sort it correctly and put campagne in first position",
      () {
    // Given
    final store = Store<AppState>(
      reducer,
      initialState: loggedInState().copyWith(
        demarcheListState: DemarcheListSuccessState(
          [
            mockDemarche(id: 'IN_PROGRESS', status: DemarcheStatus.IN_PROGRESS),
            mockDemarche(id: 'NOT_STARTED', status: DemarcheStatus.NOT_STARTED),
            mockDemarche(id: 'DONE', status: DemarcheStatus.DONE),
            mockDemarche(id: 'CANCELLED', status: DemarcheStatus.CANCELLED),
            mockDemarche(id: 'IN_PROGRESS', status: DemarcheStatus.IN_PROGRESS),
            mockDemarche(id: 'NOT_STARTED', status: DemarcheStatus.NOT_STARTED),
            mockDemarche(id: 'DONE', status: DemarcheStatus.DONE),
            mockDemarche(id: 'CANCELLED', status: DemarcheStatus.CANCELLED),
            mockDemarche(id: 'IN_PROGRESS', status: DemarcheStatus.IN_PROGRESS),
            mockDemarche(id: 'NOT_STARTED', status: DemarcheStatus.NOT_STARTED),
            mockDemarche(id: 'DONE', status: DemarcheStatus.DONE),
            mockDemarche(id: 'CANCELLED', status: DemarcheStatus.CANCELLED),
          ],
          false,
        ),
        campagneState: CampagneState(campagne(), []),
      ),
    );

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 13);
    expect(viewModel.items[0] is DemarcheCampagneItemViewModel, isTrue);

    for (var i = 1; i < 7; ++i) {
      expect((viewModel.items[i] as IdItem).demarcheId, isIn(['IN_PROGRESS', 'NOT_STARTED']));
    }
    for (var i = 7; i < 12; ++i) {
      expect((viewModel.items[i] as IdItem).demarcheId, isIn(['DONE', 'CANCELLED']));
    }
  });

  test(
      'create when demarche state is success but there are no demarche and no campagne neither should display an empty message',
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
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.items.length, 0);
  });

  test('create when demarche state is success but there are no demarches but a campagne should display a campagne card',
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
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items.length, 1);
    expect(viewModel.items[0] is DemarcheCampagneItemViewModel, isTrue);
  });
}

class StoreSpy {
  var calledWithRetry = false;

  AppState reducer(AppState currentState, dynamic action) {
    if (action is DemarcheListRequestAction) calledWithRetry = true;
    return currentState;
  }
}
