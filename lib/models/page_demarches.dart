import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class PageDemarches extends Equatable {
  final List<Demarche> demarches;
  final DateTime? dateDerniereMiseAJour;

  PageDemarches({required this.demarches, this.dateDerniereMiseAJour});

  factory PageDemarches.fromJson(dynamic json) {
    final dateDerniereMiseAJour = (json["dateDerniereMiseAJour"] as String?)?.toDateTimeUtcOnLocalTimeZone();
    final result = json["resultat"];
    final demarches = (result["actions"] as List).map((demarche) => Demarche.fromJson(demarche)).toList();
    return PageDemarches(demarches: demarches, dateDerniereMiseAJour: dateDerniereMiseAJour);
  }

  @override
  List<Object?> get props => [demarches, dateDerniereMiseAJour];
}
