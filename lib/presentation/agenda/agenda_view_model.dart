import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class AgendaPageViewModel extends Equatable {
  final DisplayState displayState;
  final List<dynamic> events;

  AgendaPageViewModel({required this.displayState, required this.events});

  factory AgendaPageViewModel.create(Store<AppState> store) {
    return AgendaPageViewModel(
      displayState: _displayState(store),
      events: _events(store),
    );
  }

  @override
  List<Object?> get props => [displayState, events];
}

DisplayState _displayState(Store<AppState> store) {
  final agendaState = store.state.agendaState;
  if (agendaState is AgendaFailureState) {
    return DisplayState.FAILURE;
  } else if (agendaState is AgendaSuccessState) {
    if (agendaState.agenda.actions.isEmpty && agendaState.agenda.rendezvous.isEmpty) {
      return DisplayState.EMPTY;
    } else {
      return DisplayState.CONTENT;
    }
  }
  return DisplayState.LOADING;
}

List<dynamic> _events(Store<AppState> store) {
  final agendaState = store.state.agendaState;
  if (agendaState is! AgendaSuccessState) return [];

  final events = [
    ...agendaState.agenda.actions,
    ...agendaState.agenda.rendezvous,
  ];

  events.sort((a, b) {
    return _getDate(a).compareTo(_getDate(b));
  });

  return events.map((e) {
    if (e is UserAction) return UserActionViewModel.create(e);
    if (e is Rendezvous) return RendezvousAgendaViewModel(id: e.id);
    return e;
  }).toList();
}

DateTime _getDate(dynamic event) {
  if (event is UserAction) return event.dateEcheance;
  if (event is Rendezvous) return event.date;
  return DateTime.now();
}

// todo : move
class RendezvousAgendaViewModel extends Equatable {
  final String id;

  RendezvousAgendaViewModel({required this.id});

  @override
  List<Object?> get props => [id];
}
