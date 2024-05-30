import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class MonSuivi extends Equatable {
  final List<UserAction> actions;
  final List<Demarche> demarches;
  final List<Rendezvous> rendezvous;
  final List<SessionMilo> sessionsMilo;
  final bool errorOnSessionMiloRetrieval;
  final DateTime? dateDerniereMiseAJourPoleEmploi;

  MonSuivi({
    required this.actions,
    required this.demarches,
    required this.rendezvous,
    required this.sessionsMilo,
    required this.errorOnSessionMiloRetrieval,
    required this.dateDerniereMiseAJourPoleEmploi,
  });

  factory MonSuivi.fromMiloJson(dynamic json) {
    final jsonSessionMilo = json["sessionsMilo"];
    return MonSuivi(
      actions: (json["actions"] as List).map(UserAction.fromJson).toList(),
      rendezvous: (json["rendezVous"] as List).map((e) => JsonRendezvous.fromJson(e).toRendezvous()).toList(),
      sessionsMilo: jsonSessionMilo != null ? (jsonSessionMilo as List).map(SessionMilo.fromJson).toList() : [],
      errorOnSessionMiloRetrieval: jsonSessionMilo == null,
      demarches: [],
      dateDerniereMiseAJourPoleEmploi: null,
    );
  }

  factory MonSuivi.fromPoleEmploiJson(dynamic json) {
    return MonSuivi(
      demarches: (json["resultat"]["demarches"] as List).map(Demarche.fromJson).toList(),
      rendezvous: (json["resultat"]["rendezVous"] as List) //
          .map(JsonRendezvous.fromJson)
          .map((e) => e.toRendezvous())
          .toList(),
      actions: [],
      sessionsMilo: [],
      errorOnSessionMiloRetrieval: false,
      dateDerniereMiseAJourPoleEmploi: (json["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone(),
    );
  }

  MonSuivi concatenate(MonSuivi monSuivi) {
    return MonSuivi(
      actions: [...actions, ...monSuivi.actions],
      demarches: [...demarches, ...monSuivi.demarches],
      rendezvous: [...rendezvous, ...monSuivi.rendezvous],
      sessionsMilo: [...sessionsMilo, ...monSuivi.sessionsMilo],
      errorOnSessionMiloRetrieval: errorOnSessionMiloRetrieval || monSuivi.errorOnSessionMiloRetrieval,
      dateDerniereMiseAJourPoleEmploi: monSuivi.dateDerniereMiseAJourPoleEmploi,
    );
  }

  MonSuivi copyWith({
    List<UserAction>? actions,
    List<Demarche>? demarches,
    List<Rendezvous>? rendezvous,
    List<SessionMilo>? sessionsMilo,
    bool? errorOnSessionMiloRetrieval,
    DateTime? dateDerniereMiseAJourPoleEmploi,
  }) {
    return MonSuivi(
      actions: actions ?? this.actions,
      demarches: demarches ?? this.demarches,
      rendezvous: rendezvous ?? this.rendezvous,
      sessionsMilo: sessionsMilo ?? this.sessionsMilo,
      errorOnSessionMiloRetrieval: errorOnSessionMiloRetrieval ?? this.errorOnSessionMiloRetrieval,
      dateDerniereMiseAJourPoleEmploi: dateDerniereMiseAJourPoleEmploi ?? this.dateDerniereMiseAJourPoleEmploi,
    );
  }

  @override
  List<Object?> get props => [
        actions,
        demarches,
        rendezvous,
        sessionsMilo,
        errorOnSessionMiloRetrieval,
        dateDerniereMiseAJourPoleEmploi,
      ];
}
