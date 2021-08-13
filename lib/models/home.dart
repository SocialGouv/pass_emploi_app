import 'package:pass_emploi_app/models/conseiller.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class Home {
  final List<UserAction> actions;
  final Conseiller conseiller;

  Home({required this.actions, required this.conseiller});

  factory Home.fromJson(dynamic json) {
    return Home(
        actions: (json['actions'] as List).map((action) => UserAction.fromJson(action)).toList(),
        conseiller: Conseiller.fromJson(json['conseiller']));
  }
}