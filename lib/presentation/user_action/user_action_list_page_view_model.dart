import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
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
  final Function() onCreateUserActionDismissed;
  final Function() onDeeplinkUsed;
  final String? deeplinkActionId;

  UserActionListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
    required this.onUserActionDetailsDismissed,
    required this.onCreateUserActionDismissed,
    required this.onDeeplinkUsed,
    required this.deeplinkActionId,
  });

  factory UserActionListPageViewModel.create(Store<AppState> store) {
    final actionState = store.state.userActionListState;
    return UserActionListPageViewModel(
      withLoading: actionState is UserActionListLoadingState || actionState is UserActionListNotInitializedState,
      withFailure: actionState is UserActionListFailureState,
      withEmptyMessage: _isEmpty(store.state),
      items: _listItems(
        campagne: _campagneItem(state: store.state), //TODO: remove
        activeItemIds: _activeActions(state: actionState),
        doneOrCanceledItemIds: _doneOrCanceledActions(state: actionState),
      ),
      onRetry: () => store.dispatch(UserActionListRequestAction()),
      onUserActionDetailsDismissed: () {
        store.dispatch(UserActionUpdateResetAction());
        store.dispatch(UserActionDeleteResetAction());
      },
      onCreateUserActionDismissed: () => store.dispatch(UserActionCreateResetAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      deeplinkActionId: _deeplinkActionId(store.state.deepLinkState, actionState),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items];
}

bool _isEmpty(AppState state) {
  final actionState = state.userActionListState;
  return actionState is UserActionListSuccessState &&
      actionState.userActions.isEmpty &&
      state.campagneState.campagne == null; //TODO: remove
}

//TODO: remove
CampagneItem? _campagneItem({required AppState state}) {
  final campagne = state.campagneState.campagne;
  if (campagne != null) {
    return CampagneItem(titre: campagne.titre, description: campagne.description);
  }
  return null;
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
  required CampagneItem? campagne, //TODO: remove
  required List<String> activeItemIds,
  required List<String> doneOrCanceledItemIds,
}) {
  return [
    if (campagne != null) ...[campagne], //TODO: remove
    ...activeItemIds.map((e) => IdItem(e)),
    if (doneOrCanceledItemIds.isNotEmpty) ...[
      SubtitleItem(Strings.doneActionsTitle),
      ...doneOrCanceledItemIds.map((e) => IdItem(e)),
    ]
  ];
}

String? _deeplinkActionId(DeepLinkState state, UserActionListState userActionListStateState) {
  if (userActionListStateState is! UserActionListSuccessState) return null;
  final actionsIds = userActionListStateState.userActions.map((e) => e.id);
  return (state is DetailActionDeepLinkState && actionsIds.contains(state.idAction)) ? state.idAction : null;
}

abstract class UserActionListPageItem extends Equatable {}

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

//TODO: remove
class CampagneItem extends UserActionListPageItem {
  final String titre;
  final String description;

  CampagneItem({required this.titre, required this.description});

  @override
  List<Object?> get props => [titre, description];
}
