import 'package:pass_emploi_app/redux/actions/chat_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/chat_state.dart';

AppState chatActionReducer(AppState currentState, dynamic action) {
  if (action is ChatLoadingAction) {
    return currentState.copyWith(chatState: ChatState.loading());
  } else if (action is ChatSuccessAction) {
    return currentState.copyWith(chatState: ChatState.success(action.messages));
  } else if (action is ChatFailureAction) {
    return currentState.copyWith(chatState: ChatState.failure());
  } else {
    return currentState;
  }
}
