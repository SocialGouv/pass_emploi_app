import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action.dart';

class HomeActions extends Equatable {
  final List<UserAction> actions;
  final Campagne? campagne;

  HomeActions({required this.actions, this.campagne});

  factory HomeActions.fromJson(dynamic json) {
    final actions = (json["actions"] as List).map((action) => UserAction.fromJson(action)).toList();
    final campagne = Campagne.fromJson(json["campagne"]);
    return HomeActions(actions: actions, campagne: campagne);
  }

  @override
  List<Object?> get props => [actions, campagne];
}