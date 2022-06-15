import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_actions.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action_pe/user_action_pe_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UserActionPEListPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<UserActionPEListItem> items;
  final Function() onRetry;

  UserActionPEListPageViewModel({
    required this.displayState,
    required this.items,
    required this.onRetry,
  });

  factory UserActionPEListPageViewModel.create(Store<AppState> store) {
    final actionState = store.state.demarcheListState;
    return UserActionPEListPageViewModel(
      displayState: _displayState(store.state),
      items: _listItems(
        campagne: _campagneItem(state: store.state),
        activeItems: _activeActions(state: actionState),
        inactiveItems: _inactiveActions(state: actionState),
      ),
      onRetry: () => store.dispatch(DemarcheListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items];
}

DisplayState _displayState(AppState state) {
  final actionState = state.demarcheListState;
  if (actionState is DemarcheListSuccessState) {
    return (actionState.userActions.isNotEmpty || state.campagneState.campagne != null)
        ? DisplayState.CONTENT
        : DisplayState.EMPTY;
  } else if (actionState is DemarcheListFailureState) {
    return DisplayState.FAILURE;
  } else {
    return DisplayState.LOADING;
  }
}

UserActionPECampagneItemViewModel? _campagneItem({required AppState state}) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return UserActionPECampagneItemViewModel(titre: campagne.titre, description: campagne.description);
  }
  return null;
}

List<UserActionPEViewModel> _activeActions({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.userActions
        .where((action) =>
            action.status == DemarcheStatus.NOT_STARTED ||
            action.status == DemarcheStatus.IN_PROGRESS)
        .map((action) =>
            UserActionPEViewModel.create(action, state.isDetailAvailable))
        .toList();
  }
  return [];
}

List<UserActionPEViewModel> _inactiveActions({required DemarcheListState state}) {
  if (state is DemarcheListSuccessState) {
    return state.userActions
        .where((action) =>
            action.status == DemarcheStatus.DONE ||
            action.status == DemarcheStatus.CANCELLED)
        .map((action) =>
            UserActionPEViewModel.create(action, state.isDetailAvailable))
        .toList();
  }
  return [];
}

List<UserActionPEListItem> _listItems({
  required UserActionPECampagneItemViewModel? campagne,
  required List<UserActionPEViewModel> activeItems,
  required List<UserActionPEViewModel> inactiveItems,
}) {
  return [
    if (campagne != null) ...[campagne],
    ...activeItems.map((e) => UserActionPEListItemViewModel(e)),
    ...inactiveItems.map((e) => UserActionPEListItemViewModel(e)),
  ];
}

abstract class UserActionPEListItem extends Equatable {}

class UserActionPEListItemViewModel extends UserActionPEListItem {
  final UserActionPEViewModel viewModel;

  UserActionPEListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}

class UserActionPECampagneItemViewModel extends UserActionPEListItem {
  final String titre;
  final String description;

  UserActionPECampagneItemViewModel({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}
