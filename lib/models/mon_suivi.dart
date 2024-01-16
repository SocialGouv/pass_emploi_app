import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/repositories/rendezvous/json_rendezvous.dart';

class MonSuivi extends Equatable {
  final List<UserAction> actions;
  final List<Rendezvous> rendezvous;
  final List<SessionMilo> sessionsMilo;

  MonSuivi({
    required this.actions,
    required this.rendezvous,
    required this.sessionsMilo,
  });

  factory MonSuivi.fromJson(dynamic json) {
    return MonSuivi(
      actions: (json["actions"] as List).map(UserAction.fromJson).toList(),
      rendezvous: (json["rendezVous"] as List).map((e) => JsonRendezvous.fromJson(e).toRendezvous()).toList(),
      sessionsMilo: (json["sessionsMilo"] as List).map(SessionMilo.fromJson).toList(),
    );
  }

  @override
  List<Object?> get props => [actions, rendezvous, sessionsMilo];
}
