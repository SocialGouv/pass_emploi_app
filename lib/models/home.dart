import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class Home {
  final Conseiller conseiller;
  final int doneActionsCount;
  final List<UserAction> actions;
  final List<Rendezvous> rendezvous;

  Home({
    required this.conseiller,
    required this.doneActionsCount,
    required this.actions,
    required this.rendezvous,
  });

  factory Home.fromJson(dynamic json) {
    return Home(
      conseiller: Conseiller.fromJson(json['conseiller']),
      doneActionsCount: json['doneActionsCount'] as int,
      actions: (json['actions'] as List).map((action) => UserAction.fromJson(action)).toList(),
      rendezvous: (json['rendezvous'] as List).map((rdv) => Rendezvous.fromJson(rdv)).toList(),
    );
  }
}
