import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_state.dart';
import 'package:redux/redux.dart';

class UserActionListPageViewModel {
  final bool withLoading;
  final bool withFailure;
  final List<UserActionViewModel> items;
  final Function() onRetry;

  UserActionListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.items,
    required this.onRetry,
  });

  factory UserActionListPageViewModel.create(Store<AppState> store) {
    if (!(store.state.loginState is LoggedInState)) {
      throw Exception("User should be logged in to access user action list page");
    }
    final user = (store.state.loginState as LoggedInState).user;
    return UserActionListPageViewModel(
      withLoading: _isLoading(store.state.userActionState),
      withFailure: _isFailure(store.state.userActionState),
      items: _items(store.state.userActionState),
      onRetry: () => store.dispatch(RequestUserActionsAction(user.id)),
    );
  }
}

bool _isLoading(UserActionState state) => state is UserActionLoadingState || state is UserActionNotInitializedState;

bool _isFailure(UserActionState state) => state is UserActionFailureState;

List<UserActionViewModel> _items(UserActionState state) {
  if (state is! UserActionSuccessState) {
    return [];
  } else {
    return state.actions
        .map((e) => UserActionViewModel(
              id: e.id,
              content: e.content,
              comment: e.comment,
              withComment: e.comment.isNotEmpty,
              isDone: e.isDone,
              lastUpdate: e.lastUpdate,
            ))
        .toList();
  }
}
