import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheListPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<DemarcheListItem> items;
  final bool isReloading;
  final Function() onRetry;

  DemarcheListPageViewModel({
    required this.displayState,
    required this.items,
    this.isReloading = false,
    required this.onRetry,
  });

  factory DemarcheListPageViewModel.create(Store<AppState> store) {
    final state = store.state.demarcheListState;
    return DemarcheListPageViewModel(
      displayState: _displayState(store.state),
      items: _listItems(
        campagne: _campagneItem(state: store.state),
        activeItemIds: _activeItems(state: state),
        inactiveIds: _inactiveItems(state: state),
        withNotUpToDateItem: state is DemarcheListSuccessState && state.dateDerniereMiseAJour != null,
      ),
      isReloading: state is DemarcheListReloadingState,
      onRetry: () => store.dispatch(DemarcheListRequestReloadAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, isReloading];
}

DisplayState _displayState(AppState state) {
  final actionState = state.demarcheListState;
  if (actionState is DemarcheListSuccessState) {
    return (actionState.demarches.isNotEmpty || state.campagneState.campagne != null)
        ? DisplayState.CONTENT
        : DisplayState.EMPTY;
  } else if (actionState is DemarcheListFailureState) {
    return DisplayState.FAILURE;
  } else {
    return DisplayState.LOADING;
  }
}

DemarcheCampagneItem? _campagneItem({required AppState state}) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return DemarcheCampagneItem(titre: campagne.titre, description: campagne.description);
  }
  return null;
}

List<String> _activeItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) => [DemarcheStatus.NOT_STARTED, DemarcheStatus.IN_PROGRESS].contains(demarche.status))
        .map((demarche) => demarche.id)
        .toList();
  }
  return [];
}

List<String> _inactiveItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) => [DemarcheStatus.DONE, DemarcheStatus.CANCELLED].contains(demarche.status))
        .map((demarche) => demarche.id)
        .toList();
  }
  return [];
}

List<DemarcheListItem> _listItems({
  required DemarcheCampagneItem? campagne,
  required List<String> activeItemIds,
  required List<String> inactiveIds,
  required bool withNotUpToDateItem,
}) {
  return [
    if (withNotUpToDateItem) DemarcheNotUpToDateItem(),
    if (campagne != null) ...[campagne],
    ...activeItemIds.map((e) => IdItem(e)),
    ...inactiveIds.map((e) => IdItem(e)),
  ];
}

abstract class DemarcheListItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdItem extends DemarcheListItem {
  final String demarcheId;

  IdItem(this.demarcheId);

  @override
  List<Object?> get props => [demarcheId];
}

class DemarcheCampagneItem extends DemarcheListItem {
  final String titre;
  final String description;

  DemarcheCampagneItem({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}

class DemarcheNotUpToDateItem extends DemarcheListItem {}
