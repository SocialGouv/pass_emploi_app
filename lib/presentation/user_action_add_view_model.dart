import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/user_action_create_state.dart';
import 'package:redux/redux.dart';

class UserActionAddViewModel {
  final Function(String? actionContent, String? actionComment, UserActionStatus initialStatus) createUserAction;

  final bool isLoading;

  UserActionAddViewModel({
    required this.isLoading,
    required this.createUserAction,
  });

  factory UserActionAddViewModel.create(Store<AppState> store) {
    return UserActionAddViewModel(
      isLoading: store.state.createUserActionState is CreateUserActionLoadingState,
      createUserAction: (content, comment, initialStatus) =>
          {store.dispatch(CreateUserAction(content, comment, initialStatus))},
    );
  }
}
