import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';

class Agenda extends Equatable {
  final List<UserAction> actions;
  final List<Rendezvous> rendezvous;
  final int delayedActions;

  Agenda({required this.actions, required this.rendezvous, required this.delayedActions});

  factory Agenda.fromJson(dynamic json, int delayedActions) {
    final actions = (json["actions"] as List).map((action) => UserAction.fromJson(action)).toList();
    final rendezvous = (json["rendezVous"] as List)
        .map((e) => JsonRendezvous.fromJson(e)) //
        .map((e) => e.toRendezvous()) //
        .toList();
    return Agenda(actions: actions, rendezvous: rendezvous, delayedActions: delayedActions);
  }

  Agenda copyWith({
    final List<UserAction>? actions,
    final List<Rendezvous>? rendezvous,
    final int? delayedActions,
  }) {
    return Agenda(
      actions: actions ?? this.actions,
      rendezvous: rendezvous ?? this.rendezvous,
      delayedActions: delayedActions ?? this.delayedActions,
    );
  }

  @override
  List<Object?> get props => [actions, rendezvous, delayedActions];
}
