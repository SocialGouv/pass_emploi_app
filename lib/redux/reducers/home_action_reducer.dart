import 'package:pass_emploi_app/redux/actions/user_action_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';

AppState homeActionReducer(AppState currentState, dynamic action) {
  if (action is UserActionLoadingAction) {
    return currentState.copyWith(homeState: HomeState.loading());
  } else if (action is UserActionSuccessAction) {
    return currentState.copyWith(homeState: HomeState.success(action.home));
  } else if (action is UserActionFailureAction) {
    return currentState.copyWith(homeState: HomeState.failure());
  } else {
    return currentState;
  }
}
