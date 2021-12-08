import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:redux/redux.dart';

class UserActionListPageViewModel {
  final bool withLoading;
  final bool withFailure;
  final bool withEmptyMessage;
  final List<UserActionViewModel> items;
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
    if (!(store.state.loginState is LoggedInState)) {
      throw Exception("User should be logged in to access user action list page");
    }
    final user = (store.state.loginState as LoggedInState).user;
    return UserActionListPageViewModel(
      withLoading: _isLoading(store.state.userActionState),
      withFailure: _isFailure(store.state.userActionState),
      withEmptyMessage: _isEmpty(store.state.userActionState),
      items: _items(state: store.state.userActionState),
      onRetry: () => store.dispatch(RequestUserActionsAction(user.id)),
      onUserActionDetailsDismissed: () => store.dispatch(DismissUserActionDetailsAction()),
      onCreateUserActionDismissed: () => store.dispatch(DismissCreateUserAction()),
    );
  }
}

bool _isLoading(UserActionState state) => state is UserActionLoadingState || state is UserActionNotInitializedState;

bool _isFailure(UserActionState state) => state is UserActionFailureState;

bool _isEmpty(UserActionState state) => state is UserActionSuccessState && state.actions.isEmpty;

List<UserActionViewModel> _items({required UserActionState state}) {
  if (state is! UserActionSuccessState) {
    return [];
  }
  return state.actions.map((userAction) => UserActionViewModel.create(userAction)).toList();
}
