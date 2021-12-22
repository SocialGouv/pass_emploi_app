import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
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
    final userActionState = store.state.userActionState;
    return UserActionListPageViewModel(
      withLoading: userActionState.isLoading() || userActionState.isNotInitialized(),
      withFailure: userActionState.isFailure(),
      withEmptyMessage: _isEmpty(userActionState),
      items: _items(state: userActionState),
      onRetry: () => store.dispatch(RequestUserActionsAction()),
      onUserActionDetailsDismissed: () => store.dispatch(DismissUserActionDetailsAction()),
      onCreateUserActionDismissed: () => store.dispatch(DismissCreateUserAction()),
    );
  }
}

bool _isEmpty(State<List<UserAction>> state) => state is SuccessState<List<UserAction>> && state.data.isEmpty;

List<UserActionViewModel> _items({required State<List<UserAction>> state}) {
  if (state is SuccessState<List<UserAction>>) {
    return state.data.map((userAction) => UserActionViewModel.create(userAction)).toList();
  }
  return [];
}
