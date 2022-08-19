import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AgendaPageViewModel extends Equatable {
  final DisplayState displayState;

  AgendaPageViewModel({required this.displayState});

  factory AgendaPageViewModel.create(Store<AppState> store) {
    return AgendaPageViewModel(displayState: _displayState(store));
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  if (store.state.agendaState is AgendaLoadingState) {
    return DisplayState.LOADING;
  }
  return DisplayState.EMPTY;
}
