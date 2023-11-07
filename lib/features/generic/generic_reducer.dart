import 'package:pass_emploi_app/features/generic/generic_actions.dart';
import 'package:pass_emploi_app/features/generic/generic_state.dart';

State<T> genericReducer<T>(State<T> current, dynamic action) {
  if (action is Action<T>) {
    return switch (action) {
      LoadingAction() => LoadingState<T>(),
      SuccessAction() => SuccessState<T>(action.data),
      FailureAction() => FailureState<T>(),
      ResetAction() => NotInitializedState<T>(),
      RequestAction() => current,
    };
  }
  return current;
}
