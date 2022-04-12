import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class JsonDetailsJeune {}

class DetailsJeune extends Equatable {
  final DetailsJeuneConseiller conseiller;

  DetailsJeune({required this.conseiller});

  factory DetailsJeune.fromJson(dynamic json) {
    return DetailsJeune(
      conseiller: DetailsJeuneConseiller.fromJson(json['conseiller']),
    );
  }
  @override
  List<Object> get props => [conseiller];
}

class DetailsJeuneConseiller extends Equatable {
  final String firstname;
  final String lastname;
  final DateTime sinceDate;

  DetailsJeuneConseiller({required this.firstname, required this.lastname, required this.sinceDate});

  factory DetailsJeuneConseiller.fromJson(dynamic json) {
    return DetailsJeuneConseiller(
      firstname: json['prenom'] as String,
      lastname: json['nom'] as String,
      sinceDate: (json['depuis'] as String).toDateTimeUtcOnLocalTimeZone(),
    );
  }

  @override
  List<Object> get props => [firstname, lastname, sinceDate];
}
