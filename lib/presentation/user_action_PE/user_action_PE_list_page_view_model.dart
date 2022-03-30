import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action_PE/list/user_action_PE_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_PE/list/user_action_PE_list_state.dart';
import 'package:pass_emploi_app/presentation/user_action_PE/user_action_PE_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';
import 'package:pass_emploi_app/models/user_action_PE.dart';

class UserActionPEListPageViewModel extends Equatable {
  final bool withLoading;
  final bool withFailure;
  final bool withEmptyMessage;
  final List<UserActionPEListPageItem> items;
  final Function() onRetry;

  UserActionPEListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
  });

  factory UserActionPEListPageViewModel.create(Store<AppState> store) {
    final state = store.state.userActionPEListState;
    return UserActionPEListPageViewModel(
      withLoading: state is UserActionPEListLoadingState || state is UserActionPEListNotInitializedState,
      withFailure: state is UserActionPEListFailureState,
      withEmptyMessage: _isEmpty(state),
      items: _listItems(
        retardedItems: _retardedItems(state: state),
        activeItems: _activeItems(state: state),
        inactiveItems: _inactiveItems(state: state),
      ),
      onRetry: () => store.dispatch(UserActionPEListRequestAction()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items];
}

bool _isEmpty(UserActionPEListState state) => state is UserActionPEListSuccessState && state.userActions.isEmpty;

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

List<UserActionPEListPageItem> _listItems({
  required List<UserActionPEViewModel> retardedItems,
  required List<UserActionPEViewModel> activeItems,
  required List<UserActionPEViewModel> inactiveItems,
}) {
  return [
    ...retardedItems.map((e) => UserActionPEListItemViewModel(e)),
    ...activeItems.map((e) => UserActionPEListItemViewModel(e)),
    ...inactiveItems.map((e) => UserActionPEListItemViewModel(e)),
  ];
}

abstract class UserActionPEListPageItem extends Equatable {}

class UserActionPEListItemViewModel extends UserActionPEListPageItem {
  final UserActionPEViewModel viewModel;

  UserActionPEListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}
