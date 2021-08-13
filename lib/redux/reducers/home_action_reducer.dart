import 'package:pass_emploi_app/redux/actions/home_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';

AppState homeActionReducer(AppState currentState, dynamic action) {
  if (action is HomeLoadingAction) {
    return currentState.copyWith(homeState: HomeState.loading());
  } else if (action is HomeSuccessAction) {
    return currentState.copyWith(homeState: HomeState.success(action.home));
  } else if (action is HomeFailureAction) {
    return currentState.copyWith(homeState: HomeState.failure());
  } else {
    return currentState;
  }
}
