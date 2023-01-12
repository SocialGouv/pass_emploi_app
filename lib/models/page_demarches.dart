import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class PageDemarches extends Equatable {
  final List<Demarche> demarches;
  final Campagne? campagne;
  final DateTime? dateDerniereMiseAJour;

  PageDemarches({required this.demarches, this.campagne, this.dateDerniereMiseAJour});

  factory PageDemarches.fromJson(dynamic json) {
    final result = json["resultat"];
    final demarches = (result["actions"] as List).map((demarche) => Demarche.fromJson(demarche)).toList();
    final dateDerniereMiseAJour = (result["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone();
    final campagne = result["campagne"] != null ? Campagne.fromJson(result["campagne"]) : null;
    return PageDemarches(demarches: demarches, campagne: campagne, dateDerniereMiseAJour: dateDerniereMiseAJour);
  }

  @override
  List<Object?> get props => [demarches, campagne, dateDerniereMiseAJour];
}
