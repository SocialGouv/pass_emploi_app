import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class ComptageDesHeures extends Equatable {
  final double nbHeuresDeclarees;
  final double nbHeuresValidees;
  final DateTime dateDerniereMiseAJour;

  ComptageDesHeures({
    required this.nbHeuresDeclarees,
    required this.nbHeuresValidees,
    required this.dateDerniereMiseAJour,
  });

  @override
  List<Object?> get props => [
        nbHeuresDeclarees,
        nbHeuresValidees,
        dateDerniereMiseAJour,
      ];

  factory ComptageDesHeures.fromJson(dynamic json) {
    final nbHeuresDeclarees = json['nbHeuresDeclarees'] as num;
    final nbHeuresValidees = json['nbHeuresValidees'] as num;
    final dateDerniereMiseAJour = (json['dateDerniereMiseAJour'] as String).toDateTimeUtcOnLocalTimeZone();
    return ComptageDesHeures(
      nbHeuresDeclarees: nbHeuresDeclarees.toDouble(),
      nbHeuresValidees: nbHeuresValidees.toDouble(),
      dateDerniereMiseAJour: dateDerniereMiseAJour,
    );
  }
}
