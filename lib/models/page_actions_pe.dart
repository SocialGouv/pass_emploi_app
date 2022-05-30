import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';

class PageActionsPE extends Equatable {
  final List<UserActionPE> actions;
  final Campagne? campagne;

  PageActionsPE({required this.actions, this.campagne});

  factory PageActionsPE.fromJson(dynamic json) {
    final actions = (json["actions"] as List).map((action) => UserActionPE.fromJson(action)).toList();
    final campagne = json["campagne"] != null ? Campagne.fromJson(json["campagne"]) : null;
    return PageActionsPE(actions: actions, campagne: campagne);
  }

  @override
  List<Object?> get props => [actions, campagne];
}
