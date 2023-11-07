import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';

State<RESPONSE> genericReducer<REQUEST, RESPONSE>(State<RESPONSE> current, dynamic action) {
  if (action is Action<REQUEST, RESPONSE>) {
    return switch (action) {
      LoadingAction() => LoadingState<RESPONSE>(),
      SuccessAction() => SuccessState<RESPONSE>(action.data),
      FailureAction() => FailureState<RESPONSE>(),
      ResetAction() => NotInitializedState<RESPONSE>(),
      RequestAction() => current,
    };
  }
  return current;
}
