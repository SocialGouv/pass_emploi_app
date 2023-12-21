import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/pages/demarche/demarche_list_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheListPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<DemarcheListItem> demarcheListItems;
  final bool isReloading;
  final Function() onRetry;

  DemarcheListPageViewModel({
    required this.displayState,
    required this.demarcheListItems,
    required this.isReloading,
    required this.onRetry,
  });

  factory DemarcheListPageViewModel.create(Store<AppState> store, [Filtre filtre = Filtre.aucun]) {
    final state = store.state.demarcheListState;
    final itemsSansFiltre = _activeDemarcheItems(state: state) + _inactiveDemarcheItems(state: state);
    final itemsEnRetard = _enRetardDemarcheItems(state: state);

    return DemarcheListPageViewModel(
      demarcheListItems: filtre == Filtre.aucun ? itemsSansFiltre : itemsEnRetard,
      displayState: _displayState(store.state),
      isReloading: state is DemarcheListReloadingState,
      onRetry: () => store.dispatch(DemarcheListRequestReloadAction(forceRefresh: true)),
    );
  }

  @override
  List<Object?> get props => [displayState, demarcheListItems, isReloading];
}

List<DemarcheListItem> _activeDemarcheItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) => [DemarcheStatus.pasCommencee, DemarcheStatus.enCours].contains(demarche.status))
        .map((demarche) => demarche.id)
        .map((e) => DemarcheListItem(e))
        .toList();
  }
  return [];
}

List<DemarcheListItem> _enRetardDemarcheItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) => [DemarcheStatus.pasCommencee, DemarcheStatus.enCours].contains(demarche.status))
        .where((demarche) => demarche.endDate != null)
        .where((demarche) => demarche.endDate!.isBefore(DateTime.now()))
        .map((demarche) => demarche.id)
        .map((e) => DemarcheListItem(e))
        .toList();
  }
  return [];
}

List<DemarcheListItem> _inactiveDemarcheItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) => [DemarcheStatus.terminee, DemarcheStatus.annulee].contains(demarche.status))
        .map((demarche) => demarche.id)
        .map((e) => DemarcheListItem(e))
        .toList();
  }
  return [];
}

DisplayState _displayState(AppState state) {
  final actionState = state.demarcheListState;
  if (actionState is DemarcheListSuccessState) {
    return actionState.demarches.isNotEmpty ? DisplayState.contenu : DisplayState.vide;
  } else if (actionState is DemarcheListFailureState) {
    return DisplayState.erreur;
  } else {
    return DisplayState.chargement;
  }
}

class DemarcheListItem extends Equatable {
  final String demarcheId;

  DemarcheListItem(this.demarcheId);

  @override
  List<Object?> get props => [demarcheId];
}
