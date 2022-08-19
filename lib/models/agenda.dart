import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';

class Agenda extends Equatable {
  final List<UserAction> actions;
  final List<Rendezvous> rendezvous;

  Agenda({required this.actions, required this.rendezvous});

  factory Agenda.fromJson(dynamic json) {
    final actions = (json["actions"] as List).map((action) => UserAction.fromJson(action)).toList();
    final rendezVous = (json["rendezVous"] as List)
        .map((e) => JsonRendezvous.fromJson(e)) //
        .map((e) => e.toRendezvous()) //
        .toList();
    return Agenda(actions: actions, rendezvous: rendezVous);
  }

  @override
  List<Object?> get props => [actions, rendezvous];
}
