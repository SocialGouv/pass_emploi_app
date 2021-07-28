import 'package:pass_emploi_app/models/user_action.dart';

class Home {
  final List<UserAction> actions;

  Home({required this.actions});

  factory Home.fromJson(dynamic json) {
    return Home(
      actions: (json['actions'] as List).map((action) => UserAction.fromJson(action)).toList(),
    );
  }
}
