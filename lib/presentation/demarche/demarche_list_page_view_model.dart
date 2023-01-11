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
  final bool withNotUpToDateMessage;
  final Function() onRetry;

  DemarcheListPageViewModel({
    required this.displayState,
    required this.items,
    required this.withNotUpToDateMessage,
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
      ),
      withNotUpToDateMessage: _withNotUpToDateMessage(state),
      onRetry: () => store.dispatch(DemarcheListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, withNotUpToDateMessage, onRetry];
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

bool _withNotUpToDateMessage(DemarcheListState actionState) {
  if (actionState is DemarcheListSuccessState) {
    return actionState.dateDerniereMiseAJour != null;
  }
  return false;
}

DemarcheCampagneItemViewModel? _campagneItem({required AppState state}) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return DemarcheCampagneItemViewModel(titre: campagne.titre, description: campagne.description);
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
  required DemarcheCampagneItemViewModel? campagne,
  required List<String> activeItemIds,
  required List<String> inactiveIds,
}) {
  return [
    if (campagne != null) ...[campagne],
    ...activeItemIds.map((e) => IdItem(e)),
    ...inactiveIds.map((e) => IdItem(e)),
  ];
}

abstract class DemarcheListItem extends Equatable {}

class IdItem extends DemarcheListItem {
  final String demarcheId;

  IdItem(this.demarcheId);

  @override
  List<Object?> get props => [demarcheId];
}

class DemarcheCampagneItemViewModel extends DemarcheListItem {
  final String titre;
  final String description;

  DemarcheCampagneItemViewModel({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}
