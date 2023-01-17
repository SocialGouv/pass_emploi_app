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
  final DateTime? dateDerniereMiseAjour;

  Agenda({
    required this.actions,
    required this.demarches,
    required this.rendezvous,
    required this.delayedActions,
    required this.dateDeDebut,
    this.dateDerniereMiseAjour,
  });

  factory Agenda.fromV1Json(dynamic json) {
    final result = {"resultat": json};
    return Agenda.fromV2Json(result);
  }

  factory Agenda.fromV2Json(dynamic json) {
    final result = json["resultat"];
    final rendezvous = (result["rendezVous"] as List).map((e) => JsonRendezvous.fromJson(e).toRendezvous()).toList();
    final metadata = result["metadata"];
    final delayedActions = _delayedActions(metadata);
    final dateDeDebut = (metadata["dateDeDebut"] as String).toDateTimeUtcOnLocalTimeZone();
    final dateDerniereMiseAjour = (json["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone();
    return Agenda(
      actions: _actions(result),
      demarches: _demarches(result),
      rendezvous: rendezvous,
      delayedActions: delayedActions,
      dateDeDebut: dateDeDebut,
      dateDerniereMiseAjour: dateDerniereMiseAjour,
    );
  }

  Agenda copyWith({
    final List<UserAction>? actions,
    final List<Demarche>? demarches,
    final List<Rendezvous>? rendezvous,
    final int? delayedActions,
    final DateTime? dateDeDebut,
    final DateTime? dateDerniereMiseAjour,
  }) {
    return Agenda(
      actions: actions ?? this.actions,
      demarches: demarches ?? this.demarches,
      rendezvous: rendezvous ?? this.rendezvous,
      delayedActions: delayedActions ?? this.delayedActions,
      dateDeDebut: dateDeDebut ?? this.dateDeDebut,
      dateDerniereMiseAjour: dateDerniereMiseAjour ?? this.dateDerniereMiseAjour,
    );
  }

  @override
  List<Object?> get props => [actions, demarches, rendezvous, delayedActions, dateDeDebut, dateDerniereMiseAjour];
}

int _delayedActions(metadata) {
  if (metadata["actionsEnRetard"] != null) return metadata["actionsEnRetard"] as int;
  if (metadata["demarchesEnRetard"] != null) return metadata["demarchesEnRetard"] as int;
  return 0;
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
