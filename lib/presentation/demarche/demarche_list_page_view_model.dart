import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class DemarcheListPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<DemarcheListItem> items;
  final bool isDemarcheCreationEnabled;
  final Function() onRetry;

  DemarcheListPageViewModel({
    required this.displayState,
    required this.items,
    required this.isDemarcheCreationEnabled,
    required this.onRetry,
  });

  factory DemarcheListPageViewModel.create(Store<AppState> store) {
    final state = store.state.demarcheListState;
    return DemarcheListPageViewModel(
      displayState: _displayState(store.state),
      items: _listItems(
        campagne: _campagneItem(state: store.state),
        activeItems: _activeItems(state: state),
        inactiveItems: _inactiveItems(state: state),
      ),
      isDemarcheCreationEnabled: state is DemarcheListSuccessState && state.isFonctionnalitesAvanceesJreActivees,
      onRetry: () => store.dispatch(DemarcheListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, isDemarcheCreationEnabled];
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

DemarcheCampagneItemViewModel? _campagneItem({required AppState state}) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return DemarcheCampagneItemViewModel(titre: campagne.titre, description: campagne.description);
  }
  return null;
}

List<DemarcheCardViewModel> _activeItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) =>
            demarche.status == DemarcheStatus.NOT_STARTED || demarche.status == DemarcheStatus.IN_PROGRESS)
        .map((demarche) => DemarcheCardViewModel.create(demarche, state.isFonctionnalitesAvanceesJreActivees))
        .toList();
  }
  return [];
}

List<DemarcheCardViewModel> _inactiveItems({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.demarches
        .where((demarche) => demarche.status == DemarcheStatus.DONE || demarche.status == DemarcheStatus.CANCELLED)
        .map((demarche) => DemarcheCardViewModel.create(demarche, state.isFonctionnalitesAvanceesJreActivees))
        .toList();
  }
  return [];
}

List<DemarcheListItem> _listItems({
  required DemarcheCampagneItemViewModel? campagne,
  required List<DemarcheCardViewModel> activeItems,
  required List<DemarcheCardViewModel> inactiveItems,
}) {
  return [
    if (campagne != null) ...[campagne],
    ...activeItems.map((e) => DemarcheListItemViewModel(e)),
    ...inactiveItems.map((e) => DemarcheListItemViewModel(e)),
  ];
}

abstract class DemarcheListItem extends Equatable {}

class DemarcheListItemViewModel extends DemarcheListItem {
  final DemarcheCardViewModel viewModel;

  DemarcheListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}

class DemarcheCampagneItemViewModel extends DemarcheListItem {
  final String titre;
  final String description;

  DemarcheCampagneItemViewModel({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}
