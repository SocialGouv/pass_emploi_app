import 'package:flutter_test/flutter_test.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_list_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';

import '../../doubles/fixtures.dart';
import '../../doubles/spies.dart';
import '../../dsl/app_state_dsl.dart';

void main() {
  test(
      "Lorsque le bénéficaire a des démarches de différents statuts, "
      "mettre celles qui sont en cours ou non commencées en premier, puis celles qui sont terminées ou annulées.", () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
          demarcheListState: DemarcheListSuccessState(
            [
              uneDemarche(id: 'EN COURS', status: DemarcheStatus.enCours),
              uneDemarche(id: 'PAS COMMENCE', status: DemarcheStatus.pasCommencee),
              uneDemarche(id: 'TERMINEE', status: DemarcheStatus.terminee),
              uneDemarche(id: 'ANNULEE', status: DemarcheStatus.annulee),
              uneDemarche(id: 'EN COURS', status: DemarcheStatus.enCours),
              uneDemarche(id: 'PAS COMMENCE', status: DemarcheStatus.pasCommencee),
              uneDemarche(id: 'TERMINEE', status: DemarcheStatus.terminee),
              uneDemarche(id: 'ANNULEE', status: DemarcheStatus.annulee),
              uneDemarche(id: 'EN COURS', status: DemarcheStatus.enCours),
              uneDemarche(id: 'PAS COMMENCE', status: DemarcheStatus.pasCommencee),
              uneDemarche(id: 'TERMINEE', status: DemarcheStatus.terminee),
              uneDemarche(id: 'ANNULEE', status: DemarcheStatus.annulee),
            ],
          ),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.demarcheListItems.length, 12);

    for (var i = 0; i < 6; ++i) {
      expect((viewModel.demarcheListItems[i]).demarcheId, isIn(['EN COURS', 'PAS COMMENCE']));
    }
    for (var i = 6; i < 11; ++i) {
      expect((viewModel.demarcheListItems[i]).demarcheId, isIn(['TERMINEE', 'ANNULEE']));
    }
  });

  test("Quand le filtre en retard est présent, ne remonter que les démarches en retard", () {
    // Given
    final aujourdhui = DateTime.now();
    final demain = aujourdhui.add(Duration(days: 1));
    final hier = aujourdhui.subtract(Duration(days: 1));

    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
          demarcheListState: DemarcheListSuccessState(
            [
              uneDemarche(id: '', status: DemarcheStatus.enCours, endDate: demain),
              uneDemarche(id: 'EN RETARD 1', status: DemarcheStatus.enCours, endDate: hier),
              uneDemarche(id: '', status: DemarcheStatus.pasCommencee, endDate: demain),
              uneDemarche(id: 'EN RETARD 2', status: DemarcheStatus.pasCommencee, endDate: hier),
              uneDemarche(id: '', status: DemarcheStatus.terminee),
              uneDemarche(id: '', status: DemarcheStatus.annulee),
            ],
          ),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store, Filtre.enRetard);

    // Then
    expect(viewModel.demarcheListItems.length, 2);
    expect((viewModel.demarcheListItems[0]).demarcheId, 'EN RETARD 1');
    expect((viewModel.demarcheListItems[1]).demarcheId, 'EN RETARD 2');
  });

  test('create when demarche state is loading should display loader', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(demarcheListState: DemarcheListLoadingState())
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.chargement);
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
    expect(viewModel.displayState, DisplayState.chargement);
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
    expect(viewModel.displayState, DisplayState.erreur);
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

  test('create when demarche state is success but there are no demarche should display an empty message', () {
    // Given
    final store = givenState() //
        .loggedInPoleEmploiUser()
        .copyWith(
          demarcheListState: DemarcheListSuccessState([]),
        )
        .store();

    // When
    final viewModel = DemarcheListPageViewModel.create(store);

    // Then
    expect(viewModel.displayState, DisplayState.vide);
    expect(viewModel.demarcheListItems.length, 0);
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
    expect(viewModel.displayState, DisplayState.chargement);
  });
}
