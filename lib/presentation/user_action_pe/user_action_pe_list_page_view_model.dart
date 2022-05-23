import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
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
    final state = store.state.userActionPEListState;
    return UserActionPEListPageViewModel(
      displayState: _displayState(state),
      items: _listItems(
        campagne: _campagneItem(state: state),
        retardedItems: _retardedActions(state: state),
        activeItems: _activeActions(state: state),
        inactiveItems: _inactiveActions(state: state),
      ),
      onRetry: () => store.dispatch(UserActionPEListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items];
}

DisplayState _displayState(UserActionPEListState state) {
  if (state is UserActionPEListSuccessState) {
    return (state.userActions.isNotEmpty || state.campagne != null) ? DisplayState.CONTENT : DisplayState.EMPTY;
  } else if (state is UserActionPEListFailureState) {
    return DisplayState.FAILURE;
  } else {
    return DisplayState.LOADING;
  }
}

UserActionPECampagneItemViewModel? _campagneItem({required UserActionPEListState state}) {
  if (state is! UserActionPEListSuccessState) return null;
  final campagne = state.campagne;
  if (campagne != null) {
    return UserActionPECampagneItemViewModel(titre: campagne.titre, description: campagne.description);
  }
  return null;
}

List<UserActionPEViewModel> _retardedActions({required UserActionPEListState state}) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions
        .where((action) => action.status == UserActionPEStatus.RETARDED)
        .map((action) => UserActionPEViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionPEViewModel> _activeActions({required UserActionPEListState state}) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions
        .where((action) =>
            action.status == UserActionPEStatus.NOT_STARTED || action.status == UserActionPEStatus.IN_PROGRESS)
        .map((action) => UserActionPEViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionPEViewModel> _inactiveActions({required UserActionPEListState state}) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions
        .where((action) => action.status == UserActionPEStatus.DONE || action.status == UserActionPEStatus.CANCELLED)
        .map((action) => UserActionPEViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionPEListItem> _listItems({
  required UserActionPECampagneItemViewModel? campagne,
  required List<UserActionPEViewModel> retardedItems,
  required List<UserActionPEViewModel> activeItems,
  required List<UserActionPEViewModel> inactiveItems,
}) {
  return [
    if (campagne != null) ...[campagne],
    ...retardedItems.map((e) => UserActionPEListItemViewModel(e)),
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
