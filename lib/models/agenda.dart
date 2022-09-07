import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Agenda extends Equatable {
  final List<UserAction> actions;
  final List<Demarche> demarches;
  final List<Rendezvous> rendezvous;
  final int delayedActions;
  final DateTime dateDeDebut;

  Agenda({
    required this.actions,
    required this.demarches,
    required this.rendezvous,
    required this.delayedActions,
    required this.dateDeDebut,
  });

  factory Agenda.fromJson(dynamic json) {
    final rendezvous = (json["rendezVous"] as List).map((e) => JsonRendezvous.fromJson(e).toRendezvous()).toList();
    final metadata = json["metadata"];
    final delayedActions = metadata["actionsEnRetard"] as int;
    final dateDeDebut = (metadata["dateDeDebut"] as String).toDateTimeUtcOnLocalTimeZone();
    return Agenda(
      actions: _actions(json),
      demarches: _demarches(json),
      rendezvous: rendezvous,
      delayedActions: delayedActions,
      dateDeDebut: dateDeDebut,
    );
  }

  Agenda copyWith({
    final List<UserAction>? actions,
    final List<Demarche>? demarches,
    final List<Rendezvous>? rendezvous,
    final int? delayedActions,
    final DateTime? dateDeDebut,
  }) {
    return Agenda(
      actions: actions ?? this.actions,
      demarches: demarches ?? this.demarches,
      rendezvous: rendezvous ?? this.rendezvous,
      delayedActions: delayedActions ?? this.delayedActions,
      dateDeDebut: dateDeDebut ?? this.dateDeDebut,
    );
  }

  @override
  List<Object?> get props => [actions, demarches, rendezvous, delayedActions, dateDeDebut];
}

List<UserAction> _actions(json) {
  if (json["actions"] != null) {
    return (json["actions"] as List).map((action) => UserAction.fromJson(action)).toList();
  }
  return [];
}

List<Demarche> _demarches(json) {
  if (json["demarches"] != null) {
    return (json["demarches"] as List).map((demarche) => Demarche.fromJson(demarche)).toList();
  }
  return [];
}
