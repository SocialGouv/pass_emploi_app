import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';

class MonSuivi extends Equatable {
  final List<UserAction> actions;
  final List<Demarche> demarches;
  final List<Rendezvous> rendezvous;
  final List<SessionMilo> sessionsMilo;
  final bool errorOnSessionMiloRetrieval;

  MonSuivi({
    required this.actions,
    required this.demarches,
    required this.rendezvous,
    required this.sessionsMilo,
    required this.errorOnSessionMiloRetrieval,
  });

  factory MonSuivi.fromMiloJson(dynamic json) {
    final jsonSessionMilo = json["sessionsMilo"];
    return MonSuivi(
      actions: (json["actions"] as List).map(UserAction.fromJson).toList(),
      rendezvous: (json["rendezVous"] as List).map((e) => JsonRendezvous.fromJson(e).toRendezvous()).toList(),
      sessionsMilo: jsonSessionMilo != null ? (jsonSessionMilo as List).map(SessionMilo.fromJson).toList() : [],
      errorOnSessionMiloRetrieval: jsonSessionMilo == null,
      demarches: [],
    );
  }

  factory MonSuivi.fromPoleEmploiJson(dynamic json) {
    return MonSuivi(
      demarches: (json["demarches"] as List).map(Demarche.fromJson).toList(),
      rendezvous: (json["rendezVous"] as List).map((e) => JsonRendezvous.fromJson(e).toRendezvous()).toList(),
      actions: [],
      sessionsMilo: [],
      errorOnSessionMiloRetrieval: false,
    );
  }

  MonSuivi concatenate(MonSuivi monSuivi) {
    return MonSuivi(
      actions: [...actions, ...monSuivi.actions],
      demarches: [...demarches, ...monSuivi.demarches],
      rendezvous: [...rendezvous, ...monSuivi.rendezvous],
      sessionsMilo: [...sessionsMilo, ...monSuivi.sessionsMilo],
      errorOnSessionMiloRetrieval: errorOnSessionMiloRetrieval || monSuivi.errorOnSessionMiloRetrieval,
    );
  }

  MonSuivi copyWith({
    List<UserAction>? actions,
    List<Demarche>? demarches,
    List<Rendezvous>? rendezvous,
    List<SessionMilo>? sessionsMilo,
    bool? errorOnSessionMiloRetrieval,
  }) {
    return MonSuivi(
      actions: actions ?? this.actions,
      demarches: demarches ?? this.demarches,
      rendezvous: rendezvous ?? this.rendezvous,
      sessionsMilo: sessionsMilo ?? this.sessionsMilo,
      errorOnSessionMiloRetrieval: errorOnSessionMiloRetrieval ?? this.errorOnSessionMiloRetrieval,
    );
  }

  @override
  List<Object?> get props => [actions, demarches, rendezvous, sessionsMilo, errorOnSessionMiloRetrieval];
}
