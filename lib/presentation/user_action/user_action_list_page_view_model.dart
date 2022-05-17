import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
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
  final Function() onCreateUserActionDismissed;
  final Function() onDeeplinkUsed;
  final UserActionViewModel? actionDetails;

  UserActionListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
    required this.onUserActionDetailsDismissed,
    required this.onCreateUserActionDismissed,
    required this.onDeeplinkUsed,
    required this.actionDetails,
  });

  factory UserActionListPageViewModel.create(Store<AppState> store) {
    final state = store.state.userActionListState;
    return UserActionListPageViewModel(
      withLoading: state is UserActionListLoadingState || state is UserActionListNotInitializedState,
      withFailure: state is UserActionListFailureState,
      withEmptyMessage: _isEmpty(state),
      items: _listItems(
        activeItems: _activeItems(state: state),
        doneOrCanceledItems: _doneOrCanceledItems(state: state),
      ),
      onRetry: () => store.dispatch(UserActionListRequestAction()),
      onUserActionDetailsDismissed: () {
        store.dispatch(UserActionUpdateResetAction());
        store.dispatch(UserActionDeleteResetAction());
      },
      onCreateUserActionDismissed: () => store.dispatch(UserActionCreateResetAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      actionDetails: _getDetails(deeplinkState: store.state.deepLinkState, userActionState: state),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items];
}

bool _isEmpty(UserActionListState state) => state is UserActionListSuccessState && state.userActions.isEmpty;

List<UserActionViewModel> _activeItems({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status.isCanceledOrDone() == false)
        .map((action) => UserActionViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionViewModel> _doneOrCanceledItems({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status.isCanceledOrDone())
        .map((action) => UserActionViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionListPageItem> _listItems({
  required List<UserActionViewModel> activeItems,
  required List<UserActionViewModel> doneOrCanceledItems,
}) {
  return [
    ...activeItems.map((e) => UserActionListItemViewModel(e)),
    if (doneOrCanceledItems.isNotEmpty) ...[
      UserActionListSubtitle(Strings.doneActionsTitle),
      ...doneOrCanceledItems.map((e) => UserActionListItemViewModel(e)),
    ]
  ];
}

String? _deeplinkActionId(DeepLinkState state, UserActionListState userActionListStateState) {
  if (userActionListStateState is! UserActionListSuccessState) return null;
  final acttionsIds = userActionListStateState.userActions.map((e) => e.id);
  return (state.deepLink == DeepLink.ROUTE_TO_ACTION && acttionsIds.contains(state.dataId)) ? state.dataId : null;
}

List<UserActionListPageItem> _getActions(UserActionListState state) {
  if (state is UserActionListSuccessState) {
    final models = state.userActions.map((action) => UserActionViewModel.create(action)).toList();
    return models.map((e) => UserActionListItemViewModel(e)).toList();
  }
  return [];
}

UserActionViewModel? _getDetails({
  required DeepLinkState deeplinkState,
  required UserActionListState userActionState,
}) {
  final deeplinkId = _deeplinkActionId(deeplinkState, userActionState);
  final actions = _getActions(userActionState);
  if (deeplinkId != null && actions.isNotEmpty) {
    final UserActionListPageItem? detailedaction =
        actions.firstWhere((action) => action is UserActionListItemViewModel && action.viewModel.id == deeplinkId);
    if ((detailedaction as UserActionListItemViewModel?) != null) return detailedaction!.viewModel;
  }
  return null;
}

abstract class UserActionListPageItem extends Equatable {}

class UserActionListSubtitle extends UserActionListPageItem {
  final String title;

  UserActionListSubtitle(this.title);

  @override
  List<Object?> get props => [title];
}

class UserActionListItemViewModel extends UserActionListPageItem {
  final UserActionViewModel viewModel;

  UserActionListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}
