import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/create/user_action_create_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_actions.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
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

  UserActionListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
    required this.onUserActionDetailsDismissed,
    required this.onCreateUserActionDismissed,
  });

  factory UserActionListPageViewModel.create(Store<AppState> store) {
    final state = store.state.userActionListState;
    return UserActionListPageViewModel(
      withLoading: state is UserActionListLoadingState || state is UserActionListNotInitializedState,
      withFailure: state is UserActionListFailureState,
      withEmptyMessage: _isEmpty(state),
      items: _listItems(
        activeItems: _activeItems(state: state),
        doneItems: _doneItems(state: state),
      ),
      onRetry: () => store.dispatch(UserActionListRequestAction()),
      onUserActionDetailsDismissed: () {
        store.dispatch(UserActionUpdateResetAction());
        store.dispatch(UserActionDeleteResetAction());
      },
      onCreateUserActionDismissed: () => store.dispatch(UserActionCreateResetAction()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items];
}

bool _isEmpty(UserActionListState state) => state is UserActionListSuccessState && state.userActions.isEmpty;

List<UserActionViewModel> _activeItems({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status != UserActionStatus.DONE)
        .map((action) => UserActionViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionViewModel> _doneItems({required UserActionListState state}) {
  if (state is UserActionListSuccessState) {
    return state.userActions
        .where((action) => action.status == UserActionStatus.DONE)
        .map((action) => UserActionViewModel.create(action))
        .toList();
  }
  return [];
}

List<UserActionListPageItem> _listItems({
  required List<UserActionViewModel> activeItems,
  required List<UserActionViewModel> doneItems,
}) {
  return [
    ...activeItems.map((e) => UserActionListItemViewModel(e)),
    if (doneItems.isNotEmpty) ...[
      UserActionListSubtitle(Strings.doneActionsTitle),
      ...doneItems.map((e) => UserActionListItemViewModel(e)),
    ]
  ];
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
