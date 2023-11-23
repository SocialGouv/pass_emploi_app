import 'package:pass_emploi_app/features/alerte/create/alerte_create_actions.dart';
import 'package:pass_emploi_app/features/alerte/create/alerte_create_state.dart';

AlerteCreateState<T> alerteCreateReducer<T>(AlerteCreateState<T> current, dynamic action) {
  if (action is AlerteCreateLoadingAction<T>) return AlerteCreateState<T>.loading();
  if (action is AlerteCreateFailureAction<T>) return AlerteCreateState<T>.failure();
  if (action is AlerteCreateInitializeAction<T>) return AlerteCreateState<T>.initialized(action.alerte);
  if (action is AlerteCreateSuccessAction<T>) return AlerteCreateState<T>.successfullyCreated();
  if (action is AlerteCreateResetAction<T>) return AlerteCreateState<T>.notInitialized();
  return current;
}
