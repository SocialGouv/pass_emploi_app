import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/cgu/cgu_actions.dart';
import 'package:pass_emploi_app/features/cgu/cgu_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

sealed class CguDisplayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CguNeverAcceptedDisplayState extends CguDisplayState {}

class CguUpdateRequiredDisplayState extends CguDisplayState {
  final String lastUpdateLabel;
  final List<String> changes;

  CguUpdateRequiredDisplayState({required this.lastUpdateLabel, required this.changes});

  @override
  List<Object?> get props => [lastUpdateLabel, changes];
}

class CguPageViewModel extends Equatable {
  final CguDisplayState? displayState;
  final Function() onAccept;
  final Function() onRefuse;

  CguPageViewModel._({
    required this.displayState,
    required this.onAccept,
    required this.onRefuse,
  });

  factory CguPageViewModel.create(Store<AppState> store) {
    return CguPageViewModel._(
        displayState: _displayState(store.state.cguState),
        onAccept: () => store.dispatch(CguAcceptedAction(clock.now())),
        onRefuse: () => store.dispatch(CguRefusedAction()));
  }

  @override
  List<Object?> get props => [displayState];
}

CguDisplayState? _displayState(CguState cguState) {
  return switch (cguState) {
    CguNeverAcceptedState() => CguNeverAcceptedDisplayState(),
    CguUpdateRequiredState() => CguUpdateRequiredDisplayState(
        lastUpdateLabel: cguState.updatedCgu.lastUpdate.toDayWithFullMonth(),
        changes: cguState.updatedCgu.changes,
      ),
    _ => null,
  };
}
