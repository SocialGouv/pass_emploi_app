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
  final List<UserActionPEListItemViewModel> items;
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
        retardedItems: _retardedItems(state: state),
        activeItems: _activeItems(state: state),
        inactiveItems: _inactiveItems(state: state),
      ),
      onRetry: () => store.dispatch(UserActionPEListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items];
}

DisplayState _displayState(UserActionPEListState state) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions.isNotEmpty ? DisplayState.CONTENT : DisplayState.EMPTY;
  } else if (state is UserActionPEListFailureState) {
    return DisplayState.FAILURE;
  } else {
    return DisplayState.LOADING;
  }
}

List<UserActionPEViewModel> _retardedItems({required UserActionPEListState state}) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions
        .where((action) => action.status == UserActionPEStatus.RETARDED)
        .map((action) => UserActionPEViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionPEViewModel> _activeItems({required UserActionPEListState state}) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions
        .where((action) =>
            action.status == UserActionPEStatus.NOT_STARTED || action.status == UserActionPEStatus.IN_PROGRESS)
        .map((action) => UserActionPEViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionPEViewModel> _inactiveItems({required UserActionPEListState state}) {
  if (state is UserActionPEListSuccessState) {
    return state.userActions
        .where((action) => action.status == UserActionPEStatus.DONE || action.status == UserActionPEStatus.CANCELLED)
        .map((action) => UserActionPEViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionPEListItemViewModel> _listItems({
  required List<UserActionPEViewModel> retardedItems,
  required List<UserActionPEViewModel> activeItems,
  required List<UserActionPEViewModel> inactiveItems,
}) {
  return (retardedItems + activeItems + inactiveItems).map((e) => UserActionPEListItemViewModel(e)).toList();
}

class UserActionPEListItemViewModel extends Equatable {
  final UserActionPEViewModel viewModel;

  UserActionPEListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}
