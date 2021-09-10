import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_item.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:redux/redux.dart';

class UserActionPageViewModel {
  final String title;
  final bool withLoading;
  final bool withFailure;
  final List<UserActionItem> items;
  final Function(String actionId) onTapTodoAction;
  final Function(String actionId) onTapDoneAction;
  final Function() onRetry;

  UserActionPageViewModel({
    required this.title,
    required this.withLoading,
    required this.withFailure,
    required this.items,
    required this.onTapTodoAction,
    required this.onTapDoneAction,
    required this.onRetry,
  });

  factory UserActionPageViewModel.create(Store<AppState> store) {
    if (!(store.state.loginState is LoggedInState)) {
      throw Exception("User should be logged in to access home page");
    }
    final user = (store.state.loginState as LoggedInState).user;
    final userActionState = store.state.userActionState;
    final List<UserAction> actions = userActionState is UserActionSuccessState ? userActionState.actions : [];
    final List<UserAction> todoActions = actions.where((action) => !action.isDone).toList();
    final List<UserAction> doneActions = actions.where((action) => action.isDone).toList();
    final List<UserAction> sortedTodoActions = todoActions..sort((a1, a2) => a2.lastUpdate.compareTo(a1.lastUpdate));
    final List<UserAction> sortedDoneActions = doneActions..sort((a1, a2) => a2.lastUpdate.compareTo(a1.lastUpdate));
    return UserActionPageViewModel(
      title: "Mes actions${todoActions.isNotEmpty ? " (${todoActions.length})" : ""}",
      withLoading: userActionState is UserActionLoadingState || userActionState is UserActionNotInitializedState,
      withFailure: userActionState is UserActionFailureState,
      items: _userActionItems(sortedTodoActions, sortedDoneActions),
      onTapTodoAction: (String actionId) =>
          store.dispatch(UpdateActionStatus(userId: user.id, actionId: actionId, newIsDoneValue: true)),
      onTapDoneAction: (String actionId) =>
          store.dispatch(UpdateActionStatus(userId: user.id, actionId: actionId, newIsDoneValue: false)),
      onRetry: () => store.dispatch(RequestUserActionsAction(user.id)),
    );
  }
}

_userActionItems(List<UserAction> todoActions, List<UserAction> doneActions) {
  return (<UserActionItem?>[]
        ..add(UserActionItem.section("Mes actions en cours"))
        ..add(todoActions.isEmpty ? UserActionItem.message("Tu n’as pas encore d’actions en cours.") : null)
        ..addAll(todoActions.map((action) => UserActionItem.todoAction(action)))
        ..add(UserActionItem.section("Mes actions terminées"))
        ..add(doneActions.isEmpty ? UserActionItem.message("Tu n’as pas encore terminé d’actions.") : null)
        ..addAll(doneActions.map((action) => UserActionItem.doneAction(action))))
      .whereType<UserActionItem>()
      .toList();
}
