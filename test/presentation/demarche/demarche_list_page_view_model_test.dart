import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/campagne/campagne_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test('create when demarche state is loading should display loader', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(demarcheListState: DemarcheListLoadingState())
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when demarche state is not initialized should display loader', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(demarcheListState: DemarcheListNotInitializedState())
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });

  test('create when demarche state is a failure should display failure', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(demarcheListState: DemarcheListFailureState())
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.FAILURE);
  });

  test('retry, after view model was created with failure, should dispatch a DemarcheListRequestAction', () {
    // Given
    final storeSpy = StoreSpy();
    final viewModel = DemarcheListPageViewModel.create(storeSpy);

    // When
    viewModel.onRetry();

    // Then
    expect(storeSpy.dispatchedAction, isA<DemarcheListRequestReloadAction>());
  });

  test(
      "create when demarche state is success with active, retarded, done, cancelled demarche and campagne should sort it correctly and put campagne in first position",
      () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
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
          ),
          campagneState: CampagneState(campagne(), []),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.items.length, 13);
    expect(viewModel.items.first, isA<DemarcheCampagneItem>());

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
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
          demarcheListState: DemarcheListSuccessState([]),
          campagneState: CampagneState(null, []),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.EMPTY);
    expect(viewModel.items.length, 0);
  });

  test('create when demarche state is success but there are no demarches but a campagne should display a campagne card',
      () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
          demarcheListState: DemarcheListSuccessState([]),
          campagneState: CampagneState(campagne(), []),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.CONTENT);
    expect(viewModel.items.length, 1);
    expect(viewModel.items.first, isA<DemarcheCampagneItem>());
  });

  test("should display technical message when data are not up to date", () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
          demarcheListState: DemarcheListSuccessState([], DateTime(2023, 1, 1)),
          campagneState: CampagneState(null, []),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.items.first, isA<DemarcheNotUpToDateItem>());
  });

  test('should be reloading on reload', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(demarcheListState: DemarcheListReloadingState())
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.isReloading, isTrue);
  });

  test('should display loading on reload state', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(demarcheListState: DemarcheListReloadingState())
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.LOADING);
  });
}
