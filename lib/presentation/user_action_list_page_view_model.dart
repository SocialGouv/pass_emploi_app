import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
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
    final userActionState = store.state.userActionState;
    return UserActionListPageViewModel(
      withLoading: userActionState.isLoading() || userActionState.isNotInitialized(),
      withFailure: userActionState.isFailure(),
      withEmptyMessage: _isEmpty(userActionState),
      items: _listItems(
        activeItems: _activeItems(state: userActionState),
        doneItems: _doneItems(state: userActionState),
      ),
      onRetry: () => store.dispatch(RequestUserActionsAction()),
      onUserActionDetailsDismissed: () => store.dispatch(DismissUserActionDetailsAction()),
      onCreateUserActionDismissed: () => store.dispatch(DismissCreateUserAction()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items];
}

bool _isEmpty(State<List<UserAction>> state) => state.isSuccess() && state.getResultOrThrow().isEmpty;

List<UserActionViewModel> _activeItems({required State<List<UserAction>> state}) {
  if (state.isSuccess())
    return state
        .getResultOrThrow()
        .where((action) => action.status != UserActionStatus.DONE)
        .map((action) => UserActionViewModel.create(action))
        .toList();
  return [];
}

List<UserActionViewModel> _doneItems({required State<List<UserAction>> state}) {
  if (state.isSuccess())
    return state
        .getResultOrThrow()
        .where((action) => action.status == UserActionStatus.DONE)
        .map((action) => UserActionViewModel.create(action))
        .toList();
  return [];
}

List<UserActionListPageItem> _listItems({
  required List<UserActionViewModel> activeItems,
  required List<UserActionViewModel> doneItems,
}) {
  return [
    ...activeItems.map((e) => UserActionListItemViewModel(e)),
    if (doneItems.isNotEmpty) ...[
      ...doneItems.map((e) => UserActionListItemViewModel(e)),
    ]
  ];
}

abstract class UserActionListPageItem extends Equatable {}

class UserActionListItemViewModel extends UserActionListPageItem {
  final UserActionViewModel viewModel;

  UserActionListItemViewModel(this.viewModel);

  @override
  List<Object?> get props => [viewModel];
}
