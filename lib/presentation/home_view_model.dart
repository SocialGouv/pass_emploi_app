import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final bool withLoading;
  final bool withFailure;
  final bool withoutAnyActions;
  final bool withActionsTodo;
  final bool withActionsDone;
  final List<UserAction> todoActions;
  final List<UserAction> doneActions;
  final Function(int actionId) onTapTodoAction;
  final Function(int actionId) onTapDoneAction;

  HomeViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withoutAnyActions,
    required this.withActionsTodo,
    required this.withActionsDone,
    required this.todoActions,
    required this.doneActions,
    required this.onTapTodoAction,
    required this.onTapDoneAction,
  });

  factory HomeViewModel.create(Store<AppState> store) {
    final homeState = store.state.homeState;
    final List<UserAction> actions = homeState is HomeSuccessState ? homeState.home.actions : [];
    final List<UserAction> todoActions = actions.where((action) => !action.isDone).toList();
    final List<UserAction> doneActions = actions.where((action) => action.isDone).toList();
    return HomeViewModel(
      withLoading: homeState is HomeLoadingState || homeState is HomeNotInitializedState,
      withFailure: homeState is HomeFailureState,
      withoutAnyActions: actions.isEmpty,
      withActionsTodo: todoActions.isNotEmpty,
      withActionsDone: doneActions.isNotEmpty,
      todoActions: todoActions,
      doneActions: doneActions,
      onTapTodoAction: (int actionId) {
        store.dispatch(UpdateActionStatus(actionId: actionId, newIsDoneValue: true));
      },
      onTapDoneAction: (int actionId) {
        store.dispatch(UpdateActionStatus(actionId: actionId, newIsDoneValue: false));
      },
    );
  }
}
