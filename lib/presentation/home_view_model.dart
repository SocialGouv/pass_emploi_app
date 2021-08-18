import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final String title;
  final bool withLoading;
  final bool withFailure;
  final bool withoutActionsTodo;
  final bool withoutActionsDone;
  final List<UserAction> todoActions;
  final List<UserAction> doneActions;
  final Function(String actionId) onTapTodoAction;
  final Function(String actionId) onTapDoneAction;
  final Function() onRetry;

  HomeViewModel({
    required this.title,
    required this.withLoading,
    required this.withFailure,
    required this.withoutActionsTodo,
    required this.withoutActionsDone,
    required this.todoActions,
    required this.doneActions,
    required this.onTapTodoAction,
    required this.onTapDoneAction,
    required this.onRetry,
  });

  factory HomeViewModel.create(Store<AppState> store) {
    final homeState = store.state.homeState;
    final List<UserAction> actions = homeState is HomeSuccessState ? homeState.home.actions : [];
    final List<UserAction> todoActions = actions.where((action) => !action.isDone).toList();
    final List<UserAction> doneActions = actions.where((action) => action.isDone).toList();
    return HomeViewModel(
      title: "Mes actions${todoActions.isNotEmpty ? " (${todoActions.length})" : ""}",
      withLoading: homeState is HomeLoadingState || homeState is HomeNotInitializedState,
      withFailure: homeState is HomeFailureState,
      withoutActionsTodo: todoActions.isEmpty,
      withoutActionsDone: doneActions.isEmpty,
      todoActions: todoActions..sort((a1, a2) => a2.lastUpdate.compareTo(a1.lastUpdate)),
      doneActions: doneActions..sort((a1, a2) => a2.lastUpdate.compareTo(a1.lastUpdate)),
      onTapTodoAction: (String actionId) =>
          store.dispatch(UpdateActionStatus(actionId: actionId, newIsDoneValue: true)),
      onTapDoneAction: (String actionId) =>
          store.dispatch(UpdateActionStatus(actionId: actionId, newIsDoneValue: false)),
      onRetry: () => store.dispatch(BootstrapAction()),
    );
  }
}
