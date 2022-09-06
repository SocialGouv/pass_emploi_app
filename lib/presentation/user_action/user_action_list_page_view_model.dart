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
  final UserActionCardViewModel? actionDetails;

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
    final actionState = store.state.userActionListState;
    return UserActionListPageViewModel(
      withLoading: actionState is UserActionListLoadingState || actionState is UserActionListNotInitializedState,
      withFailure: actionState is UserActionListFailureState,
      withEmptyMessage: _isEmpty(store.state),
      items: _listItems(
        campagne: _campagneItem(state: store.state),
        activeItems: _activeActions(state: actionState),
        doneOrCanceledItems: _doneOrCanceledActions(state: actionState),
      ),
      onRetry: () => store.dispatch(UserActionListRequestAction()),
      onUserActionDetailsDismissed: () {
        store.dispatch(UserActionUpdateResetAction());
        store.dispatch(UserActionDeleteResetAction());
      },
      onCreateUserActionDismissed: () => store.dispatch(UserActionCreateResetAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      actionDetails: _getDetails(deeplinkState: store.state.deepLinkState, userActionState: actionState),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items];
}

bool _isEmpty(AppState state) {
  final actionState = state.userActionListState;
  return actionState is UserActionListSuccessState &&
      actionState.userActions.isEmpty &&
      state.campagneState.campagne == null;
}

UserActionCampagneItemViewModel? _campagneItem({required AppState state}) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return UserActionCampagneItemViewModel(titre: campagne.titre, description: campagne.description);
  }
  return null;
}

List<UserActionCardViewModel> _activeActions({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status.isCanceledOrDone() == false)
        .map((action) => UserActionCardViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionCardViewModel> _doneOrCanceledActions({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status.isCanceledOrDone())
        .map((action) => UserActionCardViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionListPageItem> _listItems({
  required UserActionCampagneItemViewModel? campagne,
  required List<UserActionCardViewModel> activeItems,
  required List<UserActionCardViewModel> doneOrCanceledItems,
}) {
  return [
    if (campagne != null) ...[campagne],
    ...activeItems.map((e) => UserActionListItemViewModel(e)),
    if (doneOrCanceledItems.isNotEmpty) ...[
      UserActionListSubtitle(Strings.doneActionsTitle),
      ...doneOrCanceledItems.map((e) => UserActionListItemViewModel(e)),
    ]
  ];
}

String? _deeplinkActionId(DeepLinkState state, UserActionListState userActionListStateState) {
  if (userActionListStateState is! UserActionListSuccessState) return null;
  final actionsIds = userActionListStateState.userActions.map((e) => e.id);
  return (state is DetailActionDeepLinkState && actionsIds.contains(state.idAction)) ? state.idAction : null;
}

List<UserActionListPageItem> _getActions(UserActionListState state) {
  if (state is UserActionListSuccessState) {
    final models = state.userActions.map((action) => UserActionCardViewModel.create(action)).toList();
    return models.map((e) => UserActionListItemViewModel(e)).toList();
  }
  return [];
}

UserActionCardViewModel? _getDetails({
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
  final UserActionCardViewModel viewModel;

  UserActionListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}

class UserActionCampagneItemViewModel extends UserActionListPageItem {
  final String titre;
  final String description;

  UserActionCampagneItemViewModel({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}
