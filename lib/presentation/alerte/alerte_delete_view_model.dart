import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_actions.dart';
import 'package:pass_emploi_app/features/alerte/delete/alerte_delete_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

enum AlerteDeleteDisplayState { CONTENT, LOADING, FAILURE, SUCCESS }

class AlerteDeleteViewModel extends Equatable {
  final AlerteDeleteDisplayState displayState;
  final Function(String) onDeleteConfirm;

  AlerteDeleteViewModel({required this.displayState, required this.onDeleteConfirm});

  factory AlerteDeleteViewModel.create(Store<AppState> store) {
    return AlerteDeleteViewModel(
      displayState: _displayState(store.state.alerteDeleteState),
      onDeleteConfirm: (alerteId) => store.dispatch(AlerteDeleteRequestAction(alerteId)),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

AlerteDeleteDisplayState _displayState(AlerteDeleteState state) {
  if (state is AlerteDeleteLoadingState) return AlerteDeleteDisplayState.LOADING;
  if (state is AlerteDeleteFailureState) return AlerteDeleteDisplayState.FAILURE;
  if (state is AlerteDeleteSuccessState) return AlerteDeleteDisplayState.SUCCESS;
  return AlerteDeleteDisplayState.CONTENT;
}
