import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/create_user_action_state.dart';
import 'package:redux/redux.dart';

enum CreateUserActionDisplayState { SHOW_CONTENT, SHOW_LOADING, TO_DISMISS, SHOW_ERROR }

class CreateUserActionViewModel {
  final Function(String actionContent, String? actionComment, UserActionStatus initialStatus) createUserAction;

  final CreateUserActionDisplayState displayState;

  CreateUserActionViewModel({
    required this.displayState,
    required this.createUserAction,
  });

  factory CreateUserActionViewModel.create(Store<AppState> store) {
    return CreateUserActionViewModel(
      displayState: _displayState(store.state.createUserActionState),
      createUserAction: (content, comment, initialStatus) =>
          {store.dispatch(CreateUserAction(content, comment, initialStatus))},
    );
  }
}

CreateUserActionDisplayState _displayState(CreateUserActionState userActionCreateState) {
  if (userActionCreateState is CreateUserActionNotInitializedState) {
    return CreateUserActionDisplayState.SHOW_CONTENT;
  } else if (userActionCreateState is CreateUserActionLoadingState) {
    return CreateUserActionDisplayState.SHOW_LOADING;
  } else if (userActionCreateState is CreateUserActionSuccessState){
    return CreateUserActionDisplayState.TO_DISMISS;
  } else {
    return CreateUserActionDisplayState.SHOW_ERROR;
  }
}
