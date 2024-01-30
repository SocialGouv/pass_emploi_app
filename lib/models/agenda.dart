import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class Agenda extends Equatable {
  final List<Demarche> demarches;
  final List<Rendezvous> rendezvous;
  final List<SessionMilo> sessionsMilo;
  final int delayedActions;
  final DateTime dateDeDebut;
  final DateTime? dateDerniereMiseAJour;

  Agenda({
    required this.demarches,
    required this.rendezvous,
    required this.sessionsMilo,
    required this.delayedActions,
    required this.dateDeDebut,
    this.dateDerniereMiseAJour,
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
      demarches: _demarches(result),
      rendezvous: rendezvous,
      sessionsMilo: _sessionsMilo(result),
      delayedActions: delayedActions,
      dateDeDebut: dateDeDebut,
      dateDerniereMiseAJour: dateDerniereMiseAjour,
    );
  }

  Agenda copyWith({
    final List<UserAction>? actions,
    final List<Demarche>? demarches,
    final List<Rendezvous>? rendezvous,
    final List<SessionMilo>? sessionsMilo,
    final int? delayedActions,
    final DateTime? dateDeDebut,
    final DateTime? dateDerniereMiseAjour,
  }) {
    return Agenda(
      demarches: demarches ?? this.demarches,
      rendezvous: rendezvous ?? this.rendezvous,
      sessionsMilo: sessionsMilo ?? this.sessionsMilo,
      delayedActions: delayedActions ?? this.delayedActions,
      dateDeDebut: dateDeDebut ?? this.dateDeDebut,
      dateDerniereMiseAJour: dateDerniereMiseAjour ?? dateDerniereMiseAJour,
    );
  }

  @override
  List<Object?> get props => [demarches, rendezvous, sessionsMilo, delayedActions, dateDeDebut, dateDerniereMiseAJour];
}

int _delayedActions(metadata) {
  if (metadata["actionsEnRetard"] != null) return metadata["actionsEnRetard"] as int;
  if (metadata["demarchesEnRetard"] != null) return metadata["demarchesEnRetard"] as int;
  return 0;
}

List<Demarche> _demarches(json) {
  if (json["demarches"] != null) {
    return (json["demarches"] as List).map((demarche) => Demarche.fromJson(demarche)).toList();
  }
  return [];
}

List<SessionMilo> _sessionsMilo(json) {
  if (json["sessionsMilo"] != null) {
    return (json["sessionsMilo"] as List).map((sessionMilo) => SessionMilo.fromJson(sessionMilo)).toList();
  }
  return [];
}
