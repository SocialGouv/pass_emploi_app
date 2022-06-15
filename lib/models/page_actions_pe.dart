import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/demarche.dart';

class PageActionsPE extends Equatable {
  final List<Demarche> demarches;
  final Campagne? campagne;

  PageActionsPE({required this.demarches, this.campagne});

  factory PageActionsPE.fromJson(dynamic json) {
    final demarches = (json["actions"] as List).map((demarche) => Demarche.fromJson(demarche)).toList();
    final campagne = json["campagne"] != null ? Campagne.fromJson(json["campagne"]) : null;
    return PageActionsPE(demarches: demarches, campagne: campagne);
  }

  @override
  List<Object?> get props => [demarches, campagne];
}
