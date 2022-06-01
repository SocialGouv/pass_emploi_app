import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class PageActions extends Equatable {
  final List<UserAction> actions;
  final Campagne? campagne;

  PageActions({required this.actions, this.campagne});

  factory PageActions.fromJson(dynamic json) {
    final actions = (json["actions"] as List).map((action) => UserAction.fromJson(action)).toList();
    final campagne = json["campagne"] != null ? Campagne.fromJson(json["campagne"]) : null;
    return PageActions(actions: actions, campagne: campagne);
  }

  @override
  List<Object?> get props => [actions, campagne];
}
