import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class PageActions extends Equatable {
  final List<UserAction> actions;

  PageActions({required this.actions});

  factory PageActions.fromJson(dynamic json) {
    final actions = (json["actions"] as List).map((action) => UserAction.fromJson(action)).toList();
    return PageActions(actions: actions);
  }

  @override
  List<Object?> get props => [actions];
}
