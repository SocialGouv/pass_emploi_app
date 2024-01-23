import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/create/pending/user_action_create_pending_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class UserActionListPageViewModel extends Equatable {
  final bool withLoading;
  final bool withFailure;
  final bool withEmptyMessage;
  final List<UserActionListPageItem> items;
  final Function() onRetry;
  final Function() onUserActionDetailsDismissed;
  final int? pendingCreationCount;

  UserActionListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
    required this.onUserActionDetailsDismissed,
    required this.pendingCreationCount,
  });

  factory UserActionListPageViewModel.create(Store<AppState> store) {
    final actionState = store.state.userActionListState;
    final pendingCreationCount = _getPendingCreationCount(store);
    return UserActionListPageViewModel(
      withLoading: actionState is UserActionListLoadingState || actionState is UserActionListNotInitializedState,
      withFailure: actionState is UserActionListFailureState,
      withEmptyMessage: _isEmpty(store.state),
      items: _listItems(
        pendingCreationCount: pendingCreationCount,
        activeItemIds: _activeActions(state: actionState),
        doneOrCanceledItemIds: _doneOrCanceledActions(state: actionState),
      ),
      onRetry: () => store.dispatch(UserActionListRequestAction(forceRefresh: true)),
      onUserActionDetailsDismissed: () {
        store.dispatch(UserActionUpdateResetAction());
        store.dispatch(UserActionDeleteResetAction());
      },
      pendingCreationCount: pendingCreationCount,
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items, pendingCreationCount];
}

bool _isEmpty(AppState state) {
  final actionState = state.userActionListState;
  return actionState is UserActionListSuccessState && actionState.userActions.isEmpty;
}

List<String> _activeActions({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => !action.status.isCanceledOrDone()) //
        .map((action) => action.id)
        .toList();
  }
  return [];
}

List<String> _doneOrCanceledActions({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status.isCanceledOrDone()) //
        .map((action) => action.id)
        .toList();
  }
  return [];
}

List<UserActionListPageItem> _listItems({
  required int? pendingCreationCount,
  required List<String> activeItemIds,
  required List<String> doneOrCanceledItemIds,
}) {
  return [
    if (pendingCreationCount != null && pendingCreationCount > 0) PendingActionCreationItem(pendingCreationCount),
    ...activeItemIds.map((e) => IdItem(e)),
    if (doneOrCanceledItemIds.isNotEmpty) ...[
      SubtitleItem(Strings.doneActionsTitle),
      ...doneOrCanceledItemIds.map((e) => IdItem(e)),
    ]
  ];
}

int? _getPendingCreationCount(Store<AppState> store) {
  final pendingCreationState = store.state.userActionCreatePendingState;
  if (pendingCreationState is UserActionCreatePendingSuccessState) {
    return pendingCreationState.pendingCreationsCount != 0 ? pendingCreationState.pendingCreationsCount : null;
  }
  return null;
}

sealed class UserActionListPageItem extends Equatable {}

class PendingActionCreationItem extends UserActionListPageItem {
  final int pendingCreationsCount;

  PendingActionCreationItem(this.pendingCreationsCount);

  @override
  List<Object?> get props => [pendingCreationsCount];
}

class SubtitleItem extends UserActionListPageItem {
  final String title;

  SubtitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class IdItem extends UserActionListPageItem {
  final String userActionId;

  IdItem(this.userActionId);

  @override
  List<Object?> get props => [userActionId];
}
